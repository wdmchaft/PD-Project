%cd "/home/adriaan/Homework/EECE 496/Starting Data/Pilot03";
Platform = load('Pilot03\Pilot03_Platform_Position_fwdSHRT.txt');
Knee = load('Pilot03\Pilot03_Knee_Angles_fwdSHRT.txt');
Ankle = load('Pilot03\Pilot03_Ankle_Angles_fwdSHRT.txt');
Hip = load('Pilot03\Pilot03_Hip_Angles_fwdSHRT.txt');
Shoulder = load('Pilot03\Pilot03_Shoulder_Angles_fwdSHRT.txt');
Trunk = load('Pilot03\Pilot03_Trunk_Angles_fwdSHRT.txt');
Elbow = load('Pilot03\Pilot03_Elbow_Angles_fwdSHRT.txt');
Neck = load('Pilot03\Pilot03_Neck_Angles_fwdSHRT.txt');

% note same time vector is the first column of all data sets
% number of trials depends on trial type:
% BdLgRch = FdLgRch = 7 for P3
% bwdSHRT = fwdSHRT = 5 for P3
% bwdLONG = fwdLONG = 5 for P3

time = Ankle(:,1);
Joints.Trial1 = [Ankle(:,2) Elbow(:,2) Hip(:,2) Knee(:,2) Neck(:,2) Shoulder(:,2) Trunk(:,2)];
Joints.Trial2 = [Ankle(:,3) Elbow(:,3) Hip(:,3) Knee(:,3) Neck(:,3) Shoulder(:,3) Trunk(:,3)];
Joints.Trial3 = [Ankle(:,4) Elbow(:,4) Hip(:,4) Knee(:,4) Neck(:,4) Shoulder(:,4) Trunk(:,4)];
Joints.Trial4 = [Ankle(:,5) Elbow(:,5) Hip(:,5) Knee(:,5) Neck(:,5) Shoulder(:,5) Trunk(:,5)];
Joints.Trial5 = [Ankle(:,6) Elbow(:,6) Hip(:,6) Knee(:,6) Neck(:,6) Shoulder(:,6) Trunk(:,6)];

figure();
plot(time, Joints.Trial1); legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
figure();
plot(time, Platform(:,2));
%figure();
%plot(time, Joints.Trial2); legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
%figure();
%plot(time, Joints.Trial3); legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
%figure();
%plot(time, Joints.Trial4); legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
