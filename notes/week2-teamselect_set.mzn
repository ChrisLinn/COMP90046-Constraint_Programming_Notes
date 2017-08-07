
enum PLAYER = {Ant, Bee, Chu, Deb, Eve, Fin, Ged, Hel, Ila, Jan, Kim};


set of PLAYER: GOALIE = {Ant,Bee};
set of PLAYER: DEFENCE = {Chu, Deb, Eve, Fin};
set of PLAYER: OFFENCE = {Ged, Hel, Ila, Jan, Kim};

var set of PLAYER: Xavier;
var set of PLAYER: Yuri;
var set of PLAYER: Zena;

constraint card(Xavier intersect GOALIE) >= 1;
constraint card(Xavier intersect DEFENCE) >= 2;
constraint card(Xavier intersect OFFENCE) >= 2;
constraint card(Xavier) = 6;

constraint card(Yuri intersect GOALIE) >= 1;
constraint card(Yuri intersect DEFENCE) >= 2;
constraint card(Yuri intersect OFFENCE) >= 2;
constraint card(Yuri) = 6;


constraint card(Zena intersect GOALIE) >= 1;
constraint card(Zena intersect DEFENCE) >= 2;
constraint card(Zena intersect OFFENCE) >= 2;
constraint card(Zena) = 6;

constraint card(Xavier intersect Yuri) <= 2;
constraint card(Xavier intersect Zena) <= 2;




array[CAPTAIN,PLAYER] of int: value = 
   [| 2, 5, 6, 8, 9, 5, 8, 7, 7, 4, 6
    | 9, 8, 4, 7, 6, 4, 5, 3, 5, 5, 7
    | 8, 4, 3, 3, 6, 2, 5, 5, 3, 2, 5 |];

set of int: CAPTAIN = 1..3;
int: xavier = 1;
int: yuri = 2;
int: zena = 3;

var int: obj
%;constraint obj 
               = sum(p in Xavier)(value[xavier,p]) +
               sum(p in Yuri)(value[yuri,p]) +
               sum(p in Zena)(value[zena,p]);

solve maximize obj;

output ["obj = \(obj);\nXavier = \(Xavier);\nYuri = \(Yuri);\nZena = \(Zena);"];