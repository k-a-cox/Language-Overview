%% Build input wavefunction
SimulationSteps = 4096; % Number of steps chosen to make good plots.
T = 4.0; % Period set to 4 seconds.
Dt = 3.0*T / SimulationSteps; % Dt chosen to make simulation go 3 periods.
m = 0:SimulationSteps; % indices across time
w = 2*pi/T;

% Initialize pieces.
k = 0;
out = 0;
OUT = [];

while k <= 29 %Loops through coefficients to get the series
   if k ~= 0 % K is not 0
       Xk = (5.0 / (152.0 * k^2 * pi^2)) * ...
           (-20.0 + 19 * (1 - 1i * k * 0.1 * pi) * exp(1i * k * 0.1 * pi) ...
           + (1 + 1i * k * 1.9 * pi) * exp(1i * -k * 1.9 * pi));
   else %K = 0. Zero is a special case for calculation
       Xk = 0.0375;
   end %if
   
   
   % Create the value of exp(j*t*w) for frequency (k*w) and time (m*Dt)
   Outw = exp( 1*1i*m*Dt*k*w );
   X_Component = Xk * Outw;

   % Note k = 0 is a special case
   if( k ) % which is not a conjugate pair.
        X_Component = X_Component + conj( Xk * Outw );
   end %if
   
   %Write back changes.
   out = out + X_Component;
   OUT = [ OUT; out ];
   
   k = k + 1; 
end %while

%% Plot input

figure(1)
plot(m*Dt, OUT(9,:), 'b', m*Dt, OUT(15,:), 'r', m*Dt, OUT(29,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("9", "15", "29");
title("Fourier Representation of Output");





