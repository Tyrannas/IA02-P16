

%Affiche les pièces sur case 1 (vert), case 2(bleue) et case 3(blanc)
affichePiece(1,X,Y):-sbireO(X,Y), ansi_format([bg(white),fg(black)],' o ', [world]).
affichePiece(1,X,Y):-sbireR(X,Y), ansi_format([bg(white),fg(black)],' r ', [world]).
affichePiece(1,X,Y):-kalistaO(X,Y), ansi_format([bg(white),fg(black)],' O ', [world]).
affichePiece(1,X,Y):-kalistaR(X,Y), ansi_format([bg(white),fg(black)],' R ', [world]).
affichePiece(1,X,Y):-estLibre(X,Y),ansi_format([bg(white), fg(white)],'---', [world]).

affichePiece(2,X,Y):-sbireO(X,Y), ansi_format([bg(cyan),fg(black)],' o ', [world]).
affichePiece(2,X,Y):-sbireR(X,Y), ansi_format([bg(cyan),fg(black)],' r ', [world]).
affichePiece(2,X,Y):-kalistaO(X,Y), ansi_format([bg(cyan),fg(black)],' O ', [world]).
affichePiece(2,X,Y):-kalistaR(X,Y), ansi_format([bg(cyan),fg(black)],' R ', [world]).
affichePiece(2,X,Y):-estLibre(X,Y),ansi_format([bg(cyan), fg(cyan)],'---', [world]).


affichePiece(3,X,Y):-sbireO(X,Y), ansi_format([bg(green),fg(black)],' o ', [world]).
affichePiece(3,X,Y):-sbireR(X,Y), ansi_format([bg(green),fg(black)],' r ', [world]).
affichePiece(3,X,Y):-kalistaO(X,Y), ansi_format([bg(green),fg(black)],' O ', [world]).
affichePiece(3,X,Y):-kalistaR(X,Y), ansi_format([bg(green),fg(black)],' R ', [world]).
affichePiece(3,X,Y):-estLibre(X,Y),ansi_format([bg(green), fg(green)],'---', [world]).

%Affiche une ligne du plateau
afficheLigne([],_,_):-!.
afficheLigne(Q,6,1):-findTypeCase(6,1,TYPE), affichePiece(TYPE, 6, 1),!.
afficheLigne([T|Q],6,Y):-findTypeCase(6,Y,TYPE), affichePiece(TYPE,6,Y),nl,Y1 is Y-1, X1 is 1, afficheLigne(Q,X1,Y1).
afficheLigne([T|Q],X,Y):-findTypeCase(X,Y,TYPE), affichePiece(TYPE,X,Y),tab(1), X1 is X+1, afficheLigne(Q,X1,Y).

%Affiche tout le plateau
affichePlateau:-plateau(P), write(6),tab(1), afficheLigne(P,1,6), nl, write(5),tab(1), afficheLigne(P,1,5), nl, write(4),tab(1), afficheLigne(P,1,4), nl, write(3),tab(1), afficheLigne(P,1,3), nl, write(2),tab(1), afficheLigne(P,1,2), nl, write(1),tab(1), afficheLigne(P,1,1), nl, tab(2), write(" a "), tab(1), write(" b "), tab(1), write(" c "), tab(1), write(" d "), tab(1), write(" e "), tab(1), write(" f ").

