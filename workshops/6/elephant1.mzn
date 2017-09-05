int: T; % maximum time allowed;
set of int: TIME = 1..T;
set of int: TIME0 = 0..T;
int: G; % number of guards
int: F; 
int: W;

array[TIME] of var -F..F: move_food;      % move food +ve bank to boat, -ve boat to bank
array[TIME] of var -W..W: move_water;     % move water +ve bank to boat, -ve boat to bank
var TIME: end;                            % end time;

constraint forall(t in TIME)(abs(move_food[t])+abs(move_water[t]) <= G);

set of int: FOOD = 0..F;
set of int: WATER = 0..W;
array[TIME0] of var FOOD: food_bank;
array[TIME0] of var WATER: water_bank;
constraint food_bank[0] = F;
constraint water_bank[0] = W;
constraint food_bank[end] = F;
constraint water_bank[end] = W;

enum POS = {bank, boat};

predicate elep_pos(var POS: cr_pos, var FOOD: fdhere, var wrhere, var POS: nw_pos) = 
            1 ;

constraint forall(t in TIME)(
              food_bank[t] = food_bank[t-1] - move_water[t];
              /\
              water_bank[t] = water_bank[t-1] - move_water[t];
            );

constraint move_food = [0, 3, -2, -1, 0, 0, 0, 0, 0, 0];
constraint move_water = [3, 0, -1, -2, 0, 0, 0, 0, 0, 0];
constraint end = 4;

solve minimize end;

output ["move_food = \(move_food);\n"]
      ++ ["move_water = \(move_water);\n"]
      ++ ["end = \(end);\n"];