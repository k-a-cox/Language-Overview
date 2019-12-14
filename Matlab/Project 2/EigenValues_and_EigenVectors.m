load('Data02.mat'); % Load data

X = Data02 * Data02'; % Form X

[eVectors,eValues] = EigenVV(X); % Compute values

values = eig(X); % MatLab's eigenValues

condMat = cond(X); % MatLab's condition

condMe = eValues(1,1) / eValues(3,3); % picked the proper cells

err = abs(condMat - condMe) / condMat % relative error
