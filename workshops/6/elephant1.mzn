int: T = 8; % maximum time allowed;
set of int: TIME = 1..T;
set of int: TIME0 = 0..T;
int: G = 2; % number of guards
int: F = 3; 
int: W = 3;

array[TIME] of var -F..F: move_food;      % move food +ve bank to boat, -ve boat to bank
array[TIME] of var -W..W: move_water;     % move water +ve bank to boat, -ve boat to bank
var TIME: end;                            % end time;

constraint forall(t in TIME)(abs(move_food[t])+abs(move_water[t]) <= G);
constraint forall(t in TIME)(move_food[t] *move_water[t] >= 0);
constraint forall(t in TIME where t > end)((move_food[t] = 0 /\ move_water[t] = 0));

set of int: FOOD = 0..F;
set of int: WATER = 0..W;
array[TIME0] of var FOOD: food_bank;
array[TIME0] of var WATER: water_bank;
constraint food_bank[0] = F;
constraint water_bank[0] = W;
constraint food_bank[end] = F;
constraint water_bank[end] = W;

enum POS = {bank, boat};
array[POS] of POS: opposite = [boat, bank];

array[TIME0] of var POS: pos;              % elephant at time t
constraint pos[0] = bank;
constraint pos[end] = boat;

predicate elephant_moves(var FOOD: fdhere, var WATER: wrhere) =
            let {   var FOOD: fdthere = F - fdhere;
                    var WATER: wrthere = W - wrhere; } in
            fdthere > fdhere
            /\
            wrthere > wrhere
            /\
            fdthere = wrthere
            ;

predicate elephant(var POS: cr_pos, var FOOD: fdhere, var WATER: wrhere, var POS: nw_pos) = 
            if elephant_moves(fdhere, wrhere) then
                nw_pos = opposite[cr_pos]
            else
                nw_pos = cr_pos /\ (fdhere = 0 <-> wrhere = 0)
            endif
            ;

constraint forall(t in TIME)(
              food_bank[t] = food_bank[t-1] - move_water[t]
              /\
              water_bank[t] = water_bank[t-1] - move_water[t]
            );

constraint forall(t in TIME)(
                if pos[t-1] = bank then 
                    elephant(bank,food_bank[t-1],water_bank[t-1],pos[t])
                else
                    elephant(boat,F-food_bank[t-1],W-water_bank[t-1],pos[t])
                endif
            );

% constraint move_food = [0, 3, -2, -1, 0, 0, 0, 0, 0, 0];
% constraint move_water = [3, 0, -1, -2, 0, 0, 0, 0, 0, 0];
% constraint end = 4;

solve minimize end;

output ["move_food = \(move_food);\n"]
      ++ ["move_water = \(move_water);\n"]
      ++ ["end = \(end);\n"];