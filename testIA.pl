%% Si KalistaAdverseTuable
%% 	On la tue. 
%% Sinon Calcule(AttaqueOpti)
%% 		testDanger(AttaqueOpti)

%% bool function testDanger(Move){
%% 	Si Khan arrive sur couleur C
%% 		Si Kalista sur couleur C
%% 			Si non désobéissance Kalista safe.
%% 			Si désobéissance calcul mouvements adverse pour A et B
%% 				Si Danger, change couleur, sinon move
%% 		Sinon si Kalista sur A|B
%% 			Calcul MouvementAdverse(C)
%% 				Si Danger change couleur, sinon move
%% }



%% getSolution.
%% genereMouvement.

%% on se place à n-1
%% puis on essaye de bloquer le mvt de la kalista adverse

%% solution(rouge):-solution()

%% calculeNbMouvements([],Acc,Res):-length(Acc,Res).
%% calculeNbMouvements([Case|Q],Acc,Res):- mouvementsPossiblesCase(Case,Res1), append(Acc,Res1,Res2), calculeNbMouvements(Q,Res2,Res). 

calculeMouvements(_,[],Res,Res,_).
%Cas ou l'on cherche à savoir si la position de la Kalista adverse est dans les successeurs directs d'un pion jouable
calculeMouvements(rouge,[Case|Q],Acc,Res,kill):- mouvementsPossiblesCase(Case,Res1), kalistaR(X,Y), parse(Kalista,X,Y), not(member(Kalista,Res1)) ,append(Acc,[Res1],Res2), calculeMouvements(rouge,Q,Res2,Res,kill). 
calculeMouvements(ocre,[Case|Q],Acc,Res,kill):- mouvementsPossiblesCase(Case,Res1), kalistaR(X,Y), parse(Kalista,X,Y), not(member(Kalista,Res1)) ,append(Acc,[Res1],Res2), calculeMouvements(ocre,Q,Res2,Res,find). 

calculeMouvements(rouge,[Case|Q],Acc,Res,kill):- mouvementsPossiblesCase(Case,Res1), kalistaO(X,Y), parse(Kalista,X,Y), member(Kalista,Res1), bougePiece(Case, Kalista, rouge), assert(winner(rouge)),endTurn.
calculeMouvements(ocre,[Case|Q],Acc,Res,kill):- mouvementsPossiblesCase(Case,Res1), kalistaR(X,Y), parse(Kalista,X,Y), member(Kalista,Res1), bougePiece(Case, Kalista, ocre), assert(winner(ocre)),endTurn.
%Cas ou l'on cherche à savoir si la position de la Kalista adverse est dans les petits enfants d'un pion jouable
calculeMouvements(rouge,[Case|Q],Acc,Res,find):- mouvementsPossiblesCase(Case,Res1), kalistaO(X,Y), parse(Kalista,X,Y), member(Kalista,Res1), append([Case],[true],Res).
calculeMouvements(ocre,[Case|Q],Acc,Res,find):- mouvementsPossiblesCase(Case,Res1), kalistaR(X,Y), parse(Kalista,X,Y), member(Kalista,Res1), append([Case],[true],Res).
%Cas ou l'on cherche à trouver tous les mouvements possibles pour une case

calculeMouvements(rouge,[Case|Q],Acc,Res,find):- mouvementsPossiblesCase(Case,Res1), kalistaR(X,Y), parse(Kalista,X,Y), not(member(Kalista,Res1)) ,append(Acc,[Res1],Res2), calculeMouvements(rouge,Q,Res2,Res,kill). 
calculeMouvements(ocre,[Case|Q],Acc,Res,find):- mouvementsPossiblesCase(Case,Res1), kalistaR(X,Y), parse(Kalista,X,Y), not(member(Kalista,Res1)) ,append(Acc,[Res1],Res2), calculeMouvements(ocre,Q,Res2,Res,find). 

initGenereMouvement:-joueurCourant(Player), khan(X,Y), parse(Khan, X, Y), 
					possibilitesIA(ListePions, Player, Khan), calculeMouvements(Player, ListePions,Acc,Res,kill), 
					decideMove(Res,Player,ListePions).
decideMove([],Player).
decideMove().
decideMove([T|Q],Player):- calculeMouvements(Player, T, Acc, Res, find), member(true,Res), not(danger(Res)), getTete(Res,Case), findParent(Case,bougePiece(Case) .


%%rouge joue et le khan n'est pas encore en jeu
possibilitesIA(ListePions, rouge, out):- getAllPiecesR(Pions), parseListe(Pions,ListePions).
%%rouge joue et le khan et en jeu mais il ne peut pas jouer de pions 
possibilitesIA(ListePions, rouge, _):- getAllPiecesR(Pions), pionsSurTypeKhan(Pions,Res), length(Res,N), N = 0, parseListe(Pions,ListePions).
%%rouge joue, le khan est en jeu, et le joueur a des pions sur des cases du même type que le khan et peut les jouer 
possibilitesIA(ListePions, rouge, _):- getAllPiecesR(Pions), pionsSurTypeKhan(Pions,Res), calculeNbMouvements(Res,Acc,N), N > 0, dupListe(Res,ListePions).
%rouge joue, le khan est en jeu, le joueur a des pions sur des cases du même type que le khan mais ces pions ne peuvent pas bouger
possibilitesIA(ListePions, rouge, _):- getAllPiecesR(Pions), pionsSurTypeKhan(Pions,Res), calculeNbMouvements(Res,Acc,N), N = 0, parseListe(Pions,ListePions).
%%ocre joue et le khan et en jeu mais il ne peut pas jouer de pions 
possibilitesIA(ListePions, ocre, _):- getAllPiecesO(Pions), pionsSurTypeKhan(Pions,Res), length(Res,N), N = 0, parseListe(Pions,ListePions).
%%ocre joue, le khan est en jeu, et le joueur a des pions sur des cases du même type que le khan
possibilitesIA(ListePions, ocre, _):- getAllPiecesO(Pions), pionsSurTypeKhan(Pions,Res), calculeNbMouvements(Res,Acc,N), N > 0, dupListe(Res,ListePions).
%ocre joue, le khan est en jeu, le joueur a des pions sur des cases du même type que le khan mais ces pions ne peuvent pas bouger
possibilitesIA(ListePions, ocre, _):- getAllPiecesO(Pions), pionsSurTypeKhan(Pions,Res), parseListe(Res,ResL), calculeNbMouvements(ResL,Acc,N), N = 0, parseListe(Pions,ListePions).
