# week 1

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

## discrete opt
+ math
    * best possible value
+ what does ... mean
    * (x = y ∨ x = -y) ∧ x ≥ y ∧ x ≥ -y
        - x = |y|
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
