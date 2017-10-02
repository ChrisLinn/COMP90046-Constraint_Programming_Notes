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