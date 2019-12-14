function [evalue, evector] = PM_eigen( X )
%
% [evalue, evector] = PM_eigen( X )
%
% This function employs the power method to find the largest
% eigenValue (evalue) and eigenVector (evector) of a matrix X.
% evalue returns NaN if no eigenValue found.
%
% Input: X - matrix to extract the eigen from.
% Output: evalue - The eigenvalue
%         evector - The eigenvector
%

MaxTerms = 1000;

[n,m] = size(X); %Check size of X
% and make sure it is square.
if n ~= m % The matrix needs to be square.
    evector = [];
    return;
end %if

% Start at a random vector.
evector = rand(n,1);
evector = evector / sqrt( evector' * evector ); % normalize it

% initialize
err = 1; % err set to start loop.
k = 1;   % Count number of itterations.

while k < MaxTerms && ... % Cap itterations
      err > n*eps % Not precise enough
  V = X * evector; % Next
  V = V / sqrt( V' * V ); % normalize
  err = (V - evector)' * (V - evector); % Compute change
  
  evector = V;
  k = k + 1; % Update for next itteration
  
end %while

% if not at MaxTerms, compute eigenValue
if k < MaxTerms
    V = X * evector;
    evalue = sqrt( V' * V);
else % No eigenVector found.
    evalue = NaN;
    evector = [];
end %if

return; %Done