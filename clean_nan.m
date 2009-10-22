function clean = clean_nan( Trial, In_data, Out_data )
% This function removes the NaN's from the *output* of the system, by
% using the ident function "misdata".

% First, we want to make a iddata object out of our data. Don't
% mess up in with out!!
in   = In_data(:, eval(Trial)+1);
out  = Out_data(:, eval(Trial)+1);
data = iddata(out, in, 1/150);

% Run the data-fixing command... let's use misdata first
clean = misdata(data);
%data1 = spline(time, in, time);
