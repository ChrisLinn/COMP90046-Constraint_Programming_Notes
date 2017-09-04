int: x = 0;
int: y = 0;

constraint not (x div y != 0);

solve satisfy;

output ["\(x)"];