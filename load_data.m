% These are the parameters to be set before running...
Subject  = 'Pilot03';
Trial    = '2';
Show     = 'AEHKNST';
Type     = 'FdLgRch';%'bwdLONG';
Plot     = 1;
IDSystem = 0;

Order = struct('A', 'Ankle', 'E', 'Elbow', 'H', 'Hip', 'K', 'Knee', 'N', 'Neck', 'S', 'Shoulder', 'T', 'Trunk');

Platform = load([Subject, '\', Subject, '_Platform_Position_', Type, '.txt']);
Ankle    = load([Subject, '\', Subject, '_Ankle_Angles_', Type, '.txt']);
Elbow    = load([Subject, '\', Subject, '_Elbow_Angles_', Type, '.txt']);
Hip      = load([Subject, '\', Subject, '_Hip_Angles_', Type, '.txt']);
Knee     = load([Subject, '\', Subject, '_Knee_Angles_', Type, '.txt']);
Neck     = load([Subject, '\', Subject, '_Neck_Angles_', Type, '.txt']);
Shoulder = load([Subject, '\', Subject, '_Shoulder_Angles_', Type, '.txt']);
Trunk    = load([Subject, '\', Subject, '_Trunk_Angles_', Type, '.txt']);

% note same time vector is the first column of all data sets
% number of trials depends on trial type:
% BdLgRch = FdLgRch = 7 for P3
% bwdSHRT = fwdSHRT = 5 for P3
% bwdLONG = fwdLONG = 5 for P3

% We can take the time indexes from any set...
time = Ankle(:,1);

% Goddamn it program flow control is annoying in Matlab...
include = '';
leg = 'legend(';
for i=Show,
    include = [include eval(['Order.' i]) '(:,' Trial '+1) '];
    leg = [leg '''' eval(['Order.' i]) ''', '];
end
in = eval(['[' include ']']);
leg = [leg(1:size(leg,2)-2) ');'];

if Plot
    screen_size = get(0, 'ScreenSize');
    % Syntax for position is [xstart, ystart, width, height]. For some reason, it still overshoots...
    figure('Name', ['SUBJECT: ', Subject, ' TRIAL: ', Trial, ' TYPE: ', Type], 'NumberTitle', 'off', 'Position', [4 screen_size(4)/3-75 2*screen_size(3)/3 2*screen_size(4)/3]);

    subplot(2,1,1);
    plot(time, Platform(:,eval(Trial)+1)); legend('Platform Position');
    subplot(2,1,2);
    plot(time, in);
    eval(leg);
end

if IDSystem
    % Create an iddata structure. Format is (output, input, sample time)
    % This is goddamn convoluted. Take the trial+1'th row of *Platform* for
    % output, take the trial+1'th row of Order.Ankle (etc) for input.
    out  = Platform(:,eval(Trial)+1);
    name = eval(['Order.' Show(1)]);
    in   = eval([name '(:,' Trial '+1);']);
    data = iddata(out, in, 1/150);
    
    % Try dealing with the NaN's using misdata...
    data1 = misdata(data);
    
    figure('Name', ['Comparision of raw with misdata corrected for ' name], 'NumberTitle', 'off', 'Position', [550 screen_size(4)/3-75 2*screen_size(3)/3 2*screen_size(4)/3]);
    plot(data1);
end
