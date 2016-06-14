:- consult(service).

/*=====FONCTION INIT=======*/
/*choisir type joueur 1*/
/*choisir type joueur 2*/
/*Si J1 humain*/
	/*Demander côté*/
	/*Demander Kalista Rouge*/
	/*Demander Pions rouges*/
/*Sinon*/
	/*Random côté*/
	/*Random Kalista*/
	/*Random pions*/
/*Si J2 humain*/
	/*Demander Kalista Ocre*/
	/*Demander Pions ocre*/
/*Sinon*/
	/*Random Kalista*/
	/*Random pions*/

/*Fonction d'init*/
init:- resetPions, write('Joueur 1 humain(entrer 1) ou ordi(entrer 2)'),read(Player1),nl, write('Joueur 2 humain(entrer 1) ou ordi(entrer 2)'), read(Player2),nl, initRouge(Player1), initOcre(Player2).
initRouge(1) :- assert(jRouge(humain)), choixCoteHumain, placeKalistaRougeHumain, placePionsRougeHumain(6).
initOcre(1) :- assert(jOcre(humain)), placeKalistaOcreHumain, placePionsOcreHumain(6).
initRouge(2) :- assert(jRouge(ordi)), choixCoteOrdi,placementOrdiRouge.
initOcre(2) :- assert(jOcre(ordi)), placementOrdiOcre.
initRouge(_) :- write('joueur 1: entrez 1 pour humain ou 2 pour ordi'), read(Player1), nl, initRouge(Player1).
initOcre(_) :- write('joueur 2: entrez 1 pour humain ou 2 pour ordi'), read(Player2), nl, initRouge(Player2).

/*test si les coordonnées entrées sont valides pour une initialisation*/
estOkInitRouge(X,Y):- estLibre(X,Y), estSurTerrain(X,Y), Y < 3.
estOkInitOcre(X,Y):- estLibre(X,Y), estSurTerrain(X,Y), Y > 4.

/*On change le plateau en fonction du côté que le joueur Rouge veut avoir en face de soit*/
choixCoteHumain:-write('Quel coté voulez vous choisir? (Entrer haut, bas, gauche ou droite'), read(Side), nl, setPlateau(Side).
setPlateau(droite):-setPlateauDroite.
setPlateau(gauche):-setPlateauGauche.
setPlateau(bas):-setPlateauBas.
setPlateau(haut):-setPlateauHaut.
setPlateau(_):-write('Entrez un cote valide, merci.'), read(X), setPlateau(X).

/*Génération aléatoire d'un côté pour l'IA*/
choixCoteOrdi :- random(1, 5, Rand), genereCote(Rand, Cote), setPlateau(Cote).
genereCote(1, gauche).
genereCote(2, droite).
genereCote(3, haut).
genereCote(4, bas).

/*On lit une coordonnée sous la forme [a-z]\d et on la parse pour récupérer la posX et posY pour la Kalista.*/
placeKalistaRougeHumain:-write('J1, ou voulez vous poser votre Kalista? Entrer une coordonnee de type a4'), read(Pos), nl, parse(Pos,X,Y), testKalistaRougeHumain(X, Y).
/*permet de vérifier que les coordonnées pour la kalista rouge sont valides*/
testKalistaRougeHumain(X, Y) :- estOkInitRouge(X,Y),!,assert(kalistaR(X,Y)).
testKalistaRougeHumain(X, Y) :- not(estOkInitRouge(X, Y)), write('Entrez une coordonnee valide merci'), nl, placeKalistaRougeHumain.

/*On procède de même pour la Kalista Ocre*/
placeKalistaOcreHumain:-write('J2, ou voulez vous poser votre Kalista? Entrer une coordonnee de type a4'), read(Pos), nl, parse(Pos,X,Y), testKalistaOcreHumain(X, Y).
testKalistaOcreHumain(X, Y) :- estOkInitOcre(X,Y),!,assert(kalistaO(X,Y)).
testKalistaOcreHumain(X, Y) :- not(estOkInitOcre(X, Y)), write('Entrez une coordonnee valide merci'), nl, placeKalistaOcreHumain.

/*On sélectionne aléatoirement un emplacement dans la liste des possibles pour la kalista rouge, on la pose, puis on retire la position dans la liste des possibles*/
placeKalistaRougeOrdi(Liste):- positionsPossiblesRouge(X), length(X,N), N1 is N + 1, random(1,N1,R), retireNiemeElement(X,R,[],Liste,Elem), parse(Elem, A,B), assert(kalistaR(A,B)).
/*De même pour l'ocre.*/
placeKalistaOcreOrdi(Liste):- positionsPossiblesOcre(X), length(X,N), N1 is N + 1, random(1,N1,R), retireNiemeElement(X,R,[],Liste,Elem), parse(Elem, A,B), assert(kalistaO(A,B)).

/*Permet à un humain joueur 1 de placer ses pions*/
placePionsRougeHumain(0).
placePionsRougeHumain(N):- write('Placer un pion (entrer une coordonnee de type a4'), read(Pos), parse(Pos,X,Y), testPionsRougeHumain(X,Y,N).
testPionsRougeHumain(X,Y,N):- estOkInitRouge(X,Y), !,assert(sbireR(X,Y)), N1 is N-1, placePionsRougeHumain(N1).
testPionsRougeHumain(X,Y,N):- not(estOkInitRouge(X,Y)), write('Entrez une coordonnee valide merci'), nl, placePionsRougeHumain(N).

/*Permet à un humain joueur 2 de placer ses pions*/
placePionsOcreHumain(0).
placePionsOcreHumain(N):- write('Placer un pion (entrer une coordonnee de type a4'), read(Pos), parse(Pos,X,Y), testPionsOcreHumain(X,Y,N).
testPionsOcreHumain(X,Y,N):- estOkInitOcre(X,Y), !,assert(sbireO(X,Y)), N1 is N-1, placePionsOcreHumain(N1).
testPionsOcreHumain(X,Y,N):- not(estOkInitOcre(X,Y)), write('Entrez une coordonnee valide merci'), nl, placePionsOcreHumain(N).

/*place les pions et les kalists des ordis rouges et noirs, le placement de la kalista passe au placement des pions la liste des positions privée de sa position.*/
placementOrdiRouge:- placeKalistaRougeOrdi(Positions), placePionsRougeOrdi(Positions,6).
placementOrdiOcre:- placeKalistaOcreOrdi(Positions), placePionsOcreOrdi(Positions,6).

/*Placement automatique des pions ordis Rouge*/
placePionsRougeOrdi(_,0).
placePionsRougeOrdi(Liste, Nb):- length(Liste,L), 
								L1 is L+1, random(1,L1,R), 
								retireNiemeElement(Liste,R,[],Res,Elem), 
								parse(Elem, A, B), assert(sbireR(A,B)), 
								Nb1 is Nb - 1, placePionsRougeOrdi(Res, Nb1).

/*Placement automatique des pions ordis Ocre*/
placePionsOcreOrdi(_,0).
placePionsOcreOrdi(Liste, Nb):- length(Liste,L), 
								L1 is L+1, random(1,L1,N),
								 retireNiemeElement(Liste,N,[],Res,Elem), 
								 parse(Elem, A, B), assert(sbireO(A,B)), 
								 Nb1 is Nb - 1, placePionsOcreOrdi(Res, Nb1).


