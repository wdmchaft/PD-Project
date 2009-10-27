% This script just loads all our data for us to use at the command
% prompt
% Input: Subject -> The subject to get the data from.
%        Type    -> The type of experiment to load.

% These are some example parameters we can use..

if ~exist('Subject')
  Subject = 'Pilot03';
end
if ~exist('Type')
  Type    = 'fwdSHRT';
end
if ~exist('Trial')
  Trial   = 1;
end
if ~exist('Clean')
  Clean   = 0;
end
fields = {'Platform'; 'Ankle'; 'Elbow'; 'Hip'; 'Knee'; 'Neck'; ...
          'Shoulder'; 'Trunk'};
% Load the data
% the first one is messy because it's not an 'angle'
Joints.Platform = load([Subject, '\', Subject, '_Platform_Position_', Type, '.txt']);
for i = 2:length(fields)
  Joints.(fields{i}) = load([Subject '\' Subject '_' fields{i} '_Angles_' Type '.txt']);
end

if Clean
  % *Level* the first 1/2 second for all output - not detrend, not mean!
  % For all trials on a *given* *joint*, we want the first
  % half-second of data to have the *same* *average*. This is
  % *better* than just removing the mean, as it makes for better
  % matching when all of the trials start at the same place.

  % Ignore the Platform for now, just do the angles (output)
  % fields = fieldnames(Joints); don't need this...
  for i = 2:length(fields)
    a   = Joints.(fields{i});% a is the joint in question
    
    % If the first trial has a NaN in it, then use the start as the reference
    if max(isnan(a(:,2)))
      % Because hopefully the first 1/2 second won't have any NaNs
      av = mean(a(1:75,2))
    else
      av = mean(a(:,2)); % Take mean of the first trial
    end
    
    Joints.(fields{i})(:,2) = a(:,2) - av;   % Average the first field
    off = mean(Joints.(fields{i})(1:75, 2)); % The average of the first 1/2s

    % Make the first 1/2 second of every *other* trial line up with
    % the first 1/2 second of the *first* trial
    for j = 3:size(a, 2)
      % How far we have to correct this trial to make the first
      % 1/2 second line up
      av = off - mean(a(1:75, j));
      % Add this value to each trial.
      Joints.(fields{i})(:,j) = a(:,j) + av;
    end
  end
  
  % Now, de-mean the platform data, too
  for i = 2:size(Joints.Platform, 2)
    Joints.Platform(:,i) = Joints.Platform(:,i) - mean(Joints.Platform(:,i));
  end
end

% Now, create the data structure
Data_in  = Joints.Platform(:,Trial+1);
Data_out = [Joints.Ankle(:,Trial+1), Joints.Elbow(:,Trial+1), ...
            Joints.Hip(:,Trial+1),   Joints.Knee(:,Trial+1), ...
            Joints.Neck(:,Trial+1),  Joints.Shoulder(:,Trial+1), ...
            Joints.Trunk(:,Trial+1)];

Data = iddata(Data_out, Data_in, 1/150);

if Clean % Then do some preprocessing on it
  % Run it through the NaN-remover
  if isnan(Data)
    Data = misdata(Data);
  end
end

['Loaded Subject ''' Subject ''' Type ''' Type ''' and put Trial #' ...
 num2str(Trial) ' inside the iddata structure ''Data''']