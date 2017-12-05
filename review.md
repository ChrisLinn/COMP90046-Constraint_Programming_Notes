
# MISC
+ array
    * array1d(a[])
    * array1d(set1{}, a[])
    * array2d(set1{}, set2{}, a[])
    * `sum(i in [2,3,3])(i)` = 8
+ conjunction
    * /\
+ disjunction
    * \/
- multiset
+ "/" for float, "div" for int
+ take the input data format and create some new data
    * create data file
        - pros
            + simple, can be programmed externally
        - cons
            + needs to be checked with assertions to see its correct
    * add constraints to compute
        - pros
            + use the power of solver
        - cons
            + data is not known while modeling
            + solving overhead
    * rewrite into minizinc model
        - pros
            + data is available and correct
        - cons
            + may require complex codings
+ common sub-expr
    * `patrolV2.mzn`
        ```
        array[DAY] of var 0..card(SOLDIER): onEve;
        constraint onEve = [sum (s in SOLDIER) (roster[s,d]=EVE) | d in DAY];
        constraint forall(d in DAY)(onEve[d] >= l /\ onEve[d] <= u);

        %or!!!!
        array[DAY] of var l..u: onEve;
        constraint onEve = [sum (s in SOLDIER) (roster[s,d]=EVE) | d in DAY];
        ```
+ problems involving __only__ (simple form) linear constraint (difference logic constraint) can be solved very efficiently
    * `x+d<=y`
        - `x+d=y` is actually `x+d<=y /\ y+(-d)<=x`

## -- MIP solvers
* cannot express multiplication of continuous variables which is required to solve this problem
    - the default solver uses interval arithmetic and can solve
* ideal for mixed integer programming problem

## -- CP solvers
+ treat set model better than 0-1 integer model since they can combine cardinality reasoning with other set reasoning
+ other solvers will actually convert set model to 0-1 integer model, not really diff between
    * 0-1 int
    * bool
    * set

## -- Set Operators
- in
    + `constraint 1 in {1,2};` 
- subset
    + `constraint {1,2} subset {1,2,3};` 
- superset
    + `constraint {1,2,3} superset {1,2};` 
- intersect
    + `constraint {3} = {2,3,4} intersect {1,3,5};`
- union
- card
- diff
    + `constraint {2,4} = {2,3,4} diff {1,3,5};`
- symdiff
    + `constraint {1,3,4,6} = {1,2,5,6} symdiff {2,3,4,5}`

## -- global
+ global_cardinality(_closed)(misc[], unique[], var[])
+ global_cardinality_low_up(_closed)(misc[], unique[], par[], par[])

## -- disjoint
+ disjoint(var set of int: s1, var set of int: s2)
    * Requires that sets s1 and s2 do not intersect.
+ all_disjoint([Liu, Guan, Zhang])
    * disjoint array of sets

## -- function
```
function var int: check(int: x) = abs(2);

constraint check(1)=2;

solve satisfy;
```

## -- predicate
+ has type `var bool`
+ can be used anywhere a `var bool` can be used

## -- context
+ root
    * global constraints in a non-root contexts are usually not supported
    * try reification if possible
        * (c\/alldifferent(s)) becomes (c\/b)/\(alldifferent_reif(s,b))
        * alldifferent_reif(s,b) becomes (b<->alldifferent(s))
        + because of decomposition
+ positive
    * let-in cannot introduce uninitialized var in a negative/mixed context
        - universal quantification
        - `not even(u)` in `context.mp4`
+ negative
+ mixed

## -- dummy
+ workshop 2
    * `constraint sum(i,j in 1.. u where i<j)(joint[party[i],party[j]]) >= m;` 
+ `baguaBoundedInt.mzn`
    ```
    array[1..nSpots] of int: damage;
    array[1..size] of var 0..nSpots: attacks;

    var int: totalDamages = sum(p in attacks where p > 0)(damage[p])
    % instead of sum(p in attacks ~~where p > 0~~)(damage[p])
    % careful!!!!
    % otherwise force p in 1..nSpots (no dummy)!!!!!
    ```

## -- array elem selection by bool/pos
```
array[POS] of POS: opposite = [boat,bank];
predicate elephant(var POS: pos, var FOOD: food_here, var WATER: water_here, var POS: new_pos) = 
                   let { var bool: b = elephant_moves(food_here, water_here); } in 
                   new_pos = [pos,opposite[pos]][b+1] /\
                   (b \/ (food_here = 0 <-> water_here = 0));
```

## -- regular
```
regular(action_seq[],
        state_set_size, action_set_size,
        transition _table[state_set,action_set] of {0} union state_set,
        start_state, final_state)
```
+ 0 for error state

## -- table
+ table(var_a[], a[,])
    * `constraint table([1,3], [|1,2|1,3|2,3|]);`
+ should a[,] be bi-directional

## -- multiple-modeling
+ channeling
    * array_array channeling
        ```
        forall(w in WINE, f in FOOD)(
            eat[w] = f
            <->
            drink[f] = w
        )
        ```
+ inverse
    * alldifferent
    * index_set match
    * bijection
+ composition.mzn
    * pos channeling
    * `abs(posn[1] - posn[n]) = 1`
    * `dposn[n-1] = min(posn[1],posn[n])`
+ beltPos.mzn
    * 1d_2d_pos channeling
        ```
        forall(d in DIG, c in 1..m-1)(
                po[d,c+1] = po[d,c] + d +1
        )

        %forall(d in DIG, c in 1..m-1, p in POS)
        %   (dc[p] = m*(d-1) + c <-> 
        %       dc[p+d+1] = m*(d-1) + c + 1);

        inverse(dc, [po[d,c] | d in DIG, c in 1..m]) !!!!!!!!!!
        ```
    * array access out of bounds?
        - dont worry
        - but better deal with it
