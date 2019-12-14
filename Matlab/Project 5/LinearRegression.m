function CC = LinearRegression( independent, dependent)
%
% function CC = LinearRegression( independent, dependent)
%
% Input:
%       independent - the independent variable
%       dependent - the dependent variable
%
% Output:
%       CC - the correlation factor
%

CC = ( (dependent' - mean(dependent))' * (independent' - mean(independent)) ) ...
    / ( (length(independent) - 1) * std(independent) * std(dependent) );