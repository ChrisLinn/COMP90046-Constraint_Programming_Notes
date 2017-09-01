# Week 6?
## Debugging
+ Assertions
    * `assert(boolexpr, stringexpr)`
    * `assert(boolexpr, stringexpr, expr)`
        - return expr if boolexpr holds
+ Tracing
    * `trace(stringexp, exp)`
+ Relational Semantics
    * MiniZinc assumes the relational semantics
        - Partial Functions in Modeling
            + division (by zero?)
            + array access (out of bounds?)
            + But you should model to avoid partial function applications
                * x div y assure y != 0
                * x[i] assure variable or parameter i is in the index_set of x
        - Undefined “floats” to the nearest enclosing Boolean context and becomes false
        - Some obvious transformations are invalid
            + `not(x div y = 1)` not same as `x div y != 1` 
                * (x,y) = (0,0) is a solution of the first
+ Too many solutions, superoptimal answer
    * constraints wrong
        - for example, precedence of operators
        - Isolate which constraint definition should remove the solution
        - Examine the definition + fix it!
    * just too many
        - `var_sym(a);`
        - `solve minimize sum(a);`
            + just find some of them
+ Missing solutions, suboptimal answer
    * Adding a solution to the problem
    * Relaxing constraints
        - and trace
+ No solutions, ?????
    * worst case
        - the model is too slow to solve!
            + simplify the model
                * take into account less of the problem
                    - look at the solutions of the simplified problem
                        + can you use these
            + decompose the model
                * break the problem into two parts
                    - solve the first part
                        + fix a solution to the first part to define the second part

## What else
+ Table Global Constraint
+ self edge at the destination for escape.mzn
+ Make an educated guess on the maximum possible length of the path
+ sliding sum
    * resting