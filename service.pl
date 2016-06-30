setPlateauBas:-retractall(plateau(_)),assert(plateau([	
					[2,3,1,2,2,3],
					[2,1,3,1,3,1],
					[1,3,2,3,1,2],
					[3,1,2,1,3,2],
					[2,3,1,3,1,3],
					[2,1,3,2,2,1]])).

setPlateauGauche:-retractall(plateau(_)),assert(plateau([	
			[3,1,2,2,3,1],
			[2,3,1,3,1,2],
			[2,1,3,1,3,2],
			[1,3,2,2,1,3],
			[3,1,3,1,3,1],
			[2,2,1,3,2,2]
			])).


setPlateauDroite:-retractall(plateau(_)),assert(plateau([	
			[2,2,3,1,2,2],
			[1,3,1,3,1,3],
			[3,1,2,2,3,1],
			[2,3,1,3,1,2],
			[2,1,3,1,3,2],
			[1,3,2,2,1,3]])).

setPlateauHaut:-retractall(plateau(_)),assert(plateau([	
			[1,2,2,3,1,2],
			[3,1,3,1,3,2],
			[2,3,1,2,1,3],
			[2,1,3,2,1,3],
			[1,3,1,3,1,2],
			[3,2,2,1,3,2]])).


/*================================================
***************MANIPULATION PIECES************************
==================================================*/

resetPions:- assert(khan(0,0)), retractall(sbireO(_,_)), retractall(sbireR(_,_)), retractall(kalistaR(_,_)), retractall(kalistaO(_,_)).
resetPionsSave:- assert(khanSave(0,0)), retractall(sbireOSave(_,_)), retractall(sbireRSave(_,_)), retractall(kalistaRSave(_,_)), retractall(kalistaOSave(_,_)).

getPiecesJoueur(Res,rouge):-getAllPiecesR(Res1), parseListe(Res1,Res).
getPiecesJoueur(Res,ocre):-getAllPiecesO(Res1), parseListe(Res1,Res).

getAllPiecesR(Res):- findall([X,Y],sbireR(X,Y),L),kalistaR(W,Z),append(L,[[W,Z]],Res).
getAllPiecesO(Res):- findall([X,Y],sbireO(X,Y),L),kalistaO(W,Z),append(L,[[W,Z]],Res).
getAllPieces(Res):-getAllPiecesR(X), getAllPiecesO(Y), append(X,Y,Res).
setKhan(Pos):-parse(Pos,X,Y), retractall(khan(_,_)), assert(khan(X,Y)).

bougePiece(Pion,Pos):-parse(Pion,X,Y), sbireR(X,Y), bougeSbire(Pion, Pos, rouge).
bougePiece(Pion,Pos):-parse(Pion,X,Y), sbireO(X,Y), bougeSbire(Pion, Pos, ocre).
bougePiece(Pion,Pos):-parse(Pion,X,Y), kalistaR(X,Y), bougeKalista(Pos, rouge).
bougePiece(Pion,Pos):-parse(Pion,X,Y), kalistaO(X,Y), bougeKalista(Pos, ocre).

bougeKalista(Pos,rouge):-retractall(kalistaR(_,_)), parse(Pos,X,Y),assert(kalistaR(X,Y)).
bougeKalista(Pos,ocre):-retractall(kalistaO(_,_)), parse(Pos,X,Y),assert(kalistaO(X,Y)).
bougeSbire(Pion,Pos,rouge):-parse(Pion,X,Y),retract(sbireR(X,Y)),parse(Pos,X1,Y1),assert(sbireR(X1,Y1)).
bougeSbire(Pion,Pos,ocre):-parse(Pion,X,Y),retract(sbireO(X,Y)),parse(Pos,X1,Y1),assert(sbireO(X1,Y1)).

positionsPossiblesRouge([a1,b1,c1,d1,e1,f1,a2,b2,c2,d2,e2,f2]).
positionsPossiblesOcre([a5,b5,c5,d5,e5,f5,a6,b6,c6,d6,e6,f6]).

getNombreDe(_,[],0).
getNombreDe(X,[X|Q],N):-getNombreDe(X,Q,N1), N is N1 + 1.
getNombreDe(X,[_|Q],N):-getNombreDe(X,Q,N).


estLibre(X,Y):-not(sbireO(X,Y)), not(sbireR(X,Y)), not(kalistaO(X,Y)), not(kalistaR(X,Y)).
estSurTerrain(X,Y):- X < 7, X > 0, Y < 7, Y > 0.

