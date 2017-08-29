int: n;
set of int: ROW = 1..n;
set of int: COL = 1..n;
set of int: NUM = 1..n*n;
int: g;
set of int: GROUP = 1..g;
array[ROW,COL] of GROUP: group;
array[GROUP] of int: s;

array[ROW,COL] of var NUM: square;

include "alldifferent.mzn"
alldifferent(square);

forall(r in ROW)(sum(c in COL)());