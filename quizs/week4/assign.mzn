int: n;
set of int: DOM = 1..n;
int: m;
set of int: COD = 1..m;
array[DOM,COD] of int: profit;

array[DOM] of var COD: task;
include "alldifferent.mzn";
constraint alldifferent(task);

solve maximize obj;

var int: obj;
constraint obj = sum(w in DOM)
            (profit[w,task[w]]);

n = 4;
m = 5;
profit = [| 7,3,3,4,2
          | 5,2,5,1,4
          | 4,3,4,2,5
          | 3,1,6,3,5 |];