huVSia:- setKhan(out),retractall(winner(_)),retractall(jRouge(_)), retractall(jOcre(_)),assert(jRouge(humain)), assert(jOcre(ordi)), setPlateauGauche, retractall(joueurCourant(_)),assert(joueurCourant(rouge)), resetPions, placementOrdiRouge,placementOrdiOcre, tourHumain.
huVShu:-setKhan(out),retractall(winner(_)),retractall(jRouge(_)), retractall(jOcre(_)),assert(jRouge(humain)), assert(jOcre(humain)), setPlateauGauche, retractall(joueurCourant(_)),assert(joueurCourant(rouge)), resetPions, placementOrdiRouge,placementOrdiOcre, tourHumain.
iaVSia:-setKhan(out),retractall(winner(_)),retractall(jRouge(_)), retractall(jOcre(_)),assert(jRouge(ordi)), assert(jOcre(ordi)), setPlateauGauche, retractall(joueurCourant(_)),assert(joueurCourant(rouge)), resetPions, placementOrdiRouge,placementOrdiOcre, tourOrdi.
/*================================================
***************SERVICE TOUR************************
==================================================*/
%%bloc permettant de savoir si un joueur a des pions à placer 

pionsAPlacer(rouge):-nbPionsRouge(N), not(N = 0).
pionsAPlacer(ocre):-nbPionsOcre(N), not(N = 0).
nbPionsOcre(R):-findall(X, sbireO(X,_), L), length(L,N), R is 5-N.
nbPionsRouge(R):-findall(X, sbireR(X,_), L), length(L,N), R is 5-N.

%%permet de déterminer s'il existe des pions sur une case de type de celle du Khan
pionsSurTypeKhanJouables(Pions,Res):-pionsSurTypeKhan(Pions,Res), calculeNbMouvements(Res,_,N),!, N > 0.
pionsSurTypeKhan(Pions,Res):-khan(X,Y),findTypeCase(X,Y,Type), findCaseDeType(Pions,Type,[],Res).

%%permet de déterminer si une case est du même type que le khan
caseTypeKhan(Case):-khan(X,Y), findTypeCase(X,Y,Type), parse(Case,X1,Y1), findTypeCase(X1,Y1,Type2), Type = Type2.
%%permet de trouver le type d'une case.
findTypeCase(X,Y,TYPE):-plateau(P),rev(P,P1),flatten(P1,P2), N is (Y-1)*6 + X - 1, findCase(P2,N,TYPE).
findCase([R|_],0,R):-!.
findCase([_|Q],N,R):- N1 is N-1, findCase(Q,N1,R).

%%permet de trouver les cases d'un type donné dans une liste.
findCaseDeType([],_,Res,Res).
findCaseDeType([Case|Q],Type,Liste,Res):-parse(Case,X,Y),findTypeCase(X,Y,Type2),checkType(Type,Type2,Case,OutPut),append(Liste,OutPut,Liste2),findCaseDeType(Q,Type,Liste2,Res).
%%fonction de service de la précédente. 
checkType(Type,Type,Res,[Res]).
checkType(_,_,_,[]).

changementJoueur:-joueurCourant(X),changeJoueur(X).
changeJoueur(rouge):-retractall(joueurCourant(_)), assert(joueurCourant(ocre)).
changeJoueur(ocre):-retractall(joueurCourant(_)), assert(joueurCourant(rouge)).

getJoueurOppose(rouge,ocre).
getJoueurOppose(ocre,rouge).
posePionService(rouge,X,Y):-assert(sbireR(X,Y)).
posePionService(ocre,X,Y):-assert(sbireO(X,Y)).

casesJouables([],[]).
casesJouables([X|Q],[X|Q1]):-caseValide(X),casesJouables(Q,Q1).
casesJouables([_|Q],Q1):-casesJouables(Q,Q1).

caseValide(X):-mouvementsPossiblesCase(X,L), length(L,N),!, N > 0.
/*================================================
***************MANIPULATION LISTES****************
==================================================*/

/*teste si une liste est dans une sous listeù*/
%renvoie "false" si ce n'est pas le cas et "true" sinon
memberL(_,[],false).
memberL(L1,[L1|_],true).
memberL(L1,[_|Q],Bool):-memberL(L1,Q,Bool).
%supprime un element donné d'une liste
del(X,[X|Tail],Tail).
del(X,[Y|Tail],[Y|Tail1]):- del(X,Tail,Tail1).
%supprime tous les doublons d'une liste
delDoublons([],[]).
delDoublons([T|Q],[T|Q1]):-not(member(T,Q)),delDoublons(Q,Q1).
delDoublons([T|Q],Q1):-member(T,Q),delDoublons(Q,Q1).
%supprime le dernier element d'une liste%
delLast([_],[]).
delLast([T|Q],[T|Q1]):-delLast(Q,Q1).
/*permet d'afficher une liste*/
afficheListe([]).
afficheListe([T|Q]):-write(T), afficheListe(Q).

%permet de duppliquer une liste
dupListe([],[]).
dupListe([T|Q],[T|Q1]):-dupListe(Q,Q1). 
%fonctions de suppression d'éléments dans une liste non optimisées,
%conservées pour le moment car utilisées à plusieurs endroits du projet,

