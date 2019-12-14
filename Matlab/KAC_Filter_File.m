%--------------------------------------------------------------------------
% File:         KAC_Filter_File.m
% Description:  
%
%               KAC_Filter_File(inputFile, filtType, fc)
%
%               The function loads data (time,x-values) from a file, loads
%               either a lowpass or highpass filter into h depending on a
%               provided corner frequency, and then convolves them and
%               plots all 3 figures in separate graphs.
%
%               Input: inputFile - File containing 2 columns of data: 
%                               (time/value pairs)
%                      filtType - 1 for Highpass, 0 for Lowpass
%                      fc - corner frequency
%
% Author:       Kaleb Cox, kacox@ksu.edu,
%               (c)2018, Kansas State University. All rights reserved.
% Date:         1 October 2018
% Platform:     MATLAB R2018a (Version 9.4.0.813654), Windows 10 Enterprise
% Toolboxes:    N/A
% Revisions:    N/A
%--------------------------------------------------------------------------

function KAC_Filter_File(inputFile, filtType, fc)
%% Extract the possible information from the file
file = load(inputFile);
t = file(:,1)';
x = file(:,2)';
dTau = t(2)-t(1);

%% Build h (unit impulse response)
RC = 1/(2*pi*fc);
if(filtType == 1) %High pass
    t_h = 0:dTau:RC*5.5; 
    filtName = "High pass";
    h = (-2/RC + t_h / RC^2) .* exp(-t_h/RC);
    h(1) = h(1) + 1/dTau;
    
else %Low pass
    t_h = 0:dTau:RC*8; 
    filtName = "Low pass";
    h = (t_h/RC^2) .* exp(-t_h/RC);

end

%% Find convolution
y = physConv_KAC(x,h,dTau);
t_y = 0:dTau:dTau*(length(y)-1);

%% Plot
figure()
%Input vs time
subplot(311)
plot(t,x)
grid
xlabel("Time (sec)")
ylabel("Input value")
title("Input vs Time for File, " + inputFile + ", with step size " + dTau + " seconds")

%Unit impulse vs time
subplot(312)
plot(t_h, h)
grid
xlabel("Time (sec)")
ylabel("Unit Impulse Response")
title("Unit Impulse vs Time for " + filtName + " filter with corner frequency " + fc + "Hz")

%Output vs time
subplot(313)
plot(t_y,y)
grid
xlabel("Time (sec)")
ylabel("Output Response")
title("Output of the convolution of the above graphs")



