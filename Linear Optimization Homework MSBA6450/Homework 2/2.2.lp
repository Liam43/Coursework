/* Objective function */
min: 4p1 + 6p2 + 8p3 + 10p4 + 12p5+ 14p6 +
     2s1 + 2s2 + 2s3 + 2s4 + 2s5 + 2s6 +
     1000b1 + 1000b2 + 1000b3 + 1000b4 + 1000b5 + 1000b6 +
     700o1 + 700o2 + 700o3 + 700o4 + 700o5 + 700o6 +
     500c1 + 500c2 + 500c3 + 500c4 + 500c5 + 500c6;

/* Variable bounds */
/*demand constraints*/
s0 = 50;
s0 + p1 - s1 = 100;
s1 + p2 -s2 = 150;
s2 + p3 -s3 = 200;
s3 + p4 -s4 = 150;
s4 + p5 -s5 = 100;
s5 + p6 -s6 = 300;
/*storage constraints*/
s1 >= 30;
s2 >= 30;
s3 >= 30;
s4 >= 30;
s5 >= 30;
s6 >= 30;
/*capacity, fixed cost constraints*/
p1 <= 250b1;
p2 <= 200b2;
p3 <= 150b3;
p4 <= 200b4;
p5 <= 150b5;
p6 <= 250b6;
/*setup - variable o, shutdown - variable c constraints*/
o1 >= b1;
o2 >= b2 - b1;
o3 >= b3 - b2;
o4 >= b4 - b3;
o5 >= b5 - b4;
o6 >= b6 - b5;

c1 >= b1 - b2;
c2 >= b2 - b3;
c3 >= b3 - b4;
c4 >= b4 - b5;
c5 >= b5 - b6;
c6 >= b6;

/*Not consecutive for 3 months*/
/*use <= 3 instead of <4*/
b1 + b2 + b3 + b4 <= 3;
b2 + b3 + b4 + b5 <= 3;
b3 + b4 + b5 + b6 <= 3;

/*binary constraints*/
bin b1;
bin b2;
bin b3;
bin b4;
bin b5;
bin b6;

bin o1;
bin o2;
bin o3;
bin o4;
bin o5;
bin o6;

bin c1;
bin c2;
bin c3;
bin c4;
bin c5;
bin c6;