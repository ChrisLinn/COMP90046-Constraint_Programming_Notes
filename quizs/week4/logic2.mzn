enum SHIFT = { EVE, NIGHT, OFF};

var SHIFT: x;
var SHIFT: y;

constraint x = NIGHT \/ (x = EVE -> y = EVE /\ y = OFF);

solve satisfy;
