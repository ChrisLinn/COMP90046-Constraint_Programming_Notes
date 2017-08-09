% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

% can use all_different_except_0, better ordering is good for break sysmentric(2 "different" 0)

% start

% array [1..7] of var NEGOTIATOR: party;
% array comprehension will be converted to static
% so illegal
% var int: size = len([party[i] | i in NEGOTIATOR where i != dummy]);


% array [NEGOTIATOR] of var bool: occur;  % need to exclude 
% constraint sum(occur) >= l;
% constraint sum(occur) <= u;
% constraint sum([joint[i,j] | i, j in NEGOTIATOR where (i < j) /\ (occur[i]==1) /\ (occur[j]==1)]) > m;

array[1..u] of NEGOTIATOR: party;

constraint forall(i in 1..l)(party[i]!=dummy);
% or constraint sum(i in 1..u)(party[i] != dummy)>=l;

constraint forall(i in 1..u)(party[i] >= (party[i]!=dummy) + party[i+1]);

constraint sum(i,j in 1.. u where i<j)(join[party[i],party[j]]) >= m;




constraint obj =  (min(j in 1..u)((party[j] = dummy)*(max(honor)+1) + honor[party[j]]));


solve maximum obj;