# Week 1

## Objectives
+ model constraint satisfaction and optimization problems of reasonable complexity using a modelling
language;
+ explain (to a senior computer science student) how some constraint solvers work (e.g. linear programming, finite domain propagation, Boolean satisfaction);
+ use the MiniZinc modelling language to model integer constraint problems;
+ evaluate the suitability of a particular constraint model for solving a problem;
+ program different effective search strategies for combinatorial problems;
+ improve the execution of a constraint program by reasoning about its search behaviour

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

## MiniZinc(.mzn)
+ parameter definitions
    * assigned with a value but only __once__
    * equivalent:
        ```
        int: i=3;
        par int: i=3;
        int: i; i=3;
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
+ constraints
    * can be 
        - liner
        - modulo, multiplication, division
        - disequality
        - ...
    * objective
+ output
    * do not extend more than one line
    * `show(v)` 
        - the value of v as a string
        - `\(v)` 
            + show `v` inside a string literal
        - ++
            + concatenation
    * if no output
        - output all declared variables which are not assigned with an expr
        - so no need to seek an optimal soltion
+ `-----` 
    * indicates a solution
+ `=====` 
    * best solution

## Linear models
+ linear programming
    * interger case: NP-hard
+ basis of most real-word discrete optimization

