# Week 2
## 0-1 Knapsack Problem/Set Selection Problem
+ an array of 0-1 variables
    * `array[MOVES] of var 0..1: occur;`
+ an array of 0-1 variables
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