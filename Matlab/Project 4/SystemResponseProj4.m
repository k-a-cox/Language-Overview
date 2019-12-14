function [t,x,Vi] = SystemResponseProj4( R1, L, C, RL, dt, steps )
%
% [t,x,Vi] = SystemResponseProj4(  R1, L, C, RL, dt, steps);
%
% This function will generate the response for the SV matrix, using
% Exponential of A, and the input Vi.
% Input: R1, L, C, RL - values for the circuit
%        dt - step size
%        steps - How many terms to go through
%               [default : 1000]
% Output: t - Matrix of time progression.
%         x - Matrix with each column representing the state of the system
%             at a point in time.
%         Vi - Matrix tracking progression of Vin.

if (nargin < 6)
    steps = 1000;
end

%d/dt x = 
A = [-R1/L, -1/L;...
       1/C, -1/(RL*C)]; % * x
   % +
B = [1/L; 0]; % * Vi

%Initalization of state variables
Vi=10;
x = [0;0];
t = 0;

%Step Matrix
Adt = expm( A * dt );
%Step Vector
bdt = B * dt;

for i = 1:steps %finds a bunch of time steps

    % Finds new IL and Vo
    x = [x, Adt * x(:, end) + bdt*Vi(end)];
    
    %Updates time
    t = [t, t(end) + dt];

    %Vin = 0 if Vo > 5V, else Vin = 10V
    if(x(2,end) > 5) 
        Vi = [Vi, 0];
    else
        Vi = [Vi, 10];
    end %if
end %for
