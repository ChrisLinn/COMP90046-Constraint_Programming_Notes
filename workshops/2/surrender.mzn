% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;



% start

var set of NEGOTIATOR: s;

constraint card(s)>=l;
constraint card(s)<=u;

var int: obj;

constraint not (dummy in s)  % can be helpful though unnecessary
constraint sum([joint[i,j] | i in s, j in s where i < j]) > m; % important, i<j, otherwise computed twice
/*
or
constraint sum(i,j in s where i < j)([joint[i,j]) > m;
*/


constraint obj = min([honor[i] | i in s]);

solve maximize obj;