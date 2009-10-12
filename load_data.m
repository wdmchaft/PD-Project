%cd "/home/adriaan/Homework/EECE 496/Starting Data/Pilot03";
Data = 'Pilot03';
Platform = load(strcat(Data,'\',Data,'_Platform_Position_fwdSHRT.txt'));
Knee = load(strcat(Data,'\', Data, '_Knee_Angles_fwdSHRT.txt'));
Ankle = load(strcat(Data, '\', Data, '_Ankle_Angles_fwdSHRT.txt'));
Hip = load(strcat(Data, '\', Data, '_Hip_Angles_fwdSHRT.txt'));
Shoulder = load(strcat(Data, '\', Data, '_Shoulder_Angles_fwdSHRT.txt'));
Trunk = load(strcat(Data, '\', Data, '_Trunk_Angles_fwdSHRT.txt'));
Elbow = load(strcat(Data, '\', Data, '_Elbow_Angles_fwdSHRT.txt'));
Neck = load(strcat(Data, '\', Data, '_Neck_Angles_fwdSHRT.txt'));

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

screen_size = get(0, 'ScreenSize')
% Syntax is [xstart, ystart, width, height]. For some reason, it still
% overshoots...
figure('Position', [4 screen_size(4)/3-75 2*screen_size(3)/3 2*screen_size(4)/3]);
subplot(2,1,1);
plot(time, Joints.Trial2); legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
subplot(2,1,2);
plot(time, Platform(:,2)); legend('Platform Position');
%figure();
%plot(time, Joints.Trial2); legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
%figure();
%plot(time, Joints.Trial3); legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
%figure();
%plot(time, Joints.Trial4); legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
