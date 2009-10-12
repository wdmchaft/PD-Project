% These are the parameters to be set before running...
Subject = 'Pilot03';
Trial   = '4';

Platform = load([Subject,'\',Subject,'_Platform_Position_fwdSHRT.txt']);
Knee = load([Subject,'\', Subject, '_Knee_Angles_fwdSHRT.txt']);
Ankle = load([Subject, '\', Subject, '_Ankle_Angles_fwdSHRT.txt']);
Hip = load([Subject, '\', Subject, '_Hip_Angles_fwdSHRT.txt']);
Shoulder = load([Subject, '\', Subject, '_Shoulder_Angles_fwdSHRT.txt']);
Trunk = load([Subject, '\', Subject, '_Trunk_Angles_fwdSHRT.txt']);
Elbow = load([Subject, '\', Subject, '_Elbow_Angles_fwdSHRT.txt']);
Neck = load([Subject, '\', Subject, '_Neck_Angles_fwdSHRT.txt']);

% note same time vector is the first column of all data sets
% number of trials depends on trial type:
% BdLgRch = FdLgRch = 7 for P3
% bwdSHRT = fwdSHRT = 5 for P3
% bwdLONG = fwdLONG = 5 for P3

time = Ankle(:,1);

Trial_num = eval(Trial);
Joints.Trial = [Ankle(:,Trial_num+1) Elbow(:,Trial_num+1) Hip(:,Trial_num+1) Knee(:,Trial_num+1) Neck(:,Trial_num+1) Shoulder(:,Trial_num+1) Trunk(:,Trial_num+1)];

screen_size = get(0, 'ScreenSize');
% Syntax for position is [xstart, ystart, width, height]. For some reason, it still overshoots...
figure('Name', ['SUBJECT: ', Subject, ' TRIAL: ', Trial], 'NumberTitle', 'off', 'Position', [4 screen_size(4)/3-75 2*screen_size(3)/3 2*screen_size(4)/3]);

subplot(2,1,1);
plot(time, Joints.Trial);
legend('Ankle','Elbow','Hip','Knee','Neck','Shoulder','Trunk');
subplot(2,1,2);
plot(time, Platform(:,2)); legend('Platform Position');
