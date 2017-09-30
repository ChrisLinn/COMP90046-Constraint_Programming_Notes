
int: length; % length of Huang Gai's back
set of int: LENGTH = 1..length;
int: width; % width of Huang Gai's back
set of int: WIDTH = 1..width;

array[LENGTH,WIDTH] of bool: wound; % wound positions

int: ntypes;  % number of types of plaster
set of int: TYPE = 1..ntypes;
array[TYPE] of int: number;          % number of plaster available
array[TYPE,1..2] of int: dim;        % dimensions of plaster
array[TYPE] of int: price;

int: total = sum(number);
set of int: PLASTER = 1..total;
array[TYPE] of int: psum = [ sum(i in 1..t-1)(number[i]) | t in TYPE ];
array[PLASTER] of TYPE: t = [max(t in TYPE)(t*(p > psum[t])) | p in PLASTER];
array[PLASTER] of var LENGTH:  x;
array[PLASTER] of var WIDTH:   y;
enum USAGE = { Long, Wide, Not };
array[PLASTER] of var USAGE:   u;

