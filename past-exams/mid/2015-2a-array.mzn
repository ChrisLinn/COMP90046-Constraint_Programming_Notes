int: n;
set of int: MEMBER = 1..n;
set of int: POSN = 1..n;
int: President = 1;
int: Secretary = 2;
int: Treasurer = 3;

array[MEMBER] of set of MEMBER: notwithPresident;
array[MEMBER] of set of MEMBER: notwithSecretary;

int: Other = 4;
set of int: POSTYPE = 1..4;
array[MEMBER] of var POSTYPE: position;
array[{President,Secretary,Treasurer}] of var MEMBER: number;

% constraint forall(num in MEMBER)(number[President]=num <-> position[num]=President);

% include "globals.mzn";
% constraint global_cardinality_closed(position, [President, Secretary, Treasurer, Other], [1,1,1,n-3]);


% constraint forall(i in MEMBER)(
%         position[i]=President;
%     )


% constraint card({Secretary, Treasurer} intersect notwithPresident[President])=0;
% constraint card({President, Treasurer} intersect notwithSecretary[Secretary])=0;

solve satisfy;