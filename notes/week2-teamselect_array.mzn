
enum PLAYER = {Ant, Bee, Chu, Deb, Eve, Fin, Ged, Hel, Ila, Jan, Kim};

enum CAPTAIN = {Xavier, Yuri, Zena};

set of PLAYER: GOALIE = {Ant,Bee};
set of PLAYER: DEFENCE = {Chu, Deb, Eve, Fin};
set of PLAYER: OFFENCE = {Ged, Hel, Ila, Jan, Kim};

set of int: POS = 1..6;
set of int: GPOS = 1..1;
set of int: DPOS = 2..3;
set of int: OPOS = 4..5;


array[CAPTAIN,POS] of var PLAYER: team;

constraint forall(c in CAPTAIN, p in GPOS)(team[c,p] in GOALIE);
constraint forall(c in CAPTAIN, p in DPOS)(team[c,p] in DEFENCE);
constraint forall(c in CAPTAIN, p in OPOS)(team[c,p] in OFFENCE);

include "alldifferent.mzn";
constraint forall(c in CAPTAIN)(alldifferent([team[c,p] | p in POS]));

constraint sum(p1,p2 in POS)(team[Xavier,p1] = team[Yuri,p2]) <= 2;
constraint sum(p1,p2 in POS)(team[Xavier,p1] = team[Zena,p2]) <= 2;

array[CAPTAIN,PLAYER] of int: value = 
   [| 2, 5, 6, 8, 9, 5, 8, 7, 7, 4, 6
    | 9, 8, 4, 7, 6, 4, 5, 3, 5, 5, 7
    | 8, 4, 3, 3, 6, 2, 5, 5, 3, 2, 5 |];


var int: obj
%;constraint obj 
               = sum(c in CAPTAIN, p in POS)(value[c,team[c,p]]);
     
solve maximize obj;

output ["obj = \(obj);\nteam = \(team);\n"];