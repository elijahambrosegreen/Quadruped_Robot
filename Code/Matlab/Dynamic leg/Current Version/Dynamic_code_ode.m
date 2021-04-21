function dy = Dynamic_code_ode(t,y,P)


y1 = y(1);
y2 = y(2);
y3 = y(3);
y4 = y(4);
y5 = y(5);
y6 = y(6);

L1=P.L1;
L2=P.L2;
L3=P.L3;
M1=P.M1;
M2=P.M2;
M3=P.M3;
g=P.g;
c=1;
u1 = c*y1;
u2 = 0;
u3= 0;

u=[u1 u2 u3]';
dy = Dynamic_code(y,u,P);