+ acupuncture.mzn
    * set_array channeling
        ```
        % no overlapping points among any three stages
        constraint forall(i1, i2, i3 in 1..m where i1 < i2 /\ i2 < i3) 
           ((stage[i1] intersect stage [i2] intersect stage[i3]) = {});
        % or
        constraint global_cardinality_low_up_closed(
                                [point[i,j] | i in 1..m, j in 1..c],
                                SPOT,
                                [0 | s in SPOT],
                                [2 | s in SPOT]);

        % ordering constraints
        array[1..m, 1..c] of var SPOT: point;
        % order within a stage
        constraint forall(i in 1..m, j in 1..c-1) 
           (point[i, j] < point[i, j+1]);
        % order between stages
        constraint forall(i in 1..m-1, j in 1..c) 
           (point[i, j] < point[i+1, j]); 

        % channeling
        constraint forall(i in 1..m, s in SPOT)
           ((s in stage[i]) -> exists(j in 1..c)(point[i, j] = s));
        constraint forall(i in 1..m, j in 1..c)(point[i,j] in stage[i]);
        ```
+ table_seating_imp.mzn
    * set_array channeling
        ```
        forall(t in TABLE, p in SCHOLAR)(p in table[t] <-> seat[p] = t);    
        ```
+ patrolChannel.mzn
    * set_array channeling
        ```
        % constraint forall(d in DAY, so in SOLDIER, sh in SHIFT)(rosterSoldier[so,d] = sh <-> so in rosterShift[sh,d]);
        constraint forall(d in DAY)
          (int_set_channel([ rosterSoldier[so,d] | so in SOLDIER ],
                           [ rosterShift[sh,d] | sh in SHIFT ])); 
        ```

## -- schedule
+ Resource Constrained Project Scheduling Problem, RCPSP
+ time decomposition
+ task decomposition
+ cumulative

## -- disjunctive
* disjunctive(var star[], var duration[])
* disjunctive_strict

## -- cumulative
+ cumulative(var star[], var duration[], var usage[], var limit)

## -- seq dependent scheduling
+ keep track of next/prev, or channeling to array[TIME]
    * singleChannel.mzn
        ```
        set of int: SHIPE = 1..nS+1; % add dummies
        int: dummy = 3;
        array[SHIPE] of enter..dummy: kind 
                   = dirn ++ [ dummy ];
        array[SHIPE] of int: speede = speed++[0];
        constraint start[nS+1] = maxt;
        constraint end[nS+1] = maxt;

        array[SHIP] of var SHIPE: next; % next ship

        constraint forall(s in SHIP)
                  % ships of opposite dirn
              (if kind[s] + kind[next[s]] = 3 then
                  end[s] <= start[next[s]]
               else % same dirn
        start[s]+speed[s]*leeway <= start[next[s]] /\
          end[s]+speede[next[s]]*leeway <= end[next[s]]
               endif); 
        ```
    * doubleChannel.mzn
        ```
        int: nC; % number of channels
        array[1..nC] of int: len;

        % add dummies for each channel
        set of int: SHIPE = 1..nS+nC;
        array[SHIPE] of enter..dummy: kind 
                   = dirn ++ [ dummy | i in 1..nC];
        array[SHIPE] of int: speede = speed++[0|i in 1..nC];
        array[SHIPE] of var 1..nC: channel;
        constraint forall(s in nS + 1 .. nS + nC)
              (start[s] = maxt /\ end[s] = maxt);
        constraint forall(s in nS + 1 .. nS + nC)
              (channel[s] = s - nS);

        array[SHIP] of var SHIPE: next; % next ship
        constraint alldifferent(next);

        constraint forall(s in SHIP)(end[s] = start[s] +    
                          len[channel[s]]*speed[s]);


        constraint forall(s in SHIP)
              (channel[next[s]] = channel[s]);
        constraint forall(s in SHIP)
                  % ships of opposite dirn
              (if kind[s] + kind[next[s]] = 3 then
                  end[s] <= start[next[s]]
               else % same dirn
        start[s]+speed[s]*leeway <= start[next[s]] /\
          end[s]+speede[next[s]]*leeway <= end[next[s]]
               endif); 
        ```
+ visitzhuge.mzn
    ```
    constraint disjunctive(start, duration);

    array[int] of var TIME: weekday = [ start[t] | t in PERSON where on_weekend[t] = false ];
    array[int] of int: weekdur = [ duration[t] | t in PERSON where on_weekend[t] = false ];

    array[int] of TIME: weekends = [ t | t in TIME where (t + starting_day) mod 7 = 5 ]; 
    array[int] of int: weekend_dur = [ 2 | t in TIME where (t + starting_day) mod 7 = 5 ];

    constraint disjunctive(weekday ++ weekends, weekdur ++ weekend_dur );


    % channeling
    set of int: PP = 0..card(PERSON);
    array[TIME] of var PP: pp;

    %constraint forall(t in TIME)(pp[t] > 0 -> start[pp[t]] <= t /\ start[pp[t]] + duration[pp[t]] > t);
    constraint forall(p in PERSON, t in TIME)(start[p] <= t /\ start[p] + duration[p] > t <-> pp[t] = p);



    var int: rank_violation;
    constraint rank_violation = sum(p1,p2 in PERSON
                                        where rank[p1] < rank[p2])
                                    (start[p1] > start[p2]);

    solve minimize card(PERSON)*card(PERSON)*end + rank_violation;



    %%mine!!!
    var 0..card(PERSON): nViolat;
    % constraint nViolat = sum(p1,p2 in PERSON where rank[p1] < rank[p2])(start[p1] > start[p2]);
    % or
    % should not have i<j!!!
    % need to care about whatif rank[i]<rank[j] and i>j
    % and because of the comparison, the reverse won't be calculated twice
    constraint nViolat = sum(i,j in PERSON)(  
                            (start[i]>start[j])
                            /\
                            (rank[i]<rank[j])
                        );
    ```

## -- lex_sym and base
+ simple way
    ```
    array[NSQ] of var SQUARE: size;
    constraint global_cardinality(size, [i | i in SQUARE], ncopy);
    constraint forall(i in 1..nsq-1)(size[i] <= size[i+1]);

    % symmetry breaking
    constraint forall(i,j in NSQ where i<j and size[i]=size[j])
       (
          lex_greater([x[i],y[i]],
             [x[j],y[j]]));

    ```
