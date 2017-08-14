enum SHIFT = { opening, morning, lunch, afternoon, closing };

enum DAY = { MON, TUE, WED, THU, FRI, SAT, SUN };


int: n; % number of employees
set of int: PERSON = 1..n;

array[PERSON,DAY,SHIFT] of int: pref;

% Heres a useful trick, we get preferences on SHIFTS, but the decisions should include another value: no shift = NONE
% Lets use integer 0..5 to represent these, knowning that opening = 1, ..., closing  = 5
int: NONE = 0;
set of int: SHIFT0 = 0..5;
% Now lets extend the preference array to be a 3D array using SHIFT0 rather than SHIFT
array[PERSON,DAY,SHIFT0] of int: pref0 = 
  array3d(PERSON,DAY,SHIFT0,[ if s = 0 then 0 else pref[p,d,to_enum(SHIFT,s)] endif | p in PERSON, d in DAY, s in SHIFT0 ]);

% we model each persons two possible shifts by twice as many people
set of int: DOUBLE = 1..2*n;      % persons twice 1, n+1 is person 1

array[DOUBLE,DAY] of var SHIFT0: shift;  % which shift for each doubled person
array[DAY,SHIFT] of var 0..n: number;    % number on each shift

% Make sure the two shifts for a person on a single day are not the same unless both are none
% in fact make the later shift appear first  
constraint forall(p in PERSON, d in DAY)(shift[p,d] >= (shift[p,d] != NONE) + shift[p+n,d]); % symmetry break
% if they close they cant be on afternoon
constraint forall(p in PERSON, d in DAY)(shift[p,d] = closing -> shift[p+n,d] != afternoon);
% if they open then cant be on morning, written as contrapositive
constraint forall(p in PERSON, d in DAY)(shift[p,d] = morning -> shift[p+n,d] != opening);
% they cant be on a shift type where there preference is 0
constraint forall(p in PERSON, d in DAY, s in SHIFT)(pref[p,d,s] = 0 -> (shift[p,d] != s /\ shift[p+n,d] != s));


include "global_cardinality.mzn";
% use global cardinality to count how many are on each shift type
constraint forall(d in DAY)(global_cardinality([ shift[p,d] | p in DOUBLE], [ s | s in SHIFT], [number[d,s] | s in SHIFT]));

% cardinality constraints
constraint forall(d in DAY)(number[d,lunch] + number[d,afternoon] + number[d,closing] >= 8);
constraint forall(d in DAY)(number[d,opening] + number[d,morning] + number[d,lunch] >= 8);
constraint forall(d in DAY)(number[d,opening] = 1 /\ 
                            number[d,morning] >= 2 /\
                            number[d,lunch] >= 2 /\
                            number[d,afternoon] >= 3 /\
                            number[d,closing] = 1);
% objective add up the preferences using extended arrays, note we get 0 for each NONE shift 
var int: obj;
constraint obj = sum(p in PERSON, d in DAY)(pref0[p,d,shift[p,d]] + pref0[p,d,shift[p+n,d]]);

solve maximize obj;

% pretty print result
output [ show(number[d,s]) ++ if s == closing then "\n" else " " endif |
         d in DAY, s in SHIFT ]
       ++
       [ show(d) ++ " " ++
         if fix(shift[p+n,d]) != NONE then show(to_enum(SHIFT,shift[p+n,d])) ++ " "else "" endif ++
         if fix(shift[p,d]) != NONE then show(to_enum(SHIFT,shift[p,d])) ++ " " else "" endif ++
         if d = SUN then "\n" else "" endif |
         p in PERSON, d in DAY ] 
       ++
       ["obj = \(obj);\n"]
       ++
       ["shift = array2d(DOUBLE,DAY,\(shift));\n"]
       ;

 