%get parameters [b1,b2,b3,K1,K2,K3,theta1bias,theta2bias,theta3bias]
initialGuess = [1.2,1.5,0,0,0,0,0,0,0];
%get cost
f = objectiveFunc(b1,b2,b3,K1,K2,K3,theta1bias,theta2bias,theta3bias)
%optimization
jointTorques = fminsearch(@f,initialGuess);


