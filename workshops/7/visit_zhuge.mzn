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

constraint forall(p in PERSON)(
                (not on_weekend[p])
                ->
                (
                    let {   var TIME: s_p = starting_day + start[p];
                            var TIME: e_p = starting_day + start[p] + duration[p] } in
                    forall(d in s_p..e_p)((d mod 7) <= 5)
                )
            );

constraint forall(p1,p2 in PERSON)(
                (start[p1] < start[p2])
                <->
                ((start[p1] + duration[p1]) < start[p2])
            );

constraint forall(pr in PREC)(
                start[prec[pr,1]] < start[prec[pr,2]]
            );

constraint end = max([start[p] + duration[p] | p in PERSON]);

var 0..card(PERSON): nViolat;
constraint nViolat = sum(i,j in PERSON where i<j)(
                        (start[i]>start[j])
                        /\
                        (rank[i]<rank[j])
                    );

solve minimize (end*total + nViolat);

output ["start = \(start);\n"] ++
        ["end = \(end);\n"] ++
        ["rank_violations = \(nViolat);"];