retireNiemeElement([T|Q],1,L2, Res, T):-append(L2,Q,Res).
retireNiemeElement([T|Q],N,L1, Res, Elem):-append([T],L1,L2), N1 is N - 1, retireNiemeElement(Q, N1, L2, Res, Elem). 

retireElement([Elem|Q],Elem,L2,Res):-append(L2,Q,Res).
retireElement([T|Q],Elem,L1,Res):- append(L1,[T],L2), retireElement(Q,Elem,L2,Res).

/*fonction pour inverser une liste en utilisant un accumulateur.*/
rev(L,R):-  accRev(L,[],R).
accRev([H|T],A,R):-  accRev(T,[H|A],R). 
accRev([],A,A).

getTete([T|_],T).
/*================================================
***************PARSING DE CASE********************
==================================================*/

parse(out,0,0):-!.

parse(a1,1,1):-!.
parse(a2,1,2):-!.
parse(a3,1,3):-!.
parse(a4,1,4):-!.
parse(a5,1,5):-!.
parse(a6,1,6):-!.

parse(b1,2,1):-!.
parse(b2,2,2):-!.
parse(b3,2,3):-!.
parse(b4,2,4):-!.
parse(b5,2,5):-!.
parse(b6,2,6):-!.

parse(c1,3,1):-!.
parse(c2,3,2):-!.
parse(c3,3,3):-!.
parse(c4,3,4):-!.
parse(c5,3,5):-!.
parse(c6,3,6):-!.

parse(d1,4,1):-!.
parse(d2,4,2):-!.
parse(d3,4,3):-!.
parse(d4,4,4):-!.
parse(d5,4,5):-!.
parse(d6,4,6):-!.

parse(e1,5,1):-!.
parse(e2,5,2):-!.
parse(e3,5,3):-!.
parse(e4,5,4):-!.
parse(e5,5,5):-!.
parse(e6,5,6):-!.

parse(f1,6,1):-!.
parse(f2,6,2):-!.
parse(f3,6,3):-!.
parse(f4,6,4):-!.
parse(f5,6,5):-!.
parse(f6,6,6):-!.

parse(_,_,_):-write('entrez une case valide merci'), read(X), parse(X,_,_), nl,!.

parseListe(L,Res):-parseListe2(L,[],Res1), dupListe(Res1,Res).
parseListe2([],Res,Res).
parseListe2([[A,B]|Q], Acc,Res):- parse(Case,A,B),append([Case],Acc,Res2),parseListe2(Q,Res2,Res).

%%===================SIMULATIONS COUPS===================%%
sauvegardePlateau:- resetPionsSave, kalistaR(X,Y), assert(kalistaRSave(X,Y)),
					kalistaO(X1,Y1), assert(kalistaOSave(X1,Y1)), khan(K,K1), assert(khanSave(K,K1)),
					recopiePions(rouge,save), recopiePions(ocre,save).

restaurePlateau:- resetPions, kalistaRSave(X,Y), assert(kalistaR(X,Y)),
					kalistaOSave(X1,Y1), assert(kalistaO(X1,Y1)), khanSave(K,K1), assert(khan(K,K1)),
					recopiePions(rouge,load), recopiePions(ocre,load).

recopiePionsR([]).
recopiePionsR([[X,Y]|Q]):-assert(sbireRSave(X,Y)), recopiePionsR(Q).

recopiePionsO([]).
recopiePionsO([[X,Y]|Q]):-assert(sbireOSave(X,Y)), recopiePionsO(Q).

recopiePionsRSave([]).
recopiePionsRSave([[X,Y]|Q]):-assert(sbireR(X,Y)), recopiePionsRSave(Q).

recopiePionsOSave([]).
recopiePionsOSave([[X,Y]|Q]):-assert(sbireO(X,Y)), recopiePionsOSave(Q).


recopiePions(rouge,save):-findall([X,Y],sbireR(X,Y),L), recopiePionsR(L).
recopiePions(ocre,save):- findall([X,Y],sbireO(X,Y),L), recopiePionsO(L).
recopiePions(rouge,load):- findall([X,Y],sbireRSave(X,Y),L), recopiePionsRSave(L).
recopiePions(ocre,load):- findall([X,Y],sbireOSave(X,Y),L), recopiePionsOSave(L).

%%===================IA===============================%%

getMax2([],_,P1,P2,[P1,P2]).
getMax2([P1,P2,S|Q],M,PX,PY,R):-
    (    S > M
    ->   getMax2(Q, S, P1, P2, R)
    ;    getMax2(Q, M, PX,PY,R)
    ).
getMax([P1,P2,S|Q],Res):-getMax2(Q,S,P1,P2,Res).
