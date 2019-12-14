%--------------------------------------------------------------------------
% File:         physConv_KAC.m
% Description:  
%
%               y = physConv_KAC(x, h, dTau)
%
%               Convolves x with h, factoring in the spacing dTau.
%
%               Input: x - Array holding samples of input signal
%                      h - Array holding samples of unit inpusle signal
%                      dTau - The spacing between consecutive samples
%               Output: y - Array holding samples of output signal
%
% Author:       Kaleb Cox, kacox@ksu.edu,
%               (c)2018, Kansas State University. All rights reserved.
% Date:         1 October 2018
% Platform:     MATLAB R2018a (Version 9.4.0.813654), Windows 10 Enterprise
% Toolboxes:    N/A
% Revisions:    N/A
%--------------------------------------------------------------------------

function y = physConv_KAC(x, h, dTau)

x = x*dTau; %Weight x.
y = x*h(1); %Initialize y.

for i = 2:1:length(h) %Expand matricies and add next step.
    y = [y 0];
    x = [0 x];
    y = y + x*h(i);
end %for

return

