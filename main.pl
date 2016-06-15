:- consult("init").
:-consult("service").
:- consult("moves").
:-consult("tour").

start:-init,assert(joueurCourant(rouge)), jRouge(Type), tourSuivant(Type).

jouer.