:- consult("init").
:-consult("service").
:- consult("moves").
:-consult("tour").
:-consult("affichage").

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



start:-init,assert(joueurCourant(rouge)), jRouge(Type), tourSuivant(Type).

jouer.