+ base
    ```
    array[SQUARE] of int: base = 
       [if i = 1 then 0 else sum(j in 1..i-1)(ncopy[j]) endif | 
          i in SQUARE];
    % symmetry breaking
    include "lex_greater.mzn";
    constraint forall(i in SQUARE)
       (forall(j in 1..ncopy[i]-1)(
          lex_greater([x[base[i]+j],y[base[i]+j]],
             [x[base[i]+j+1],y[base[i]+j+1]])));

    % and size can become
    array[NSQ] of ~~var~~ SQUARE: size = [max(j in SQUARE)
                                            (j*(n>base[j])) | n in NSQ];
    ```

## -- packing
+ diffn(var x[], var y[], var dx[], var dy[])
    * actually should be called diff2
    * diffn_k
        - k dimension
+ add redundant cumulative
    * cumulative(x, size, size, height)
    * cumulative(y, size, size, width)
+ rectangle
    * sbpnorotate
        ```
        array[BLOCK] of set of ROFF: shape;
        
        constraint forall(i in BLOCK)(forall(r in ROFF)
          (r in shape[i] -> 
          (x[i] + d[r,1] + d[r,3] <= l /\
           y[i] + d[r,2] + d[r,4] <= h)));

        constraint forall(i,j in BLOCK where i < j)
          (forall(r1,r2 in ROFF)
         (r1 in shape[i] /\ 
          r2 in shape[j] -> 
        (x[i] + d[r1,1] + d[r1,3] <= x[j] + d[r2,1]
                           \/
         x[j] + d[r2,1] + d[r2,3] <= x[i] + d[r1,1]
                           \/
         y[i] + d[r1,2] + d[r1,4] <= y[j] + d[r2,2]
                           \/
        y[j] + d[r2,2] + d[r2,4] <= y[i] + d[r1,2])
           ));
        ```
    * sbprotate
        ```
        set of int: ROT = 1..4;
        array[BLOCK,ROT] of set of ROFF: shape;
          array[BLOCK] of var ROT: rot;

        constraint forall(i in BLOCK)(shape[i,rot[i]] != {}); %!!!!!!

        constraint forall(i in BLOCK)(forall(r in ROFF)
          (r in shape[i,rot[i]] -> 
          (x[i] + d[r,1] + d[r,3] <= l /\
           y[i] + d[r,2] + d[r,4] <= h)));

        constraint forall(i,j in BLOCK where i < j)
          (forall(r1,r2 in ROFF)
         (r1 in shape[i,rot[i]] /\ 
          r2 in shape[j,rot[j]] -> 
        (x[i] + d[r1,1] + d[r1,3] <= x[j] + d[r2,1]
                           \/
         x[j] + d[r2,1] + d[r2,3] <= x[i] + d[r1,1]
                           \/
         y[i] + d[r1,2] + d[r1,4] <= y[j] + d[r2,2]
                           \/
         y[j] + d[r2,2] + d[r2,4] <= y[i] + d[r1,2]
           )));

        ```
+ geost()
    ```
    include "geost.mzn";
    constraint geost_bb(2, % num of dimension
             rsize[,1..2] of int, % rect_size
             roff[,1..2] of int, % rect_offset
             shape[] of set of int, % config
             coord[,1..2] of var int, % coordinate, desicion var
             kind[] of var int, % choice, desicion var
             var[ 0,0 ], % lower bounds on each dimension
             var[ l,h ] % upper bounds on each dimension
            ); 

    array[BLOCK] of set of int: shapeind; % options
    array[BLOCK] of var int: kind;
    constraint forall(i in BLOCK)(kind[i] in shapeind[i]);
    ```
+ plaster.mzn
    ```
    include "lex_lesseq.mzn";
    % symmetry
    constraint forall(p in 1..total-1 where t[p] = t[p+1])
                     (lex_lesseq([ u[p], x[p], y[p] ], [u[p+1], x[p+1], y[p+1] ]));
    % unused symmetry
    constraint forall(p in PLASTER)(u[p] = Not -> x[p] = 1 /\ y[p] = 1);


    constraint forall(i in LENGTH, j in WIDTH)(
                        wound[i,j]
                        ->
                        exists(p in PLASTER)
                            (x[p] <= i /\ x[p] + len[p] > i /\
                                y[p] <= j /\ y[p] + wid[p] > j)
        );
    % or
    % calculate which squares are covered
    array[LENGTH,WIDTH] of var bool: covered;
    constraint forall(p in PLASTER)
                     (u[p] != Not ->
                     (forall(i in LENGTH, j in WIDTH)
                             ((x[p] <= i /\ x[p]+len[p] > i /\
                              y[p] <= j /\ y[p]+wid[p] > j) ->
                              (covered[i, j]))));
    constraint forall(i in LENGTH, j in WIDTH)
                     (covered[i,j] -> 
                      exists(p in PLASTER)
                            (x[p] <= i /\ x[p] + len[p] > i /\
                             y[p] <= j /\ y[p] + wid[p] > j));

    constraint forall(i in LENGTH, j in WIDTH)(wound[i,j] -> covered[i,j]);

    
    %      :: int_search(reverse(used), input_order, indomain_min, complete)


    % redundant
    % dont rotate square plasters
    constraint forall(p in PLASTER)(if dim[t[p],1] = dim[t[p],2] then u[p] != Wide else true endif);
    % used variables
    constraint forall(ty in TYPE)
                     (used[ty] = sum(p in PLASTER where t[p] = ty)(u[p] != Not));
    constraint sum(ty in TYPE)(used[ty]*dim[ty,1]*dim[ty,2]) >= total_wounds;


    % dominance constraint
     used[2] <= number[2] - 1 /\ used[3] <= number[3] - 1
    /\ used[4] <= number[4] - 1 -> used[5] = 0;

    % cover all
    var TYPE: dominated;
    constraint sum(ty in TYPE)(used[ty]*dim[ty,1]*dim[ty,2]) = dim[dominated,1] * dim[dominated,2];

    constraint forall(p in PLASTER)(x[p] + len[p] -1 <= dim[dominated,1] /\ y[p] + wid[p] -1 <= dim[dominated,2]); 

    var int: cost = sum(t in TYPE)(used[t] * price[t]);

    constraint cost < price[dominated];
    ```
+ knapsack
+ cp vs mip
+ propogator stack

