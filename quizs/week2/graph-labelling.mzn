include "alldifferent.mzn";

enum NODE = {a,b,c,d,e,f,g,h}; % not []

array[NODE] of var 1..8: graph;

set of int: EDGE = 1..17;
array[EDGE] of NODE: from = [a,a,a,b,b,b,c,c,c,c,d,d,e,e,f,f,g]; % not {}
array[EDGE] of NODE: to =   [b,c,d,c,e,f,d,e,f,g,f,g,f,h,g,h,h];

constraint alldifferent(graph);

constraint forall(i in EDGE)(abs(graph[from[i]]-graph[to[i]]) >= 2);

solve satisfy;

constraint graph[a] < graph[h];
constraint graph[b] < graph[d];