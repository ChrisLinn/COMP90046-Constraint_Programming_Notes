# Week 1

## Objectives
+ __model__ constraint satisfaction and optimization problems of reasonable complexity using a modelling
language;
+ explain (to a senior computer science student) how some constraint __solvers__ work (e.g. linear programming, finite domain propagation, Boolean satisfaction);
+ use the MiniZinc modelling language to model integer constraint problems;
+ __evaluate__ the suitability of a particular constraint model for solving a problem;
+ program different effective search strategies for __combinatorial problems__;
+ __improve__ the execution of a constraint program by reasoning about its search behaviour

## Syllabus
+ Modelling
    * simple modelling
    * modelling with data structures
    * predicates
    * global constraints
    * effective modelling
+ Constraint solving methods
    * Finite domain propagation
    * linear programming
    * mixed integer programming
    * Programming search and optimization.

## Recommended Texts
+ (Recommended) MiniZinc Tutorial: http://www.minizinc.org/downloads/doc-latest/minizinc-tute.pdf A tutorial on MiniZinc, with many detailed examples.
+ (Recommended) The OPL Optimization Programming Language. Pascal Van Hentenryck, MIT Press. 1999. A commercial product similar to MiniZinc
+ (Recommended) Programming with Constraints: an Introduction. Kim Marriott and Peter J. Stuckey, MIT Press. 1998. Introduction to Constraint Logic Programming
+ (Recommended) Operations Research: Applications and Algorithms. Wayne L. Winston, Brooks Cole, 1998. Introduction to linear programming, mixed integer programming
+ (Recommended) Principles of Constraint Programming. Krzysztof Apt. Cambridge. 2003. A highly theoretical book, interesting and well written.

## Discrete optimization
+ math
    * best possible value
+ what does these mean
    * `(x = y ∨ x = -y) ∧ x ≥ y ∧ x ≥ -y`
        - `x = |y|`
+ minimization

## The Zinc Mantra
+ model problems once
    * rapidly
+ solve
    * with many different technologies
    * in many different ways
    * rapidly

## Syllabus
+ What is discrete optimisation
+ Basic modelling
+ Modelling sets and functions
+ Functions and predicates
+ Debugging models
+ Scheduling and packing
+ Flattening (How MiniZinc works)
+ CP solving (and programming search)
+ MIP solving

## MiniZinc
### .mzn
+ Include
    * will look in the current directory and in your MiniZinc library path
    * for
        - break large models into smaller pieces
        - load library definitions of global constraints
        - control which global constraint definition MiniZinc loads for a particular constraint solver
+ parameter definitions
    * assigned with a value but only __once__
    * equivalent:
        ```
        int: i=3;
        par int: i=3;
        int: i; i=3;
        ```
    * Set Parameters
        ```
        set of type: name = fixed-set ;
        ```
+ decision variable definitions
    * assigned with a __fix value expr__ but only __once__
    * equivalent:
        ```
        var int: i; constraint i>= 0; constraint i <= 4;
        var 0..4: i;
        var {0,1,2,3,4}: i;
        ```
    * equivalent:
        ```
        var int: i = x+3;
        var int: i; constraint i = x+3;
        ```
    * Variable Lookup
+ constraints
    * can be 
        - liner
        - modulo, multiplication, division
        - disequality
        - ...
    * `forall(i in range)(bool-expression)`
    * `sum(i in range)(expression)`
+ objective
+ output
    * do not extend more than one line
    * `show(v)` 
        - the value of v as a string
        - `\(v)` 
            + show `v` inside a string literal
        - `++`
            + concatenation
    * if no output
        - output all declared variables which are not assigned with an expr
        - so no need to seek an optimal soltion
            ```
            var 100..800: army;

            constraint army mod 5 = 2;
            constraint army mod 7 = 2;
            constraint army mod 12 = 1;

            solve satisfy; 
            ```
+ `-----------------------` 
    * indicates a solution
+ `=======================` 
    * best solution
+ `=====UNSATISFIABLE=====`

### .dzn
+ data file
    * `minizinc armyd.mzn army.dzn`
    * or
        - `minizinc armyd.mzn -D”budget = 20000;”`
        - IDE
            + load `.dzn`
            + enter in a popup window
            + ide will not ask for a data file if no para
                * to specify decision var, use _configuration_ tab
                * or "run this data file" for a model in a proj
    * multiple data files
    * `minizinc model.mzn d1.dzn d2.dzn`

