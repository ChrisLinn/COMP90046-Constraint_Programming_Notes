int: n;
set of int: MEMBER = 1..n;
set of int: POSN = 1..n;
int: President = 1;
int: Secretary = 2;
int: Treasurer = 3;

array[MEMBER] of set of MEMBER: notwithPresident;
array[MEMBER] of set of MEMBER: notwithSecretary;

var MEMBER: Pres;
var MEMBER: Sec;
var MEMBER: Treas;
var set of MEMBER: Other;

include "alldifferent.mzn";
constraint alldifferent({Pres} union {Sec} union {Treas} union Other);

constraint card(Pres)=1;
constraint card(Sec)=1;
constraint card(Treas)=1;
constraint card(Other)=n-3;

solve satisfy;