
include "alldifferent.mzn";


int: n;

array[1..n] of var 1..n: order;
constraint alldifferent(order);

array[1..n-1] of var 1..n-1: differences;
constraint forall(i in 1..n-1)(differences[i] = abs(order[i]-order[i+1]));
constraint alldifferent(differences);


solve satisfy;
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