:- consult("init").
:-consult("tour").
:-consult("affichage").
:-consult("IA").

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
%gagnant
:-dynamic winner/1.
%simulation sbires rouges
:-dynamic sbireOSave/2.
%simulation sbires ocre
:-dynamic sbireOSave/2.
%simulation kalistaO
:-dynamic kalistaOSave/2.
%simulation kalistaR
:-dynamic kalistaRSave/2.
%simulation khan
:-dynamic khanSave/2.



start:-init,assert(joueurCourant(rouge)), jRouge(Type), tourSuivant(Type).