## -- sym
* var_sym([])
* double_lex([,])
    ```
    % adjacent rows to be in lexicographic order
    % adjacent column to be in lexicographic order

    int: v;
    set of int: ROW = 1..v;
    int: b;
    set of int: COL = 1..b;
    
    include "lex_lesseq.mzn";
    constraint forall(i in 1..v-1)
       (lex_lesseq(row(m,i),row(m,i+1)));
    %       (lex_lesseq([ m[i,j] | j in COL],
    %                   [ m[i+1,j] | j in COL]));
    constraint forall(j in 1..b-1)
       (lex_lesseq(col(m,j),col(m,j+1)));
    %       (lex_lesseq([ m[i,j] | i in ROW],
    %                   [ m[i,j+1] | i in ROW]));
    
    include "double_lex.mzn";
    constraint double_lex(m);
    ```
* crossbow
    ```
    % no two traps on the same row
    constraint forall(i in N)(sum(j in N)(t[i,j]) <= 1);
    % no two traps on the same column
    constraint forall(j in N)(sum(i in N)(t[i,j]) <= 1);
    % no two traps on same diagonal
    constraint forall(k in 1-n..n-1)
          (sum(i,j in N where i-j=k)(t[i,j])<= 1);
    constraint forall(k in 2..2*n)
          (sum(i,j in N where i+j=k)(t[i,j])<= 1);

    include "lex_lesseq.mzn";
    %left right both rev rev-left rev-left rev-right rev-both
    % solution lex less than r90 version
    constraint let { array[N,N] of var bool: s; } in
        forall(i,j in N)(s[i,j] = t[j,n+1-i]) /\
        lex_lesseq(array1d(t), array1d(s));
    % solution lex less than r180 version
    constraint let { array[N,N] of var bool: s; } in
        forall(i,j in N)(s[i,j] = t[n+1-i,n+1-j]) /\
        lex_lesseq(array1d(t), array1d(s));
    % solution lex less than 270 version
    constraint let { array[N,N] of var bool: s; } in
        forall(i,j in N)(s[i,j] = t[n+1-j,i]) /\
        lex_lesseq(array1d(t), array1d(s));
    % solution lex less than x flip version
    constraint let { array[N,N] of var bool: s; } in
        forall(i,j in N)(s[i,j] = t[n+1-i,j]) /\
        lex_lesseq(array1d(t), array1d(s));
    % solution lex less than y flip version
    constraint let { array[N,N] of var bool: s; } in
        forall(i,j in N)(s[i,j] = t[i,n+1-j]) /\
        lex_lesseq(array1d(t), array1d(s));
    % solution lex less than d2 flip version
    constraint let { array[N,N] of var bool: s; } in
        forall(i,j in N)(s[i,j] = t[n+1-j,n+1-i]) /\
        lex_lesseq(array1d(t), array1d(s));
    % solution lex less than d1 flip version
    constraint let { array[N,N] of var bool: s; } in
        forall(i,j in N)(s[i,j] = t[j,i]) /\
        lex_lesseq(array1d(t), array1d(s));
    ```
* rot_flip_sqr_sym(t[,])
    - crossbow-lib.mzn
        ```
        include "symmetry.mzn";
        include "lex_lesseq.mzn";
        ```
* var_sqr_sym([,])
    - removes rotational and the 4 reflection symmetries
* lex_lesseq with alldiff can be simplified to comparing with [1] 
+ value sym
    * inverse then
        - order
        - var_sym
        - value_precede_chain
+ sym are a special kind of dominance
    * dominance breaking constraint ensures no transformation of a feasible solution would lead to a batter solution
    * .
        ```
        % sym, liang tou huan
        lex_lesseq(road, reverse(road));

        include "alldifferent.mzn";
        constraint alldifferent(road);
        constraint road[1] < road[n];



        % dominance
        % zhong jian zhuan
        constraint forall(i in 2..n-2) 
                         (forall(j in i+1..n-1)
                                (coop[road[i-1], road[i]] + 
                                 coop[road[j], road[j+1]] 
                                 >= 
                                 coop[road[i-1], road[j]] + 
                                 coop[road[i], road[j+1]]
                                )
                         );
        ```

## -- sliding_sum
```
predicate sliding_sum(int: low,
                      int: up,
                      int: seq,
                      array [int] of var int: vs)
```
+ Requires that in each subsequence `vs[i], ..., vs[i + seq - 1]` the sum of the values belongs to the interval `[low, up]`.

## -- value symmetry
* catapult
    - the least elem in partition i is less than the least elem in partition i+1
        + .
            ```
            forall(i in 1..k-1)(
                min([j | j in DOM where x[j] = i])
                <
                min([j | j in DOM where x[j] = i+1])
            );
            ```
    - value_prede_chain
        + Requires that c[i] precedes c[i +1] in the array x.
        + Precedence means that if any element of x is equal to \a c[i +1], then another element of x with a lower index is equal to \a c[i].
    - catapult VS catapultExact

## -- Debugging
+ symptoms
    * no solution
    * too many solutions
    * missing solutions
+ skills
    * assert(boolexpr, stringexpr)
        - print when __false__!
    * assert(boolexpr, stringexpr, expr)
        - if boolepr return expr, otherwise print stringexpr
    * trace(stringexp, exp)
        - print string and return exp
            + even if __false__
+ key methods
    * find a small example which shows the problem
    * make sure the constraints generated are the constraints that you think they are
    * generate a solution you expect to find
    * switch off and on constraints in the model
    * solve a simple version of the problem first
        - by ignoring constraints/parts of the problem

## -- avoid
+ negation
    * replace negation with negated form
+ disjunction
+ implication
+ existential loop
+ bool2int
    * another form of negation

## -- relational semantics
- the undefined values flow upwards to the nearest enclosing boolean context where they becomes false. For example `bool2int(x > 3 * 4y + z div u)` evaluates to 0 when `u = 0` !
- `x = y div z` should act like `y = x*z + r /\ r < z`
    + sneak.mzn
    + `z = 0` means failure, the whole constraint will fail!
        * wont be a solution
