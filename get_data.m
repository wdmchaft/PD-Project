% This script just loads all our data for us to use at the command
% prompt
% Input: Subject -> The subject to get the data from.
%        Type    -> The type of experiment to load.
%        Level   -> T/F whether to start the outputs around 0
%        Clean   -> T/F remove any NaN's present
%        Derive  -> T/F use the acceleration as input, rather than position

% These are some example parameters we can use..

if ~exist('Subject')
  Subject = 'Pilot03';
end
if ~exist('Type')
  Type    = 'fwdSHRT';
end
if ~exist('Level')
  Level   = 1;
end
if ~exist('Clean')
  Clean   = 1;
end
if ~exist('Derive')
  Derive  = 1;
end
fields = {'Platform'; 'Ankle'; 'Elbow'; 'Hip'; 'Knee'; 'Neck'; ...
          'Shoulder'; 'Trunk'};
% Load the data
% the first one is messy because it's not an 'angle'
Joints.Platform = load([Subject, '\', Subject, '_Platform_Position_', Type, '.txt']);
for i = 2:length(fields)
  Joints.(fields{i}) = load([Subject '\' Subject '_' fields{i} '_Angles_' Type '.txt']);
end

if Level
  % *Level* the first 1/2 second for all output - not detrend, not mean!
  % For all trials on a *given* *joint*, we want the first
  % half-second of data to have the *same* *average*. This is
  % *better* than just removing the mean, as it makes for better
  % matching when all of the trials start at the same place.

  % Ignore the Platform for now, just do the angles (output)
  % fields = fieldnames(Joints); don't need this...
  for i = 2:length(fields)
    name = fields{i};
    a    = Joints.(name);% a is the joint in question
    
    % Zero input should yeild zero output. As the input happens at
    % time 0, we need to centre all of the output *prior* to time 0
    % about the 0 axis.
    % We shouldn't have to worry about it having NaN's, which only
    % crop up later
    av = mean(a(1:75,2));
    
    Joints.(name)(:,2) = a(:,2) - av;   % Average the first field
    off = mean(Joints.(name)(1:75, 2)); % The average of the first 1/2s

    % Make the first 1/2 second of every *other* trial line up with
    % the first 1/2 second of the *first* trial
    for j = 3:size(a, 2)
      % How far we have to correct this trial to make the first
      % 1/2 second line up
      av = off - mean(a(1:75, j));
      % Add this value to each trial.
      Joints.(name)(:,j) = a(:,j) + av;
    end
  end
end

if Clean || Derive
  % Deriving things shrinks the dataset
  Joints.PlatformAccel = zeros(size(Joints.Platform) - [2 0]);
  for i = 2:size(Joints.Platform, 2)
    if Clean
      % Now, de-mean the platform data, too
      Joints.Platform(:,i) = Joints.Platform(:,i) - mean(Joints.Platform(:,i));
    end
    if Derive
      d2 = diff(Joints.Platform(:,i), 2);
      % Now we have to filter the results, because this currently
      % looks horrible! Pass through a wide averager three tipes.
      Joints.PlatformAccel(:,i) = smooth(smooth(smooth(d2)));
    end
  end
end

% Ok, let's stick all of the data into a series of iddata structures
clear Data;
for trial = 2:size(Joints.Platform, 2)
  if Derive
    % We have to resize everything else, because acceleration data
    % is shorter by two data points.
    in = Joints.PlatformAccel(:,trial);
    out = [Joints.Ankle(1:end-2,trial), Joints.Elbow(1:end-2,trial), ...
           Joints.Hip(1:end-2,trial),   Joints.Knee(1:end-2,trial), ...
           Joints.Neck(1:end-2,trial),  Joints.Shoulder(1:end-2,trial), ...
           Joints.Trunk(1:end-2,trial)];
  else
    in  = Joints.Platform(:,trial);
    out = [Joints.Ankle(:,trial), Joints.Elbow(:,trial), ...
           Joints.Hip(:,trial),   Joints.Knee(:,trial), ...
           Joints.Neck(:,trial),  Joints.Shoulder(:,trial), ...
           Joints.Trunk(:,trial)];
  end
  name = ['d' num2str(trial-1)]; % The name can't be pure numeric
  Data.(name) = iddata(out, in , 1/150);
  
  % Do some more preprocessing as needed, to remove NaN's
  if Clean && isnan(Data.(name))
    Data.(name) = misdata(Data.(name));
  end
end

['Loaded Subject ''' Subject ''' Type ''' Type ''' and put all of ' ...
 'the trials inside iddata structures inside ''Data''']