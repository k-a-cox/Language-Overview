%% Load Files
load("StatsData.mat");
W = StatsData(1,:)';
X = StatsData(2,:)';
Y = StatsData(3,:)';
Z = StatsData(4,:)';
Dep = StatsData(5,:)';

%% Linear Regression of W

%This calculates the coefficients for the system.
p_W = pinv( [ W ones( size(W) ) ] ) * Dep; 

%This calculates the CC.
R_W = ( ( Dep - mean(Dep) )' * ( W - mean(W)) ) ...
    / ( ( length(W) - 1 ) * std(Dep) * std(W) ); 

%% Linear Regression of X (Same as W)

p_X = pinv( [ X ones( size(X) ) ] ) * Dep; 

R_X = ( ( Dep - mean(Dep) )' * ( X - mean(X)) ) ...
    / ( ( length(X) - 1 ) * std(Dep) * std(X) ); 

%% Linear Regression of Y

p_Y = pinv( [ Y ones( size(Y) ) ] ) * Dep; 

R_Y = ( ( Dep - mean(Dep) )' * ( Y - mean(Y)) ) ...
    / ( ( length(Y) - 1 ) * std(Dep) * std(Y) ); 

%% Linear Regression of Z

p_Z = pinv( [ Z ones( size(Z) ) ] ) * Dep; 

R_Z = ( ( Dep - mean(Dep) )' * ( Z - mean(Z)) ) ...
    / ( ( length(Z) - 1 ) * std(Dep) * std(Z) ); 

%% Multivariate Regression (Using Y and Z)

%System to be solved
Vander = [ Y Z ones( size(Z) ) ];

%Computes parameters
Parameters = pinv(Vander)*Dep;
FittedCurve = Vander * Parameters; 

%Finding CD and correlation coefficient
St = (Dep - mean(Dep))' * (Dep - mean(Dep));
Sr = (Dep - FittedCurve)' * (Dep - FittedCurve);

CD = (St-Sr)/St;
CC = sqrt(CD);