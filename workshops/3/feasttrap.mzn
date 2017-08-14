% Beauty Trap
% Create the most magnificient feast 
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};
%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: spicy = 1; int: sour = 2; int: salty = 3; int: sweet = 4; int: umame = 5; int: bland = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;


array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;

array[COURSE] of var DISH: dish;


include "alldifferent.mzn";
constraint alldifferent(dish);
constraint forall(c in 1..len-1)(taste[dish[c]]!=taste[dish[c+1]]);
constraint taste[dish[1]]==salty;
constraint taste[dish[len]]==sweet;
constraint forall(c in 1..len-1)
            (taste[dish[c]]==spicy -> 
                (taste[dish[c+1]]==bland \/ taste[dish[c+1]]==sweet));
constraint forall(c in 1..len-1)
            (taste[dish[c]]==sour -> 
                (taste[dish[c+1]]==bland \/ taste[dish[c+1]]==umame));
constraint forall(c in 1..len-1)
            (taste[dish[c]]==sweet -> 
                (not (taste[dish[c+1]]==spicy) /\ not (taste[dish[c+1]]==umame)));
constraint forall(c in 1..len-2)
            ((heavy[dish[c]] /\ heavy[dish[c+1]]) -> 
                not heavy[dish[c+2]]);
constraint forall(c in 1..len-2)
            ((temp[dish[c]]==hot /\ temp[dish[c+2]]==warm) -> 
                temp[dish[c+1]]==warm);

var int: obj = sum(c in COURSE)(value[dish[c]]);

solve maximize obj;