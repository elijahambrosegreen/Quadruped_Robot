clear;close all;clc;
%% Define Mechanical Properties 
% Define the mechanical properties of link 1.
M1 = .716;  %[lb] Mass of femur with encoder                   
R1 = 4.75; % [in]
I1 = 496.26; %[in^4]
L1 = 9.25; %[in]

% Define the mechanical properties of link 2.
M2 = .4299; %[lb]
R2 = 4.75; %[in]
I2 = 496.26; %[in^4]
L2 = 9.25; %[in
% Define the mechanical properties of link 3.

M3 = 0.10992; %[lb]
R3 = 3.5; %[in]
I3 = 122.09; %[in^4]
L3 = 7.875;
g = 9.81;
%Stores system paramters in a vector; 
P = [M1,R1,I1,L1,M2,R2,I2,L2,M3,R3,I3,L3,g];

%Joint parameters
b1 = 0;
b2 = 0;
b3 = 0;
K1 = -5;
K2 = -5;
K3 = -15; 
theta1bias = 0;
theta2bias = 0;
theta3bias = 0;
%Stores Joint Parameters in a vector
U = [b1,b2,b3,K1,K2,K3,theta1bias,theta2bias,theta3bias];
%% Model
init_t=0;
final_t=10;
dt=0.001;
N= (final_t-init_t)/dt;
t_span=linspace(init_t,final_t,N);

x0=[0 0 0 0 0 0]';

jointValues = [0,0,0,-5.01,-5.55,-15.12,0,0,0]
[t,x] = ode45(@(t,x) Dynamic_code(t,x,P,U),t_span,x0);
[t2,e] = ode45(@(t,y) Dynamic_code(t,y,P,jointValues),t_span,x0);


px=[0 0 0 0];
py=[0 0 0 0];

ex = [0 0 0 0];
ey = [0 0 0 0];

figure; hold on;
h = plot(px,py,'ro-');      
z = plot(ex,ey,'bo-');
legend('Model', 'Optimized Model');
axis([-(L1+L2+L3+4) (L1+L2+L3+4) -(L1+L2+L3+4) (L1+L2+L3+4)]);

for i=1:N-1
    if(mod(i,50)==1)
        x1=x(i,1);
        x2=x(i,3);
        x3=x(i,5);
        p0x=0;
        p0y=0;
        p1x = L1*cos(x1);
        p1y = L1*sin(x1);
        p2x = L1*cos(x1)+L2*cos(x1+x2);
        p2y = L1*sin(x1)+L2*sin(x1+x2);
        p3x = L1*cos(x1)+L2*cos(x1+x2)+L3*cos(x1+x2+x3);
        p3y = L1*sin(x1)+L2*sin(x1+x2)+L3*sin(x1+x2+x3);
        px=[p0x p1x p2x p3x];
        py=[p0y p1y p2y p3y];
        
        %Optimized Joint positions
        e1=e(i,1);
        e2=e(i,3);
        e3=e(i,5);
        e0x=0;
        e0y=0;
        e1x = L1*cos(e1);
        e1y = L1*sin(e1);
        e2x = L1*cos(e1)+L2*cos(e1+e2);
        e2y = L1*sin(e1)+L2*sin(e1+e2);
        e3x = L1*cos(e1)+L2*cos(e1+e2)+L3*cos(e1+e2+e3);
        e3y = L1*sin(e1)+L2*sin(e1+e2)+L3*sin(e1+e2+e3);
        ex=[e0x e1x e2x e3x];
        ey=[e0y e1y e2y e3y];

        h.XData = px;
        h.YData = py;
        z.XData = ex;
        z.YData = ey;
        
        drawnow
        pause(0.001);
       
    end
end

