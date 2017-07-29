array[int] of int: readings;
int: start;

var int: len = length(readings);
set of int: TIME = 0..length(readings); % cannot be "0..len", needs a par instead of a var
array[TIME] of var int: temp;  % not "of int". "of int" means par and value needs to be given; "var int" means var and MiniZinc will try to solve the value

constraint temp[0] = start;
constraint forall(i in 1..len)(temp[i] = (readings[i] + temp[i-1]) div 2); % "/" for float, "div" for int

solve satisfy;