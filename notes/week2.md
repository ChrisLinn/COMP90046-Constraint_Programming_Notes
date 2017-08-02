# Week 2
## 0-1 Knapsack Problem/Set Selection Problem
+ an array of 0-1 variables
    * `array[MOVES] of var 0..1: occur;`
+ an array of bool variables
    * `array[MOVES] of var bool: occur;`
    * bool2int
        - automatically
+ a set variable
    * `var set of {1,2,3}: x` 
    * Set Operators
        - in
        - subset
        - superset
        - intersect
        - union
        - card
        - diff
            + `x diff y` means x\y
        - symdiff
            + {1,2,5,6} symdiff {2,3,4,5} = {1,3,4,6}
+ application
    * selection of investments
    * least wasteful cutting of raw materials
    * knapsack crytosystems

## multiple ways to represent fixed cardinality sets
+ var set of OBJ + cardinality 
    * good if the solve natively supports sets
        - CP solvers
        - quick
    * good when OBJ is not too big
+ array[1..u] of var OBJ
    * good when u is small
    * only for fixed cardinality u
+ array[1..u] of var OBJx
    * need to represent the "null" object

## 2 critical issues in modelling decisions
+ ensure each solution to the model is a solution of the problem
    * e.g cardinality
+ try to ensure each solution of the problem only has one solution in the model (deal with symmetry)

