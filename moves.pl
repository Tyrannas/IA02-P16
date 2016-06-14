:-consult("service").
:- consult("init").

succ(1,_,gauche,[]).
succ(X,Y,gauche,Res):- X1 is X-1, parse(Res,X1,Y).
succ(6,_,droite,[]).
succ(X,Y,droite,Res):- X1 is X+1, parse(Res,X1,Y).
succ(_,6,haut,[]).
succ(X,Y,haut,Res):- Y1 is Y+1, parse(Res,X,Y1).
succ(_,1,bas,[]).
succ(X,Y,bas,Res):- Y1 is Y-1, parse(Res,X,Y1).

/*permet de trouver la liste des successeurs valides d'une case*/
succValides(Case,Res):- parse(Case,X,Y),succ(X,Y,gauche,ResG),succ(X,Y,droite,ResD),succ(X,Y,haut,ResH),succ(X,Y,bas,ResB), 
					append([ResG],[ResD],Res2),append(Res2,[ResH],Res3),append(Res3,[ResB],Res4), flatten(Res4,Res).

/*fonction de service permettant de renvoyer l'element à conserver si il n'est pas présent sur la liste des pions et [] sinon*/
testIfOcuppied(Elem,false,[Elem]).
testIfOcuppied(Elem,true,[]).
/*Cas ou c'est le dernier mouvement*/
/*Cas ou le joueur cherche à jouer son dernier coup, il peut donc manger un pion ennemi, on ne retire donc la case que si elle est occuppee par un allié*/
retireSuccOccupe([],_,Res,Res,1):-write("Fin Iter"),nl.
retireSuccOccupe([T|Q],rouge,L2,Res,1):- getAllPiecesR(Pions),parse(T,X,Y),memberL([X,Y],Pions,Bool),
									testIfOcuppied(T,Bool,Val),append(Val,L2,L3), 
									retireSuccOccupe(Q,rouge,L3,Res,1).

retireSuccOccupe([T|Q],ocre,L2,Res,1):- getAllPiecesO(Pions),parse(T,X,Y),memberL([X,Y],Pions,Bool),
									testIfOcuppied(T,Bool,Val),append(Val,L2,L3), 
									retireSuccOccupe(Q,ocre,L3,Res,1).

retireSuccOccupe([],_,L2,L2,_).
retireSuccOccupe([T|Q],Player,L2,Res,N):- getAllPieces(Pions),parse(T,X,Y),memberL([X,Y],Pions,Bool),
									testIfOcuppied(T,Bool,Val), append(Val,L2,L3),
									retireSuccOccupe(Q,Player,L3,Res,1).

getAllSucc(N,Case,ListePos):-succValides(Case,Res),joueurCourant(Player),retireSuccOccupe(Res,Player,[],ListePos,N),write(Case),write(ListePos),nl.

getAllSuccRecur(Liste,0,Liste).
getAllSuccRecur([Case|ListeCase],N,Res):-getAllSucc(N,Case,NewList), N1 is N-1, getAllSuccRecur(ListeCase,N,Res), getAllSuccRecur(NewList,N1,Res). 

getAllSuccTest(Case,0).
getAllSuccTest(Case,1,Res):- getAllSucc(1,Case,Res), assert(moves(Res)).
getAllSuccTest(Case,2, Res):- getAllSucc(2,Case,ListePos), getAllSuccListe(ListePos,1,Res).
getAllSuccTest(Case,3,Res):- getAllSucc(3,Case,ListePos), getAllSuccListe(ListePos,2,Res).

getAllSuccListe([],_,_).
getAllSuccListe([T|Q],N,Res):- getAllSuccTest(T,N,Res1), getAllSuccListe(Q,N,Res2), append(Res1,Res2,Res). 