+ partial functions
    * division (by zero)
        - `not (x div y = 1)` not same as `x div y != 1`
            + (x,y) = (0,0) is a solution of the first
    * array access (out of bounds)
    * should try to avoid partial function applications


## -- Too many solutions
+ wrong model, superoptimal
+ too many correct but not interesting
    * don't ask for all solutions
    * select only some solutions or add an obj
    * break sym
        - `var_sym(a[])`

## -- Missing solutions
+ First fix (too slow to solve/too many suboptimal solutions)
    * run with all solutions printed
        - without this, no solution printed if its not proved optimal
+ More general (wrong model, unsatisfiable)
    * Adding a solution to the IDE
    * Relaxing constraints

## -- No solution
+ in the worst case
    * too slow to solve
        - simplify the model
            + consider less of the problem
            + look at the solutions of the simplified problem
            + can you use these
        - decompose the model
            + break into 2 parts
                * solve the first
                * fix a solution to the first to define the second

## -- propagator
* correct
    - A correct propagator never removes values from the domain of a variable which can take part in a solution of the constraint given the current domain. Incorrect propagators can miss solutions by erroneously removing them.
* checking
    * A checking propagator is guaranteed to cause a false domain if all the variables in the constraint are fixed in the current domain and it does not represent a solution. Checking propagators guarantee that once all variables are fixed the constraints are actually satisfied.
