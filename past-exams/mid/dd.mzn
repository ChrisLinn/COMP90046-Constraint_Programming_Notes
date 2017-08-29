enum PLAYER = {Ant, Bee, Chu, Deb, Eve, Fin, Ged, Hel, Ila, Jan, Kim};

enum CAPTAIN = {Xavier, Yuri, Zena};

set of PLAYER: GOALIE = {Ant,Bee};
set of PLAYER: DEFENCE = {Chu, Deb, Eve, Fin};
set of PLAYER: OFFENCE = {Ged, Hel, Ila, Jan, Kim};

array[CAPTAIN,PLAYER] of int: value = 
   [| 2, 5, 6, 8, 9, 5, 8, 7, 7, 4, 6
    | 9, 8, 4, 7, 6, 4, 5, 3, 5, 5, 7
    | 8, 4, 3, 3, 6, 2, 5, 5, 3, 2, 5 |];

array[CAPTAIN] of var set of PLAYER: team;

set of int: i = {1,2};


constraint forall(i in CAPTAIN)(card(team[i])=6);


constraint forall(i in CAPTAIN)(card(team[i] intersect GOALIE)=6);

solve satisfy;