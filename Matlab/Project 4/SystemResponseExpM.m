function [t,y] = SystemResponseExpM( A, b, dt, Vi )
%
% y = SystemResponseExpM( A, b, dt, Vi );
%
% This function will generate the response for the SV matrix, using
% Exponential of A, and the input Vi.
% Input: A - System State Matrix
%        b - System Input Matrix
%        dt - time step
%        Vi - Matrix of inputs, with each column representing
%             a point in time.
% Output: y - Matrix with each column representing the state of the system
%             at a point in time.

% Setup for building output
[n,m] = size(A);
[nb,mb] = size(b);
[ni,mi] = size(Vi);
y = [];
t = [];
% test for A not square
if n ~= m
    return; % if not square return y as empty.
end % of square matrix test.

% test of A and b matching.
if nb ~= n
    return;
end % of A and b match test.

% test of Vi and b matching.
if mb ~= ni
    return;
end % of Vi and b match test.

t = zeros(1,mi);
y = zeros(n,mi);

% Compute step matrix.
Adt = expm( A * dt );  % e^(A*dt)

% Initial Conditions.
x = zeros(n,1); % all state variables start at zero.

% Compute step vector
bdt = b * dt;  % Input vector.

% Loop until time equals TimeInterval.
for k = 1:mi
    x = Adt * x + bdt*Vi(:,k);   % State Step.
    y(:,k) = x;     % Save time and state variables into y
    t(k) = k*dt;
end % of loop through TimeInterval.
