function [Xreduced] = Eigen_Deflate( X, eigenValue, eigenVector )
%
% [Xreduced] = Eigen_Deflate( X, eigenValue, eigenVector )
%
% This function removes an eigenvalue-vector set from a matrix
% and returns the reduced matrix.
%
% Input: X - The matrix to be reduced
%        eigenValue - The eigenValue to remove
%        eigenVector - The eigenVector to remove
% Output: Xreduced - The reduced matrix
%

Xreduced = X - eigenValue * ( eigenVector * eigenVector' );

return;