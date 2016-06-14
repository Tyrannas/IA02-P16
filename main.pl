:- consult(init).

start:-init,assert(joueurCourant(rouge)), jRouge(Type), tourSuivant(Type).

jouer.