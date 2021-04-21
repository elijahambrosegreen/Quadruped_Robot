function dy = Dynamic_code_ode(t,y,P)


y1 = y(1);
y2 = y(2);
y3 = y(3);
y4 = y(4);
y5 = y(5);
y6 = y(6);
%{ 
L1=P.L1;
L2=P.L2;
L3=P.L3;
M1=P.M1;
M2=P.M2;
M3=P.M3;
g=P.g;
%}
c1=0; c2 = 0;c3 =0;K1 = 0;K2=0;K3 = 0; theta1b=0;theta2b = 0;theta3b = 0;
u1 = c1*y2+K1*(y1+theta1b);
u2 = c2*y4+K2*(y3+theta2b);
u3= c3*y6+K3*(y5+theta3b);

u=[u1 u2 u3]';
dy = Dynamic_code(y,u,P);