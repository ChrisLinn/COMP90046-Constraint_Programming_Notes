include "alldifferent.mzn";
include "inverse.mzn";

int: n;

array[1..n] of var 1..n: order;
array[1..n-1] of var 1..n-1: differences;
array[1..n] of var 1..n: posn;
array[1..n-1] of var 1..n: dposn;

constraint forall(i in 1..n-1)(differences[i] = abs(order[i]-order[i+1]));
%constraint alldifferent(order);
constraint inverse(order, posn);
constraint inverse(differences, dposn);
constraint alldifferent(differences);

%constraint forall(i in 2..n)(dposn[i-1] = min(posn[1], posn[i])); %guess should be wrong

constraint abs(posn[1] - posn[n]) = 1; % I was missing that
constraint dposn[n-1] = min(posn[1],posn[n]);


solve satisfy;
/*
output  [   if fix(order[i])<10 then
                " " ++ show(order[i])++"  "
            else
                show(order[i]) ++ "  "
            endif
            | i in 1..n ] ++ ["\n  "] ++
        [   if fix(differences[i])<10 then
                " " ++ show(differences[i])++"  "
            else
                show(differences[i]) ++ "  "
            endif
            | i in 1..n-1 ];
*/