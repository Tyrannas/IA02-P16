%permet de savoir si un joueur a des pions mangés. 
:-consult("service").
:- consult("init").
:- consult("moves").

pionsAPlacer(rouge):-nbPionsRouge(N), not(N =:= 0).
pionsAPlacer(ocre):-nbPionsOcre(N), not(N =:= 0).
nbPionsOcre(R):-findall(X, sbireO(X,_), L), length(L,N), N is 6-N.
nbPionsRouge(R):-findall(X, sbireR(X,_), L), length(L,N), R is 6-N.

pionsSurTypeKhan(Pions,Res):-khan(X,Y),findTypeCase(X,Y,Type), findCaseDeType(Pions,Type,[],Res).

findTypeCase(X,Y,TYPE):-plateau(P),rev(P,P1),flatten(P1,P2), N is (Y-1)*6 + X - 1, findCase(P2,N,TYPE).
findCase([R|_],0,R):-!.
findCase([T|Q],N,R):- N1 is N-1, findCase(Q,N1,R).

findCaseDeType([],_,Res,Res).
findCaseDeType([[X|[Y|_]]|Q],Type,Liste,Res):-parse(Case,X,Y),write(Case),findTypeCase(X,Y,Type2),checkType(Type,Type2,Case,OutPut),append(Liste,OutPut,Liste2),findCaseDeType(Q,Type,Liste2,Res).

checkType(Type,Type,Res,[Res]).
checkType(_,_,_,[]).

estTypeCase1(X,Y):-findTypeCase(X,Y,TYPE),TYPE =:= 1.
estTypeCase2(X,Y):-findTypeCase(X,Y,TYPE),TYPE =:= 2.
estTypeCase3(X,Y):-findTypeCase(X,Y,TYPE),TYPE =:= 3.

setKhan(Pos):-parse(Pos,X,Y), retractall(khan(X1,Y1)), assert(khan(X,Y)).

/*====FONCTION DE TOUR HUMAIN========*/
/*On check si le khan est posé*/
/*On évalue les pions jouables*/
/*On calcule et propose les mouvements possibles*/
/*Le joueur choisit où bouger son pion*/
/*On check si la Kalista adverse est prise*/
/*On pose le Khan*/
/*On passe au joueur suivant*/

tourHumain:-joueurCourant(Player), khan(X,Y), parse(K,X,Y), mouvementsPossibles(ListePions,ListePos,Player,K),
				write('Quel sbire voulez vous jouer parmi les pions suivants?'),nl,
				write(ListePions),nl 
				read(Pion), nl, 
				write('Ou voulez vous le jouer?(entrer 0 pour changer de sbire à jouer.'),
				write('')
				read(Pos), nl,
				checkMouvement(Pos,Pion,ListePos).

checkMouvement(0,_,_):-tourHumain.
checkMouvement(Pos,Pion,Liste):- member(Pos,Liste), !, movePiece(Pion), setKhan(Pion), changementJoueur, endTurn. 
checkMouvement(Pos,Pion,Liste):- not(member(Pos,L)), ('Entrez une position autorisee merci'), nl, tourHumain.

endTurn:-joueurCourant(X), checkTypeJoueur(X).
checkTypeJoueur(rouge):-jRouge(Type), tourSuivant(Type).
checkTypeJoueur(ocre):-jOcre(Type), tourSuivant(Type).

tourSuivant(humain):-tourHumain.
tourSuivant(ordi):-tourOrdi.

tourOrdi:- joueurCourant(Player), mouvementsPossibles(ListePions,ListePos,Player), genereMouvement(ListePos), changeJoueur(Player), checkTypeJoueur(Player).

mouvementsPossibles(ListePions,ListePos, rouge, out):- getAllPiecesR(Pions), mouvementSansKhan(ListePions,ListePos,Pions).
mouvementsPossibles(ListePions,ListePos, rouge, _):- getAllPiecesR(Pions), mouvementAvecKhan(ListePions,ListePos,Pions).
mouvementsPossibles(ListePions,ListePos, ocre, out):- getAllPiecesO(Pions), mouvementSansKhan(ListePions,ListePos,Pions).
mouvementsPossibles(ListePions,ListePos, ocre, _):- getAllPiecesO(Pions), mouvementAvecKhan(ListePions,ListePos,Pions).
/*test2([[X|[Y|_]]|Q]):-parse(Res,X,Y),write(Res).*/
mouvementSansKhan.
mouvementAvecKhan(ListePions,ListePos,Pions):-pionsSurTypeKhan(Pions,Res),calculeMouvement(Res,ListePos,ListePions).





