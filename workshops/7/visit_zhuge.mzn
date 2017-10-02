enum PERSON; % set of people to be visited

array[PERSON] of int: duration;    % duration of visit
array[PERSON] of bool: on_weekend; % can the person be visited over weekends
array[PERSON] of int: rank;        % rank of person

array[int,1..2] of PERSON: prec;   % precedences between visits
set of int: PREC = index_set_1of2(prec); 

0..6: starting_day; % which day of the week is day 0 in the schedule
                    % 0 Monday, 1 Tuesday, ..., 5 Saturday, 6 Sunday

% upper bound on the amount of time needed: total duration plus 1 week
% per person who cant be visited on the weekend
int: total = sum(duration) + 7*sum(p in PERSON)(on_weekend[p] = false);
set of int: TIME = 0..total;

array[PERSON] of var TIME: start;
var TIME: end;

% constraint forall(p in PERSON)(
%                 (not on_weekend[p])
%                 ->
%                 (
%                     let {   var TIME: p_start = starting_day + start[p];
%                             var TIME: p_end = p_start + duration[p] } in
%                     forall(d in p_start..p_end)((d mod 7) <= 5)
%                 )
%             );

constraint forall(p in PERSON)(
                (not on_weekend[p])
                ->
                (
                    let { var TIME: p_start = starting_day + start[p]; } in
                    forall(d in 0..duration[p])((p_start + d) mod 7 <= 5)
                )
            );
            
include "globals.mzn";
% include "cumulative.mzn";
% include "disjunctive.mzn";
constraint disjunctive(start, duration);

constraint forall(pr in PREC)(
                start[prec[pr,1]] + duration[prec[pr,1]] <= start[prec[pr,2]]
            );

constraint end = max([start[p] + duration[p] | p in PERSON]);

var 0..card(PERSON): nViolat;
% constraint nViolat = sum(p1,p2 in PERSON where rank[p1] < rank[p2])(start[p1] > start[p2]);
% or
% should not have i<j!!!
% need to care about whatif rank[i]<rank[j] and j>i
% and because of the comparison, the reverse won't be calculated twice
constraint nViolat = sum(i,j in PERSON)(  
                        (start[i]>start[j])
                        /\
                        (rank[i]<rank[j])
                    );

solve minimize (end*card(PERSON)*card(PERSON) + nViolat);

output ["start = \(start);\n"] ++
        ["end = \(end);\n"] ++
        ["rank_violations = \(nViolat);"];