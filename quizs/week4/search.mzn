enum DIRN = {n,s,e,w};


var DIRN: A;
var DIRN: B;
var DIRN: C;
var DIRN: D;
var DIRN: E;
var DIRN: F;

set of int: SEARCHER = 1..6;
array[SEARCHER] of var DIRN: x = [A,B,C,D,E,F];

constraint forall(d in DIRN)
                 (exists(s in SEARCHER)(x[s] = d));

%constraint global_cardinality_low_up(x, [d | d in DIRN], [ 1| d in DIRN], [ 6 | d in DIRN]);

constraint A in {n,s} -> not (B in {n,s}); 

%array[DIRN] of DIRN: opp = [s,w,n,e];
%constraint D = opp[C];

%constraint C mod 2 =  D mod 2;
constraint abs(C - D) = 2;

%constraint C = n <-> D = s;
%constraint C = s <-> D = n;
%constraint C = e <-> D = w;
%constraint C = w <-> D = e;

%constraint if E = w \/ F = w then A != w /\ B != w /\ C != w /\ D != w else true endif;

constraint w in {E,F} -> not (w in {A,B,C,D}); 

constraint A != E;
constraint B != F;
constraint C != E;

%include "all_different.mzn";
%constraint all_different([A,B,C]);


solve satisfy;