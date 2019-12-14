function [vectors,values] = EigenVV( X )
%
% [vectors,values] = EigenVV( X )
%
% The function searches for all eigenVectors and eigenValues in X
% and returns them.
%
% Input: X - The matrix to be searched.
% Output: vectors - Columns of return-value vectors.
%         values - The diagonals of an N x N matrix, with all other terms
%                   set to zero.
%

% initialize
vectors = [];
eValues = [];

[eValTemp,eVectTemp] = PM_eigen(X); % Find first set of values

while ~isnan(eValTemp) % PM_eigen will return NaN when it can't find another value
    vectors = [vectors, eVectTemp]; % Add the new vector
    eValues = [eValues eValTemp]; % Add the new value to a matrix
    X = Eigen_Deflate(X, eValTemp, eVectTemp); % Update X
    [eValTemp,eVectTemp] = PM_eigen(X); % Find new set.
end %while

values = diag(eValues); % Transforms the matrix to the desired one along the diagonals.

return;