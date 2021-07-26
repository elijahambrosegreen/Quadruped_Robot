function data = ProccessRat2()
load('JointAngles&timeNoAct.mat','NWmotion4','timeVec4');

x1 = NWmotion4(10:100,7);
x2 = 34.657; %tilt of rat hip datacollection
x3 = 180-(x1-x2);
x4 = NWmotion4(10:100,8);
x5 = -(180-x4);
x6 = NWmotion4(10:100,9);
x7 = 180-x6;
RatHipAngle = deg2rad(x3);
RatKneeAngle = deg2rad(x5);
RatAnkleAngle = deg2rad(x7);
totalTime = timeVec4(10:100)';
data = [RatHipAngle,RatKneeAngle,RatAnkleAngle,totalTime];
end