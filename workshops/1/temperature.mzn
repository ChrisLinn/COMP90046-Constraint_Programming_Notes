array[int] of int: readings;
int: start;

var int: len = length(readings);
set of int: TIME0 = 0..length(readings); % cannot be "0..len", needs a par instead of a var
set of int: TIME = 1..length(readings); % cannot be "0..len", needs a par instead of a var
array[TIME0] of var 25..30: temp;  % not "of int". "of int" means par and value needs to be given; "var int" means var and MiniZinc will try to solve the value
array[TIME] of var 25..30: tp = [temp[i] | i in TIME];
/* or 
array[TIME] of var 25..30: tp;
constraint forall(i in TIME)(tp[i] = temp[i]); 
*/
array[TIME] of var ACTION: choice;

enum ACTION = {heat, strongly_heat, cool, strongly_cool, do_nothing};
array[ACTION] of int: effect = [1, 4, -2, -5, 0];
array[ACTION] of int: cost = [1, 5, 3, 9, 0];

constraint temp[0] = start;
constraint forall(i in TIME/* or 1..len */)(temp[i] = (readings[i] + temp[i-1]) div 2 + effect[choice[i]]); % "/" for float, "div" for int

var int: obj = sum(i in TIME)(cost[choice[i]]);

solve minimize obj;

output ["temp = \(tp);\nchoice = \(choice);\ncost = \(obj)"]