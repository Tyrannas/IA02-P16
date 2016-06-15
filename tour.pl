%permet de savoir si un joueur a des pions mangés. 
:-consult("service").
:- consult("init").
:- consult("moves").

/*====FONCTION DE TOUR HUMAIN========*/
/*On check si le khan est posé*/
/*On évalue les pions jouables*/
/*On calcule et propose les mouvements possibles*/
/*Le joueur choisit où bouger son pion*/
/*On check si la Kalista adverse est prise*/
/*On pose le Khan*/
/*On passe au joueur suivant*/

tourHumain:-joueurCourant(Player), write("au joueur "), write(Player), write(" de jouer"),nl,
				khan(X,Y), parse(K,X,Y),
				possibilitesJoueur(Player,K),
				write('Ou voulez vous le jouer?(entrer 0 pour changer de sbire à jouer.'),nl,
				mouvementsPossiblesCase(Pion, ListePos),
				write('Deplacements autorisés: '), write(ListePos),nl,
				read(Pos), nl,
				checkMouvement(Pos,Pion,ListePos).

checkMouvement(0,_,_):-tourHumain.
checkMouvement(Pos,Pion,Liste):- member(Pos,Liste), movePiece(Pion), setKhan(Pion), changementJoueur, endTurn. 
checkMouvement(Pos,Pion,Liste):- not(member(Pos,L)), ('Entrez une position autorisee merci'), nl, tourHumain.

endTurn:-joueurCourant(X), checkTypeJoueur(X).
checkTypeJoueur(rouge):-jRouge(Type), tourSuivant(Type).
checkTypeJoueur(ocre):-jOcre(Type), tourSuivant(Type).

tourSuivant(humain):-tourHumain.
tourSuivant(ordi):-tourOrdi.

tourOrdi:- joueurCourant(Player), possibilitesJoueur(ListePions,ListePos,Player), genereMouvement(ListePos), changeJoueur(Player), checkTypeJoueur(Player).

%%rouge joue et le khan n'est pas encore en jeu
possibilitesJoueur(Pion, rouge, out):- getAllPiecesR(Pions), proposeCoupsSansKhan(Res,Pion).
%%rouge joue et le khan et en jeu mais il ne peut pas jouer de pions 
possibilitesJoueur(Pion, rouge, _):- getAllPiecesR(Pions), not(pionsSurTypeKhan(Pions,Res)),proposeCoupsSansKhan(Res,Pion).
%%rouge joue, le khan est en jeu, et le joueur a des pions sur des cases du même type
possibilitesJoueur(Pion, rouge, _):- getAllPiecesR(Pions), pionsSurTypeKhan(Pions,Res),proposeCoups(Res,Pion).
%%ocre joue et le khan n'est pas encore en jeu
possibilitesJoueur(Pion, ocre, out):- getAllPiecesO(Pions), proposeCoupsSansKhan(Res,Pion).
%%ocre joue et le khan et en jeu mais il ne peut pas jouer de pions 
possibilitesJoueur(Pion, ocre, _):- getAllPiecesO(Pions), not(pionsSurTypeKhan(Pions,Res)),proposeCoupsSansKhan(Res,Pion).
%%ocre joue, le khan est en jeu, et le joueur a des pions sur des cases du même type
possibilitesJoueur(Pion, ocre, _):- getAllPiecesO(Pions), pionsSurTypeKhan(Pions,Res),proposeCoups(Res,Pion).

%%cas ou le joueur peut jouer un pion sur une case du type du khan
proposeCoups(ListePions,Pion):- write('Quel piece voulez vous jouer parmi les pieces suivants?'),nl,
						write(ListePions),nl, 
						read(Pion),checkPion(ListePions,Pions,khanTrue),nl.

%%cas ou le joueur peut jouer des pions mais pas en poser
proposeCoupsSansKhan(ListePions,Pion):-joueurCourant(Player), not(pionsAPlacer(Player)),
									write('Quel sbire voulez vous jouer piece parmi les pieces suivants?'),nl,
									write(ListePions),nl, 
									read(Pion), checkPion(ListePions,Pions,khanFalse),nl.

%%cas ou le joueur peut jouer des pions et en poser
proposeCoupsSansKhan(ListePions,Pion):-joueurCourant(Player), pionsAPlacer(Player), calculeMouvements(ListePions,N), N > 0,
									write("Quel piece voulez vous jouer parmi les pieces suivants?Vous pouvez également poser un piece sur une case libre (Entrez 1)"),nl,
									write(ListePions),nl, 
									read(Pion), not(Pion = 1),checkPion(ListePions,Pions,khanFalse),nl.

proposeCoupsSansKhan(ListePions,Pion):-joueurCourant(Player), pionsAPlacer(Player), calculeMouvements(ListePions,N), N > 0,
									write("Quel piece voulez vous jouer parmi les pieces suivants?Vous pouvez également poser un piece sur une case libre (Entrez 1)"),nl,
									write(ListePions),nl, 
									read(Pion),Pion = 1,posePion.

%%cas ou le joueur peut poser des pions mais pas en jouer
proposeCoupsSansKhan(ListePions,Pion):-joueurCourant(Player), pionsAPlacer(Player), calculeMouvements(ListePions,N), N = 0,
									write("Vous pouvez placer un piece  sur une case libre"),nl,
									read(Pion), checkPion(ListePions,Pions,khanFalse),nl.

%%Permet de vérifier qu'un pion entré est autorisé
checkPion(ListePions,Pion,khanTrue):-member(Pion,ListePions).
checkPion(ListePions,Pion,khanTrue):-not(member(Pion,ListePions)), write("Piece non autorisée"), proposeCoups(ListePions,Pion).
checkPion(ListePions,Pion,khanTrue):-member(Pion,ListePions).
checkPion(ListePions,Pion,khanTrue):-not(member(Pion,ListePions)), write("Piece non autorisée"), proposeCoupsSansKhan(ListePions,Pion).








%%bloc permettant de savoir si un joueur a des pions à placer 
pionsAPlacer(rouge):-nbPionsRouge(N), not(N = 0).
pionsAPlacer(ocre):-nbPionsOcre(N), not(N = 0).
nbPionsOcre(R):-findall(X, sbireO(X,_), L), length(L,N), N is 6-N.
nbPionsRouge(R):-findall(X, sbireR(X,_), L), length(L,N), R is 6-N.

%%permet de déterminer s'il existe des pions sur une case de type de celle du Khan
pionsSurTypeKhan(Pions,Res):-khan(X,Y),findTypeCase(X,Y,Type), findCaseDeType(Pions,Type,[],Res).

%%permet de trouver le type d'une case.
findTypeCase(X,Y,TYPE):-plateau(P),rev(P,P1),flatten(P1,P2), N is (Y-1)*6 + X - 1, findCase(P2,N,TYPE).
findCase([R|_],0,R):-!.
findCase([T|Q],N,R):- N1 is N-1, findCase(Q,N1,R).

%%permet de trouver les cases d'un type donné dans une liste.
findCaseDeType([],_,Res,Res).
findCaseDeType([[X|[Y|_]]|Q],Type,Liste,Res):-parse(Case,X,Y),write(Case),findTypeCase(X,Y,Type2),checkType(Type,Type2,Case,OutPut),append(Liste,OutPut,Liste2),findCaseDeType(Q,Type,Liste2,Res).
%%fonction de service de la précédente. 
checkType(Type,Type,Res,[Res]).
checkType(_,_,_,[]).
