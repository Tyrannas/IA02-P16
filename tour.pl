%permet de savoir si un joueur a des pions mangés. 
:- consult("moves").

/*====FONCTION DE TOUR HUMAIN========*/
/*On check si le khan est posé*/
/*On évalue les pions jouables*/
/*On calcule et propose les mouvements possibles*/
/*Le joueur choisit où bouger son pion*/
/*On check si la Kalista adverse est prise*/
/*On pose le Khan*/
/*On passe au joueur suivant*/


tourHumain:- write("--------Joueur: "), joueurCourant(Player), write(Player), write("---------"),nl,
			choixPiece(Pion),choixMove(Pion,Case), finTour(Pion,Case).

choixPiece(Pion):- getPossibles(Res,Bool),proposeCoups(Res,Bool,Pion1),checkPion(Pion1,Res,Pion). 

choixMove(Pion,Case):- mouvementsPossiblesCase(Pion,Positions), proposeMoves(Positions, Case).


proposeCoups(Pions,true,Pion):-write("Vous pouvez jouez une piece parmis les suivantes ou poser un pion (entrer 1)."),nl,
							write(Pions),nl,read(Pion).
proposeCoups(Pions,_,Pion):-write("Vous pouvez jouez une piece parmi les suivantes"),nl,
							write(Pions),nl,read(Pion).

proposeMoves(Positions,Case):-write("Ou voulez vous jouer la piece?"), nl, write(Positions), read(Case), nl,member(Case,Positions).
proposeMoves(_,_):-write("-------------Move invalide-----------"), nl, tourHumain.

finTour(Pion,Case):- checkMange(Case), bougePiece(Pion,Case), setKhan(Case),endTurn.
finTour(_,_):- joueurCourant(Player),assert(winner(Player)).
%%cas ou le khan n'est pas encore en jeu
getPossibles(Res,false):-khan(0,0), joueurCourant(Player),getPiecesJoueur(Res1,Player), casesJouables(Res1,Res).
%%cas ou des pions peuvent obéir au khan
getPossibles(Res,false):-joueurCourant(Player),getPiecesJoueur(Pions,Player), pionsSurTypeKhanJouables(Pions,Res).
%%cas ou aucun pion ne peut obéir au khan et peut jouer des pions
getPossibles(Res,true):- joueurCourant(Player), getPiecesJoueur(Res1, Player), casesJouables(Res1,Res), pionsAPlacer(Player).
%%cas ou aucun pion ne peut obéir au khan et ne peut aps jouer de pions
getPossibles(Res,false):- joueurCourant(Player), not(pionsAPlacer(Player)), getPiecesJoueur(Res1, Player), casesJouables(Res1,Res).

checkPion(1,_,_):-write("Ou voulez vous le poser?"), read(Pos), nl,posePion(Pos).
checkPion(Pion,Pions,Pion):-member(Pion,Pions).
checkPion(_,_,_):-write("------------Piece invalide----------"), nl,tourHumain.

%soit on arrive sur une case libre
checkMange(Case):- parse(Case,X,Y), estLibre(X,Y).
%soit sur une case occupee par un sbire ocre
checkMange(Case):- parse(Case,X,Y), sbireO(X,Y), retract(sbireO(X,Y)). 
%soit sur une case occupee par un sbire rouge
checkMange(Case):- parse(Case,X,Y), sbireR(X,Y), retract(sbireR(X,Y)). 
%sinon c'est qu'une kalista a été mangée
checkMange(_).



endTurn:-changementJoueur, joueurCourant(X), checkTypeJoueur(X).
checkTypeJoueur(rouge):-jRouge(Type), affichePlateau, tourSuivant(Type).
checkTypeJoueur(ocre):-jOcre(Type), affichePlateau, tourSuivant(Type).

%predicat permettant de passer au joueur suivant, s'arrête si un gagnant est détecté
tourSuivant(_):-winner(X), write("----------Le joueur "), write(X), write(" gagne la partie!!-----------"),!. 
tourSuivant(humain):-tourHumain.
tourSuivant(ordi):-tourOrdi.

%% tourOrdi. %%:- joueurCourant(Player), possibilitesJoueur(_,ListePos,Player), genereMouvement(ListePos), changeJoueur(Player), checkTypeJoueur(Player).


%permet de poser un pion et de terminer le tour
posePion(Pos):-parse(Pos,X,Y),estLibre(X,Y),caseTypeKhan(Pos),joueurCourant(Player), posePionService(Player,X,Y), setKhan(Pos),endTurn,!.
posePion(Pos):-parse(Pos,X,Y),estLibre(X,Y),not(caseTypeKhan(Pos)), write("la case doit etre du type du khan"), nl, checkPion(1,_,_).
posePion(Pos):-parse(Pos,X,Y),not(estLibre(X,Y)), write("case occupee"), nl, checkPion(1,_,_).

