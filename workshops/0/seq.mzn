par int: n;
array[1..n] of var 0..3: x;
/*
or
set of int: INDEX = 1..n;
array[INDEX] of var 0..3: x;
*/



constraint x[1]=0;
constraint x[n]=3;
constraint forall(i in 1..n-1)((x[i]+x[i+1])<=3);
var 1..n: pos_div_3;
constraint pos_div_3 mod 3 = 0;
constraint x[pos_div_3] >= 2;
/*
or
constraint forall(i in INDEX where i mod 3 = 0)
                (x[i] >= 2);
*/


var int: obj = sum(x);

solve maximize obj;
/*
or
solve maximize sum(x);
*/

output ["\(obj) = \(x)"];
/*
or
output ["\(sum(x)) = \(x)"];
*/
