setPlateauBas:-retractall(plateau(X)),assert(plateau([	
					[2,3,1,2,2,3],
					[2,1,3,1,3,1],
					[1,3,2,3,1,2],
					[3,1,2,1,3,2],
					[2,3,1,3,1,3],
					[2,1,3,2,2,1]])).

setPlateauGauche:-retractall(plateau(X)),assert(plateau([	
			[3,1,2,2,3,1],
			[2,2,1,3,1,2],
			[2,1,3,1,3,2],
			[1,3,2,2,1,3],
			[3,1,3,1,3,1],
			[2,2,1,3,2,2]
			])).


setPlateauDroite:-retractall(plateau(X)),assert(plateau([	
			[2,2,3,1,2,2],
			[1,3,1,3,1,3],
			[3,1,2,2,3,1],
			[2,3,1,3,1,2],
			[2,1,3,1,3,2],
			[1,3,2,2,1,3]])).

setPlateauHaut:-retractall(plateau(X)),assert(plateau([	
			[1,2,2,3,1,2],
			[3,1,3,1,3,2],
			[2,3,1,2,1,3],
			[2,1,3,2,3,1],
			[1,3,1,1,3,2],
			[3,2,2,1,3,2]])).
%plateau
:-dynamic plateau/1.
%kalista rouge
:-dynamic kalistaR/2.
%kalista ocre
:-dynamic kalistaO/2.
%sbires rouge
:-dynamic sbireR/2.
%sbires ocre
:-dynamic sbireO/2.
%khan
:-dynamic khan/2.
%joueurCourant
:-dynamic joueurCourant/1.
%joueurRouge
:-dynamic jRouge/1.
%joueurOcre
:-dynamic jOcre/1.
%moves
:-dynamic moves/1.


resetPions:- assert(khan(0,0)), retractall(sbireO(_,_)), retractall(sbireR(_,_)), retractall(kalistaR(_,_)), retractall(kalistaO(_,_)).
getAllPiecesR(Res):- findall([X,Y],sbireR(X,Y),L),kalistaR(W,Z),append(L,[[W,Z]],Res).
getAllPiecesO(Res):- findall([X,Y],sbireO(X,Y),L),kalistaO(W,Z),append(L,[[W,Z]],Res).
getAllPieces(Res):-getAllPiecesR(X), getAllPiecesO(Y), append(X,Y,Res).
setKhan(Pos):-parse(Pos,X,Y), retractall(khan(X1,Y1)), assert(khan(X,Y)).

parse(out,0,0).

parse(a1,1,1).
parse(a2,1,2).
parse(a3,1,3).
parse(a4,1,4).
parse(a5,1,5).
parse(a6,1,6).

parse(b1,2,1).
parse(b2,2,2).
parse(b3,2,3).
parse(b4,2,4).
parse(b5,2,5).
parse(b6,2,6).

parse(c1,3,1).
parse(c2,3,2).
parse(c3,3,3).
parse(c4,3,4).
parse(c5,3,5).
parse(c6,3,6).

parse(d1,4,1).
parse(d2,4,2).
parse(d3,4,3).
parse(d4,4,4).
parse(d5,4,5).
parse(d6,4,6).

parse(e1,5,1).
parse(e2,5,2).
parse(e3,5,3).
parse(e4,5,4).
parse(e5,5,5).
parse(e6,5,6).

parse(f1,6,1).
parse(f2,6,2).
parse(f3,6,3).
parse(f4,6,4).
parse(f5,6,5).
parse(f6,6,6).

parse(_,_,_):-write('entrez une case valide merci'), read(X), parse(X,Y,Z), nl.

positionsPossiblesRouge([a1,b1,c1,d1,e1,f1,a2,b2,c2,d2,e2,f2]).
positionsPossiblesOcre([a5,b5,c5,d5,e5,f5,a6,b6,c6,d6,e6,f6]).

retireNiemeElement([T|Q],1,L2, Res, T):-append(L2,Q,Res).
retireNiemeElement([T|Q],N,L1, Res, Elem):-append([T],L1,L2), N1 is N - 1, retireNiemeElement(Q, N1, L2, Res, Elem). 

retireElement([Elem|Q],Elem,L2,Res):-append(L2,Q,Res).
retireElement([T|Q],Elem,L1,Res):- append(L1,[T],L2), retireElement(Q,Elem,L2,Res).

estLibre(X,Y):-not(sbireO(X,Y)), not(sbireR(X,Y)), not(kalistaO(X,Y)), not(kalistaR(X,Y)).
estSurTerrain(X,Y):- X < 7, X > 0, Y < 7, Y > 0.

changementJoueur:-joueurCourant(X),changeJoueur(X).
changeJoueur(rouge):-retractall(joueurCourant(X)), assert(joueurCourant(ocre)).
changeJoueur(ocre):-retractall(joueurCourant(X)), assert(joueurCourant(rouge)).

/*fonction pour inverser une liste en utilisant un accumulateur.*/
rev(L,R):-  accRev(L,[],R).
accRev([H|T],A,R):-  accRev(T,[H|A],R). 
accRev([],A,A).

/*teste si une liste est dans une sous listeù*/

memberL(L1,[],false).
memberL(L1,[L1|Q],true).
memberL(L1,[T|Q],Bool):-memberL(L1,Q,Bool).

initTest:-setPlateauGauche,assert(joueurCourant(rouge)), resetPions, placementOrdiRouge,placementOrdiOcre.

del(X,[X|Tail],Tail).
del(X,[Y|Tail],[Y|Tail1]):- del(X,Tail,Tail1).

delDoublons([],[]).
delDoublons([T|Q],[T|Q1]):-not(member(T,Q)),delDoublons(Q,Q1).
delDoublons([T|Q],Q1):-member(T,Q),delDoublons(Q,Q1).

delLast([_],[]).
delLast([T|Q],[T|Q1]):-delLast(Q,Q1).

afficheListe([]).
afficheListe([T|Q]):-write(T), afficheListe(Q).

dupListe([],[]).
dupListe([T|Q],[T|Q1]):-dupListe(Q,Q1). 

estTypeCase1(X,Y):-findTypeCase(X,Y,TYPE),TYPE =:= 1.
estTypeCase2(X,Y):-findTypeCase(X,Y,TYPE),TYPE =:= 2.
estTypeCase3(X,Y):-findTypeCase(X,Y,TYPE),TYPE =:= 3.

