function [Vout, Vin, time, FS_in,FS_out] = ...
SystemResponseProj5( J, Kv, Kp, Ki, NumCoeff, TimeStep, TimeInterval)
%
% function [out, in, time, FS_in,FS_out] = ...
% SystemResponseProj5( J, Kv, Kp, Ki, NumCoeff, TimeStep, TimeInterval)
%
% This function will generate the response for the SV matrix, using
% Exponential of A, and the input Vi.
% Input: J - Moment of inertia
%        Kv - Speed/Volt
%        Kp - Controller parameter
%        Ki - Controller parameter
%        NumCoeff - How many terms to build in the fourier series
%        TimeStep - step size
%        TimeInterval - How long to run the simulation
% Output: Vout - Output voltages (of said power TS).
%         Vin - Input voltages (of said power TS).
%         time - Total time.
%         FS_in - Fourier Series of input.
%         FS_out - Fourier Series of output.

SimulationSteps = TimeInterval/TimeStep; % Number of steps chosen to make good plots.
T = 4.0; % Period set to 4 seconds.
m = 0:SimulationSteps; % indices across time
w = 2*pi/T;
time = m * TimeStep;

% Initialize pieces.
k = 0;
in = 0;
out = 0;
FS_in = [];
FS_out = [];
%Vin = [];
%Vout = [];

while k <= NumCoeff %Loops through coefficients to get the series
   if k ~= 0 % K is not 0
       Xk = (5.0 / (152.0 * k^2 * pi^2)) * ...
           (-20.0 + 19 * (1 - 1i * k * 0.1 * pi) * exp(1i * k * 0.1 * pi) ...
           + (1 + 1i * k * 1.9 * pi) * exp(1i * -k * 1.9 * pi));
   else %K = 0. Zero is a special case for calculation
       Xk = 0.0375;
   end %if
   
   s = 1i * k * w;
   
   %Special case Ki = 0
   if Ki == 0 % Simplified transfer function
       Hk = (Kp * Kv) / (J * s^2 + s + Kp * Kv);
   else % Full transfer function
       Hk = (Kp * Kv * s + Ki * Kv) /...
           (J * s^3 + s^2 + Kp * Kv * s + Ki * Kv);
   end %if
   
   % Build forier series
   FS_in = [FS_in, Xk];
   FS_out = [FS_out, Hk];
   
   % Create the value of exp(j*t*w) for frequency (k*w) and time (m*Dt)
   Value = exp( 1*1i*m*TimeStep*k*w );
   X_Component = Xk * Value;
   H_Component = Xk * Hk * Value;

   % Note k = 0 is a special case
   if( k ) % which is not a conjugate pair.
        X_Component = X_Component + conj( Xk * Value );
        H_Component = H_Component + conj( Xk * Hk * Value );
   end %if
   
   %Write back changes.
   in = in + X_Component;
   %Vin = [ Vin; in ];
   out = out + H_Component;
   %Vout = [ Vout; out];
   
   
   k = k + 1; 
end %while
Vin = in;
Vout = out;


