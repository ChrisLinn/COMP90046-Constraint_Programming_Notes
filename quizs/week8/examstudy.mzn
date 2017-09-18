int: n;
set of int: TOPIC = 1..n;
array[TOPIC] of int: hours;
int: m; % precedences
set of int: PREC = 1..m;
array[PREC] of TOPIC: before;
array[PREC] of TOPIC: after;
set of TOPIC: morning;
int: D; 
int: H;
set of int: DAY = 1..D;
set of DAY: HALF;

set of int: TIME = 0..D*H;
array[TOPIC] of var TIME: start;

constraint forall(p in PREC)(
                (start[before[p]] + hours[before[p]] <= start[after[p]])
            );

include "cumulative.mzn"
include "disjunctive.mzn"
constraint disjunctive(start
                        ++ [(d-1)*H + H div 2 | d in HALF]
                        ++ [d*H | d in DAY],
                        hours
                        ++ [H div 2 | d in HALF]
                        ++ [0 | d in DAY]);

constraint forall(t in morning)(
                start[t] mod H  = 0
            );

constraint forall(t in TOPIC)(
                start[t] + hours[t] <= D*H
            );

solve maximize min(start);