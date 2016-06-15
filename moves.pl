
%Trouve le successeur sur le plateau d'une case en fonction d'une direction donnée.
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
%retireSuccOccupe permet de retirer de la liste des successeurs une case si elle est occuppee par un pion, sauf si c'est le dernier coup, ou il peut manger le pion adverse.
/*Cas ou c'est le dernier mouvement*/
/*Cas ou le joueur cherche à jouer son dernier coup, il peut donc manger un pion ennemi, on ne retire donc la case que si elle est occuppee par un allié*/
retireSuccOccupe([],_,Res,Res,1).
retireSuccOccupe([T|Q],rouge,L2,Res,1):- getAllPiecesR(Pions),parse(T,X,Y),memberL([X,Y],Pions,Bool),
									testIfOcuppied(T,Bool,Val),append(Val,L2,L3), 
									retireSuccOccupe(Q,rouge,L3,Res,1).

retireSuccOccupe([T|Q],ocre,L2,Res,1):- getAllPiecesO(Pions),parse(T,X,Y),memberL([X,Y],Pions,Bool),
									testIfOcuppied(T,Bool,Val),append(Val,L2,L3), 
									retireSuccOccupe(Q,ocre,L3,Res,1).
/*Cas ou le joueur est bloqué s'il tombe sur un pion ennemi*/
retireSuccOccupe([],_,L2,L2,_).
retireSuccOccupe([T|Q],Player,L2,Res,N):- getAllPieces(Pions),parse(T,X,Y),memberL([X,Y],Pions,Bool),
									testIfOcuppied(T,Bool,Val), append(Val,L2,L3),
									retireSuccOccupe(Q,Player,L3,Res,1).

%retourne tous les successeurs directs d'une case.
getSucc(N,Case,ListePos):-succValides(Case,Res),joueurCourant(Player),retireSuccOccupe(Res,Player,[],ListePos,N).

%retourne les successeurs sur N niveaux d'une case.
getAllSucc(Case,1,Res):-getSucc(1,Case,Res).
getAllSucc(Case,N,Res):- getSucc(N,Case,ListePos), N1 is N-1, getAllSuccListe(ListePos,N1,Res,Case).

%fonction de service de la précédente
getAllSuccListe([],_,_,_).
getAllSuccListe([Case|Q],N,Res,Parent):- getAllSucc(Case,N,Res1), testParent(Parent,Res1,Res2),getAllSuccListe(Q,N,Res3,Parent), append(Res2,Res3,Res). 

/*permet de tester que l'on est pas déjà passé par une case*/
testParent(Parent,Enfants,Res):-member(Parent,Enfants),del(Parent,Enfants,Res).
testParent(Parent,Enfants,Enfants).

%permet de trouver tous les mouvements autorisés pour une case, 
mouvementsPossiblesCase(Case,Res2):- parse(Case,X,Y), findTypeCase(X,Y,Type), getAllSucc(Case,Type,Res), dupListe(Res,Res1), delDoublons(Res1,Res2).

%calcule tous les mouvements possibles pour une liste de pions*/
calculeNbMouvements([],Acc,Res):-length(Acc,Res).
calculeNbMouvements([[X , Y]|Q],Acc,Res):- parse(Case,X,Y),mouvementsPossiblesCase(Case,Res1), append(Acc,Res1,Res2), calculeNbMouvements(Q,Res2,Res).
%% getAllSuccTest(Case,0).
%% getAllSuccTest(Case,1,Res):- getAllSucc(1,Case,Res), assert(moves(Res)).
%% getAllSuccTest(Case,2, Res):- getAllSucc(2,Case,ListePos), getAllSuccListe(ListePos,1,Res).
%% getAllSuccTest(Case,3,Res):- getAllSucc(3,Case,ListePos), getAllSuccListe(ListePos,2,Res).