## Linear models
+ linear programming
    * interger case: NP-hard
+ basis of most real-word discrete optimization

## Graph Coloring
+ enumerated types
    * declare
        - `enum COLOR = { };` 
    * use
        - `[var] enum_name: var_name`
        -  
            ```
            % products
            enum PRODUCT;
            % Profit per unit for each product
            array[PRODUCT] of float: profit; 
            ```
    * can be used in
        - decisions
        - paras
        - array indices
        - sets
+ application
    * register allocation
    * timetabling
+ pure graph coloring is better handled by specialized alogrithms
+ if add some side constraints about how specific parts of the graph should be colored, then using a general discrete optimization approach like MiniZinc
+ or `enum: COLOR;` in _color.mzn_ and `COLOR={R,W,B,G,P};` in _color.dzn_

## Array
+ .
    ```
    par int: n;
    array[1..n] of var 0..3: x;
    ```
+ .
    ```
    % products
    enum PRODUCT;
    % Profit per unit for each product
    array[PRODUCT] of float: profit;
    
    % resources
    enum RESOURCE;
    % Amount of each resource available
    array[RESOURCE] of float: capacity;
    
    % Units of each resource required to produce
    % 1 unit of product
    array[PRODUCT,RESOURCE] of float: consumption; %two dimensional
array declaration
    ```
+  
    ```
    constraint forall(r in RESOURCE)(
        sum (p in PRODUCT)
            (consumption[p, r] * produce[p]) <= capacity[r]
    ); 
    ```
+ The builtin function length returns the length of a 1D array
+ An array can be multi-dimensional
    * `array[index_set1,index_set 2, …] of type`
        - index set
            + an integer range or enumerated type
            + or a fixed set expression whose value is a range
+ Elements of an array can be anything but another array
    * i.e. no nested array
+ `|` for 2D arrays
    * separates rows 
+ Arrays on any dimension __(≤ 6)__ can be initialised using the __arraynd__ family of functions which turns a 1D array into an nD array
    ```
    consumption = array2d(1..5, 1..4,
         [1.5, 1.0, 1.0, 1.0,
         2.0, 0.0, 2.0, 0.0,
         1.5, 0.5, 1.0, 1.0,
         0.5, 1.0, 0.9, 1.5,
         0.1, 2.5, 0.1, 2.5];
    ```
+ we can flatten an nD array into a list (1D array) using comprehension
    ```
    array[1..20] of int: list =
         [consumption[i,j] | i in 1..5, j in 1..4]; 
    ```
    * array comprehension
        - `[ expr | generator1, generator2, … ]`
        - `[ expr | generator1, generator2, … where test ]`
            ```
            [i + j | i, j in 1..4 where i < j]
            = [1+2, 1+3, 1+4, 2+3, 2+4, 3+4]
            = [3, 4, 5, 5, 6, 7] 
            ```
+ iteration
    * Lists of numbers
        - `sum`
        - `product`
        - `min`
        - `max` 
    * Lists of constraints
        - `forall`
            + `forall(i,j in 1..10 where i < j)  (a[i] != a[j]) ` is equivalent to (1-argument forall) `forall([a[i] != a[j] | i,j in 1..10 where i < j])`
        - `exists`

## Set
+ Sets are declared by `set of type`
    * integers, floats or Booleans
    * Sets can also be used as types
+ operators
    * `in`
    * `union`
    * `intersect`
    * `subset`
    * `superset`
    * `diff`
    * `symdiff`
+ size of the set
    * `card`
+  
    ```
    set of int: COL = 1..5;
    set of int: ROW = 1..2;
    array[ROW,COL] of int: c =
        [| 250, 2, 75, 100, 0
        | 200, 0, 150, 150, 75 |];
    b = array2d(COL, ROW,
        [c[j, i] | i in COL, j in ROW]); 
    ```


## Models and Instances
+ A model is a formal description of a class of (in our case) optimization problems
+ An instance is one particular optimization problem

## Not all solvers are qual
+ MIP solvers cannot express multiplication of continuous variables, polynomial
+ for a mixed integer programming problem, G12 MIP is almost instant

## Golbal Constraint
```
% alldifferent messed up digits
include "alldifferent.mzn";

constraint alldifferent([M1,M2,M3,M4,M5]); 
```

## Pitfall
+ Calculations with floating point numbers can be inaccurate.