+ idempotent propagator
    * An idempotent propagator f is such that f (D) = f (f (D) for all domains D, that is the propagator will always return a domain which is a fixpoint for itself. An example of a non-idempotent propagator is the bounds propagator for 2x = 3y. On domains D(x) = [0..11], D(y) = [0..11] it returns the f (D)(x) = [0..11], f (D)(y) = [0..7], but f (f (D)(x) = [0..10].

## -- search strategy
* int_search(Vars, Varchoice, Valuechoice, complete)
    - Varchoice
        + supported in MiniZinc
            * input_order
            * first_fail
            * smallest
            * largest
            * dom_w_deg
                - min (domain_size / failures caused by the constraints it is in)
                - approximation to activity based search
        + non-supported in MiniZinc
            * impact of desicion
                - average change in domain size when this decision is taken
                - record for x = d
                + max-impact var, min-impcact val
            * activity
                - failure records for
                    + x = d
                    + x <= d
                    + x >= d
                    + x != d
                - choose hightest
    - Valuechoice
        + indomain_min
        + indomain_max
        + indomain_median
        + indomain_random
* bool_search
* float_search

# EXAMS
## -- 2012.4.a
```
% predicate disjoint(array[int] of int: a, array[int] of int: b) = 
%     forall(i in index_set(a))(
%         forall(j in index_set(b))(
%             a[i] != b[j]
%         )
%     )
% ;

% predicate disjoint(array[int] of var int: a, array[int] of var int: b) = 
%     forall(i in index_set(a), j in index_set(b))(
%         a[i] != b[j]
%     )
% ;

predicate disjoint(array[int] of var int: x, array[int] of int: y) = 
    forall(i in index_set(x), j in index_set(y))
        (x[i] != y[j]);
```

## -- 2014.1.a
```
array[int] of int: scores;
int: target;

scores = [16,17,23,24,39,40];
target = 100;

array[index_set(scores)] of var int: arrows;
constraint sum(i in index_set(scores))(arrows[i]*scores[i]) = target;

constraint forall(i in index_set(scores))(arrows[i] >= 0);

solve :: int_search(arrows, input_order, indomain_min, complete)
    minimize sum(arrows);


% array[int] of int: scores;
% int: target;
% int: maxarrow = target div min(scores);
% array[index_set(scores)] of var 0..maxarrow: hits;
% constraint sum(i in index_set(scores))(scores[i]*hits[i])
% = target;
% solve minimize sum(i in index_set(scores))(hits[i]);
% scores = [16,17,23,24,39,40];
% target = 100;
```

## -- 2014.2.0
```
% var 1..3: a;

% var set of 1..3: b;

var set of {1,3}: c;

% so "set of" means "subsets of" !

solve satisfy;
```

## -- 2014.2.a.i
```
% var set of 1..1000: x;
% constraint card(x) <= 3;

% array[1..1000] of var bool: x;
% constraint sum(x)<=3; /* if sum(x)=3, the last 3 is true instead of the first 3, interesting */

array[1..3] of var 0..1000: x; 

solve
    % :: int_search(x, input_order, indomain_min, complete)
        satisfy;
```

## -- 2014.2.a.iii
```
% var set of 1..20: a;
% constraint sum(i in a)(i) = 30;

% array[1..20] of var bool: c;
% constraint sum(i in index_set(c))(i * c[i]) = 30;
% output ["\(bool2int(c[i])*i)" | i in index_set(c)];

array[1..20] of var 0..20: b;
% actually has a tight cardinality bound of 7
% array[1..7] of var 0..20: b2;
constraint sum(b) = 30;
constraint forall(i in 1..19)(b[i] >= (b[i+1]!=0) + b[i+1]);
% or
% constraint forall(i in 1..19)(b[i] >= (b[i]!=0) + b[i+1]);

solve
    % :: int_search(x, input_order, indomain_min, complete)
        satisfy;
```

## -- 2014.3.a
```
% int: n;
% set of int: WORKERS = 1..n;
% set of int: TASKS = 1..n;
% array[WORKERS,TASKS] of int: v;
% array[WORKERS] of var TASKS: assign;
% include "alldifferent.mzn";
% constraint alldifferent(assign);

% solve maximize sum(assign);


int: n;
set of int: WORKER = 1..n;
set of int: TASK = 1..n;
array[WORKER, TASK] of int: v;
array[WORKER] of var TASK: assign;
include "alldifferent.mzn";
constraint alldifferent(assign);

solve maximize sum(w in WORKER)(v[w, assign[w]]);
```

## -- 2014.3.c
```
% int: n;
% set of int: WORKER = 1..n;
% set of int: TASK = 1..n;
% array[WORKER, TASK] of int: v;
% include "alldifferent.mzn";
% constraint alldifferent(be_assigned);

% array[TASK] of var WORKER: be_assigned;
% constraint abs(be_assigned[2]-be_assigned[1]) >= 2;

% solve maximize sum(t in TASK)(v[be_assigned[t], t]);


int: n;
set of int: WORKER = 1..n;
set of int: TASK = 1..n;
array[WORKER, TASK] of int: v;
array[WORKER] of var TASK: assign;
include "alldifferent.mzn";
constraint alldifferent(assign);
array[TASK] of var WORKER: be_assigned;
constraint inverse(assign, be_assigned)
constraint abs(be_assigned[2]-be_assigned[1]) >= 2;
solve maximize sum(w in WORKER)(v[w, assign[w]]);
```

## -- 2014.4.a
```
% predicate common(var int: n1,var int: n2,
%                     array[int] of var int: c1,
%                     array[int] of var int: c2) = 
%     n1 = sum(i in index_set(c1))(
%                 sum(j in index_set(c2))(c1[i]=c2[j])>0
%             )
%     /\
%     n2 = sum(i in index_set(c2))(
%                 sum(j in index_set(c1))(c2[i]=c1[j])>0
%             );

predicate common(var int: n1,var int: n2,
                    array[int] of var int: c1,
                    array[int] of var int: c2) = 
    n1 = sum(i in index_set(c1))(
                exists(j in index_set(c2))(c1[i]=c2[j])
            )
    /\
    n2 = sum(i in index_set(c2))(
                exists(j in index_set(c1))(c2[i]=c1[j])
            );

constraint common(3,4,[1,9,1,5],[2,1,9,9,6,9]);
constraint common(4,1,[1,1,1,1],[2,1,9,9,6,9]);

solve satisfy;
```

## -- 2014.4.c
```
predicate common(var int: n1,var int: n2,
                    array[int] of var int: c1,
                    array[int] of var int: c2) = 
    n1 = sum(i in index_set(c1))(
                exists(j in index_set(c2))(c1[i]=c2[j])
            )
    /\
    n2 = sum(i in index_set(c2))(
                exists(j in index_set(c1))(c2[i]=c1[j])
            );
predicate uses(array[int] of var int: c1, array[int] of var int: c2) = 
    let { var 1..length(c1): n1 } in
    common(n1, length(c2), c1, c2)
;

solve satisfy;
```

## -- 2014.8.a
```
int: n; % days of planning period
set of int: DAY = 0..n;
int: stock; % initial stock of lavatories
int: m; % number of events
set of int: EVENT = 1..m;
array[EVENT] of DAY: start; % start day
array[EVENT] of int: duration; % duration in days
array[EVENT] of int: demand; % demand of lavatories
array[EVENT] of int: contract; % contract price
array[EVENT] of int: penalty; % penalty price per lavatory
int: buy_cost; % cost to buy new lavatory
int: daily_rent_cost; % cost to rent for one day

n = 10;
stock = 5;
m = 8;
start = [0,0,1,2,3,3,5,7];
duration = [3,4,2,5,2,5,2,3];
demand = [4,3,4,2,5,2,3,5];
contract = [60,70,35,55,50,45,35,80];
penalty = [15,25,10,30,10,20,10,15];
buy_cost = 35;
daily_rent_cost = 5;


int: maxd = max(demand);
var int: new_stock = stock + bought;
include "globals.mzn";
constraint cumulative(start, duration, sent, new_stock);
array[EVENT] of var 0..maxd: sent;
array[EVENT] of var 0..maxd: rented;
array[EVENT] of var 0..maxd: used = [sent[e] + rented[e] | e in EVENT];
constraint forall(e in EVENT)(used[e] <= demand[e]);
% var int: income = sum(e in EVENT)(
%                         if used[e]=0 then
%                             0
%                         else
%                             contract[e] - (demand[e]-used[e]) * penalty[e]
%                         endif
%                         );
var int: income = sum(e in EVENT)(
                        (used[e]>0) * (contract[e] - (demand[e]-used[e]) * penalty[e])
                    );
% var int: bought;
int: totald = sum(demand);
var 0..totald-stock: bought;
var int: rent_cost = daily_rent_cost*sum(e in EVENT)(rented[e]*duration[e]);
var int: obj = income - buy_cost*bought - rent_cost;

constraint sent = [4, 0, 0, 1, 4, 0, 3, 5];
constraint rented = [0, 3, 0, 1, 0, 0, 0, 0];
constraint bought = 0;


solve maximize obj;
output ["sent = \(sent)\n"] ++ 
       ["rented = \(rented)\n"] ++ 
       ["bought = \(bought)\n"] ++ 
       ["obj = \(obj)\n"];
```

## -- 2015.1.a
```
int: l;
int: u;
int: s;

l = 1;
u = 200;
s = 9;

var l..u: num;
int: d = ceil( ln(u+1) / ln(10) );
array[1..d] of 0..9: digit;
constraint num = sum(i in 1..d)(pow(10, d-i) * digit[i]);

constraint sum(digit) = s;

solve satisfy;
output ["num = \(num)"];
```

## -- 2015.2
```
% int: n;
% array[1..n, 1..n] of var 1..n: reg;
% array[1..n, 1..n] of var 1..n: rank;

% include "globals.mzn";
% constraint forall(i in 1..n)(
%                 alldifferent([reg[i, j] | j in 1..n])
%     );

% constraint forall(j in 1..n)(
%                 alldifferent([reg[i, j] | i in 1..n])
%     );
% constraint forall(i in 1..n)(
%                 alldifferent([rank[i, j] | j in 1..n])
%     );

% constraint forall(j in 1..n)(
%                 alldifferent([rank[i, j] | i in 1..n])
%     );


% solve satisfy;

int:n; % number of regiments and ranks
set of int: REG = 1..n;
set of int: RANK = 1..n;
set of int: OFF = 1..n*n;
set of int: ROW = 1..n;
set of int: COL = 1..n;
array[ROW,COL] of var OFF: x;
array[ROW,COL] of var REG: reg;
array[ROW,COL] of var RANK: rank;
constraint forall(r in ROW, c in COL) % relationship with vars
(reg[r,c] = (x[r,c] - 1) div n + 1 /\
rank[r,c] = (x[r,c] - 1) mod n + 1 /\
x[r,c] = (reg[r,c] - 1) * n + rank[r,c]); % only need this line
include "alldifferent.mzn";
constraint alldifferent(r in ROW, c in COL)(x[r,c]); % no pair reappears
constraint forall(r in ROW)(
                    alldifferent(c in COL)(reg[r,c])
                    /\ % regiments and ranks
                    alldifferent(c in COL)(rank[r,c])
            ); % different in columns
constraint forall(c in COL)(
                    alldifferent(r in ROW)(reg[r,c])
                    /\ % regiment and ranks
                    alldifferent(r in ROW)(rank[r,c]))
            ; % different in rows

solve :: int_search([x[r,c] | r in ROW, c in COL], dom_w_deg, indomain_min, complete)
            satisfy;
output [ "x = \(x);\nreg = \(reg);\nrank = \(rank);\n"];
```

## -- 2015.3.a
```
int: n; % number of tasks
set of int: TASK = 1..n;
array[TASK] of int: duration; % duration of each task (mins)
set of TASK: cold; % which tasks are cold
set of TASK: hot = TASK diff cold; % which tasks are hot
int: makespan; % total rolling time available

array[TASK] of var 0..makespan: start; % start time of each task
var 0..makespan: endtime; % when rolling finishes


constraint forall(t in TASK)(
                start[t] + duration[t] <= endtime
            );
include "globals.mzn"
constraint disjuntive(start , duration);

solve minimize endtime;
```

## -- 2015.3.b
```
int: n; % number of tasks
set of int: TASK = 1..n;
array[TASK] of int: duration; % duration of each task (mins)
set of TASK: cold; % which tasks are cold
set of TASK: hot = TASK diff cold; % which tasks are hot
int: makespan; % total rolling time available

array[TASK] of var 0..makespan: start; % start time of each task
var 0..makespan: endtime; % when rolling finishes


constraint forall(t in TASK)(
                start[t] + duration[t] <= endtime
            );
include "globals.mzn"
constraint disjuntive(start , duration);

% constraint forall(h in hot)(not exists(c in cold)(
%                 start[c] >= start[h] + duration[h]
%                 /\
%                 start[c] < start[h] + duration[h] + 30
%     ));

set of int: TASK0 = 0..n;
array[TASK0] of TASK0: prev;
constraint alldifferent(prev);
constraint forall(t in TASK)(
        prev[t] > 0
        -> 
        start[prev[t]] + duration[prev[t]]
        * 30 * ((prev[t] in hot) /\ (t in cold))
        <= start[t]
    ); /* beautiful!!!!!!!!!!!!!!! */

solve minimize endtime;
```

## -- 2015.4.b
```
function var int: strictvalley(array[int] of var int: x) = 
        sum(i in min(index_set(x))+1 .. max(index_set(x))-1)
            (x[i]<x[i-1]/\x[i]<x[i+1]);

% function var int: strictvalley(array[int] of var int: x) =
%     sum(i in 1..length(x)-2)(x[i] > x[i+1] /\ x[i+1] < x[i+2]);

var int: n = strictvalley( [1,1,4,8,2,7,3,3,6,1] );

solve satisfy;
output [show(n)];
```

## -- 2015.4.c
* can be used in a negative context
    * it introduces no local variables that are not defined

## -- 2015.4.d
```
array[lb(y)..ub(y)] of 0..1: yb;
constraint x = sum(i in lb(y)..ub(y))(a[i]*yb[i]);
constraint y = sum(i in lb(y)..ub(y))(i*yb[i]);
```

## -- 2015.5.a
```
int: k; % number of nurses
set of int: NURSE = 1..k;
int: m; % number of days
set of int: DAY = 1..m;
set of int: SHIFT = 1..3;
int: day = 1; int: night = 2; int: dayoff = 3;
int: o; % nurses required on day shift
int: l; % lower bound for nurses on nightshift
int: u; % upper bound for nurses on nightshift
array[NURSE,DAY] of var SHIFT: x;
constraint forall(n in NURSE, d in 1..m-2)(
                    x[n,d] = night /\ x[n,d+1] = night -> x[n,d+2] = dayoff
                    /\
                    x[n,d] = night -> x[n,d+1] != day
            );
constraint forall(n in NURSE)( x[n,m-1] = night -> x[n,m] != day );

% constraint forall(d in DAY)(sum(n in NURSE)(x[n,d] = day) = o);
% constraint forall(d in DAY)(
%                     sum(n in NURSE)(x[n,d] = night) >= l
%                     /\
%                     sum(n in NURSE)(x[n,d] = night) <= u
%             );

include "globals.mzn";
constraint forall(d in DAY)
                (global_cardinality_low_up([ x[n,d] | n in NURSE ],
                                            [day, night],
                                            [o,l],
                                            [o,u])
            );

solve satisfy;
```

## -- 2015.5.b
* comment out constraint one by one until satisfiable, to find the smallest set of constraints that causing the unsatisfiability, then concentrate on them
* build an expected solution by hand for a small example and add it to the model, hoping to get a better msg from MiniZinc

## -- 2015.5.c
* precedence

## -- 2015.7.b
```
predicate strange(array[int] of var int: x, int: y) =
    forall(i in min(index_set(x)) .. max(index_set(x))-1 )(
            x[i] + y <= x[i+1]
    );
```

## -- 2015.8
```
int: N; % number of airports
set of int: NODE = 1..N; % airports
int: E; % number of flight routes
set of int: EDGE = 1..E; % routes
array[EDGE] of NODE: fst; % first airport
array[EDGE] of NODE: snd; % second airport

int: C; % number of cargoes
set of int: CARGO = 1..C; % cargoes
array[CARGO] of NODE: from; % cargo pickup place
array[CARGO] of NODE: to; % cargo dropoff place

set of int: ACT = 0..C+N+1; % possible actions a,(egs where C = 2, N = 6)
int: donothing = 0; % donothing, 0 represents donothing
set of int: PICKUP = 1..C; % pickup a, e.g. 2 represents pickup 2
set of int: MOVE = C+1..C+N; % move (a - C), e.g. 6 represents move 4
int: drop = C + N + 1; % drop, 9 represents drop

int: maxsteps; % max actions
set of int: STEP = 0..maxsteps; % steps

NODE: start; % aircraft start


N = 6;
E = 8+8;
fst = [1,1,2,2,3,3,4,5] ++ [2,4,3,6,4,5,5,6];
snd = [2,4,3,6,4,5,5,6] ++ [1,1,2,2,3,3,4,5];
C = 2;
from = [4,5];
to = [2,6];
maxsteps = 20;
start = 1;

% constraint act = [6, 1, 3, 4, 9, 5, 7, 2, 8, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
% constraint steps = 10;

set of int: CARGO0 = 0..C; % cargo or 0 = nothing
array[STEP] of var NODE: posn; % position of plane
array[STEP] of var CARGO0: carry; % what its carrying if anything
array[STEP] of var ACT: what; % action taken
array[STEP,CARGO] of var bool: delivered; % what cargo is delivered!!!!!!!!!!!
var STEP: steps; % steps in plan

% predicate act_posn(var NODE: pos, var ACT: a, var NODE: npos) =
%     if a in MOVE then
%     (
%         exists(e in EDGE)(
%             snd[e] = a-C
%             /\
%             pos = fst[e]
%             /\
%             npos = snd[e]
%         )
%     )
%     else npos = pos endif
% ;
predicate act_posn(var NODE: pos, var ACT: a, var NODE: npos) =
    if a in MOVE then
    (
        npos = a-C
        /\
        exists(e in EDGE)(
            fst[e] = pos
            /\
            snd[e] = npos
        )
    )
    else npos = pos endif
;

predicate act_carry(var CARGO0: crr,
                    array[CARGO] of var bool: dlv,
                    var NODE: pos,
                    var ACT: a,
                    var CARGO0: ncrr,
                    array[CARGO] of var bool: ndlv) =
            if a in PICKUP then
            (
                ncrr = a
                /\
                ndlv = dlv
                /\
                crr = 0
                /\
                not dlv[a]
                /\
                pos = from[a]
            )
            elseif a = drop then
            (
                ncrr = 0
                /\
                ndlv = [ if crr = c then 1 else dlv[c] endif | c in CARGO]
                /\
                crr != 0
                /\
                pos = to[crr]
            )
            else
            (
                ncrr = crr
                /\
                ndlv = dlv
            )
            endif
;

constraint posn[0] = start
            /\
            carry[0] = 0
            /\
            what[0] = donothing
            /\
            forall(c in CARGO)(delivered[0,c] = 0)
            ;

constraint forall(s in 1..maxsteps)(
                act_posn(posn[s-1], what[s], posn[s])
                /\
                act_carry(crr[s-1],
                        [ delivered[s-1, c] | c in CARGO],
                        posn[s-1],
                        what[s],
                        crr[s],
                        [ delivered[s, c] | c in CARGO])
                /\
                % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                (s > steps -> what[s] = donothing)
            );

constraint forall(c in CARGO)(delivered[steps, c]);

solve :: int_search([steps], input_order, % cool!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    indomain_min, complete)
        minimize steps;

array[1..maxsteps] of var ACT: act = [what[s] | s in 1..maxsteps]; 

output ["act = \(act)"] ++
        ["steps = \(steps)"];
```

## -- 2015.7.a
```
a + 3 <= b
a + 3 <= c
a + 3 <= d
b + 3 <= c
b + 3 <= d
c + 3 <= d
```

## -- 2015.6.a
```
-7..7 -7..7 -7..7
y = abs(x)
-7..7 0..7 -7..7
y = 2z
-7..7 0..6 0..3
y = abs(x)
-6..6 0..6 0..3
--fixed--
x <= 0
-6..0 0..6 0..3
x != 0
-6..-1 0..6 0..3
y = abs(x)
-6..-1 1..6 0..3
y = 2z
-6..-1 2..6 1..3
z != 1
-6..-1 2..6 2..3
y = abs(x)
-6..-2 2..6 2..3
y = 2z
-6..-2 4..6 2..3
y = abs(x) %??????????????????
-6..-4 4..6 2..3 %????????????
```

## -- 2015.6.b
```
-7..7 -7..7 -7..7
y = abs(x)
-7..7 0..7 -7..7
y = 2z
-7..7 0,2,4,6 0..3
x != 0
-7..-1,1..7 0,2,4,6 0..3
z != 1
-7..-1,1..7 0,2,4,6 0,2,3
y = abs(x)
-6,-4,-2,2,4,6 2,4,6 0,2,3
y = 2z
-6,-4,-2,2,4,6 4,6 2,3
y = abs(x)
-6,-4,4,6 4,6 2,3
--fixed--
x <= 0
-6,-4,-2 4,6 2,3
y = abs(x) %????????????????????????
-6,-4 4,6 2,3 %?????????????????????
```

## -- 2014.6.a
```
0..9 0..5 0..5
x >= 4
4..9 0..5 0..5
x = y*z
4..9 1..5 1..5
z != 1
4..9 1..5 2..5
x = y*z % !!!!!
4..9 1..4 2..5
z <= 3
4..9 1..4 2,3
x = y*z
4..9 2..4 2,3
y = 3
4..9 3 2,3
x = y*z
6..9 3 2,3
```

## -- 2014.6.b
```
0..9 0..5 0..5
x = y*z
0..6,8,9 0..5 0..5
z != 1
0..6,8,9 0..5 0,2..5
x = y*z
0,2..6,8,9 0..5 0,2..5
x >= 4
4..6,8,9 0..5 0,2..5
x = y*z
4..6,8,9 1..4 2..5
z <= 3
4..6,8,9 1..4 2,3
x = y*z
4,6,8,9 2..4 2,3
y = 3
4,6,8,9 3 2,3
x = y*z
6,9 3 2,3
```

## -- 2014.6.c
```
setub(x, 1);
setlb(x,-1);
if(ub(x)= 0) setub(y, 0);
if(ub(x)=-1) setub(y,-1);
if(lb(x)= 0) setlb(y, 0);
if(lb(x)= 1) setlb(y, 1);
if(ub(y)=0) setub(x, 0);
if(ub(y)<0) setub(x,-1);
if(lb(y)=0) setlb(x, 0);
if(lb(y)>0) setlb(x, 1);
```
