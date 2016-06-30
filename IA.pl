
tourOrdi:-getPossibles(Res,Bool), genereCoup(Res,Bool, Case,Dest), finTour(Case,Dest).

%%genere le meilleur coup possible en fonction de l'heuristique, note: ne prend pas en compte la pose des pieces pour l'instant
genereCoup(Res,_,Case,Dest):-calculPossibilites(Res,Scores), flatten(Scores,Scores1), getMax(Scores1,[Case,Dest]).
 
%%calcule les scores de tous les pions autorises en fonctions de leurs deplacements
calculPossibilites([],[]).
calculPossibilites([T|Q],[Res|Q1]):-mouvementsPossiblesCase(T,Moves),calculPossibilitesCase(T,Moves,Res),calculPossibilites(Q,Q1).
%%calcules les score d'un pion
calculPossibilitesCase(_,[],[]).
calculPossibilitesCase(T,[M|QM],[[T,M,Score]|Q]):- calculeDifference(T,M,Score), calculPossibilitesCase(T,QM,Q).
calculeDifference(Piece, Pos, Score):- sauvegardePlateau, bougePiece(Piece, Pos), joueurCourant(Player), 
										calculeScoreBoard(Score1,Player), 
										getJoueurOppose(Player, Player2), 
										calculeScoreBoard(Score2,Player2), Score is Score1 - Score2, restaurePlateau.
%%heuristique principale, calcule f(n) d'une grille
calculeScoreBoard(Score,Player):-calculeMovesKalistaEnnemie(Score1, Player),
						calculeScorePions(Score2,Player), 
						calculePionsMenacantKalista(Score3,Player),
						getJoueurOppose(Player,Player2),
						%%Notre Kalista est elle menacée si l'on joue ce coup? 
						calculePionsMenacantKalista(Score4,Player2),
						pionSurKalista(Score5, Player),
						Score is Score1 + Score2 + Score3 + (Score4 * -100) + (Score5*10000).

%%si un pion peut prendre la kalista, on y va direct
pionSurKalista(Score1,rouge):- getAllPiecesR(Pions), parseListe(Pions,Pions1), kalistaO(X,Y), parse(K,X,Y), getNombreDe(K,Pions1,Score1).
pionSurKalista(Score1,ocre):- getAllPiecesO(Pions), parseListe(Pions,Pions1), kalistaR(X,Y), parse(K,X,Y), getNombreDe(K,Pions1,Score1).
%%on calcule le degre de liberté de la kalista ennemie
calculeMovesKalistaEnnemie(Score,rouge):-kalistaO(X,Y), parse(Case,X,Y),mouvementsPossiblesCase(Case,Moves), length(Moves,N), Score is N*(-10).
calculeMovesKalistaEnnemie(Score,ocre):-kalistaR(X,Y), parse(Case,X,Y),mouvementsPossiblesCase(Case,Moves), length(Moves,N), Score is N*(-10).
%%on calcule le nombre de pion qui peuvent potentiellement tuer la kalista
calculePionsMenacantKalista(Score,rouge):- getAllPiecesR(PiecesR), parseListe(PiecesR,PiecesR1), calculeMouvements(PiecesR1,Moves), flatten(Moves,Moves1), kalistaO(X,Y),
										parse(Case,X,Y), getNombreDe(Case,Moves1,N), Score is N*60.

calculePionsMenacantKalista(Score,ocre):- getAllPiecesO(PiecesO), parseListe(PiecesO,PiecesO1), calculeMouvements(PiecesO1,Moves), flatten(Moves,Moves1),kalistaR(X,Y),
										parse(Case,X,Y), getNombreDe(Case,Moves1,N), Score is N*60.
%%on calcule le nombre de pions de chaque joueur
calculeScorePions(Score, rouge):- getAllPiecesR(PionsR), getAllPiecesO(PionsO), length(PionsR,N1), length(PionsO,N2), N11 is N1*5, N22 is N2*(-5), Score is N11 + N22.
calculeScorePions(Score, ocre):- getAllPiecesR(PionsR), getAllPiecesO(PionsO), length(PionsR,N1), length(PionsO,N2), N11 is N1*(-5), N22 is N2*(5), Score is N11 + N22.

