var 0..10: x;

constraint x mod 4 = 0;
/*
or
var int: y;
constraint y*4=x;
*/

var int: obj = (x-7)*(x-7);
/*
var int: obj = pow((x-7),2);
*/

solve minimize obj;

output ["x=\(x);\nobj=\(obj);"];