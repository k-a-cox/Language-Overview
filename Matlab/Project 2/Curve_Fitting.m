load("Data02.mat");

x = Data02(1,:)'; %First row of data

y = Data02(2,:)'; %Second row of data

%Set up the vander matrix for z.
Vander = [x, x.^2, x.*y, y, y.^2, ones(200000,1)];
Dependent = Data02(3,:)'; %Third row of data

% Compute the parameters of fit
Parameters = pinv(Vander) * Dependent;
% Compute Fitted Curve
FittedCurve = Vander * Parameters;

% Compute Coefficient of Determination using
% Total variation
St = (Dependent-mean(Dependent))' * (Dependent-mean(Dependent));
% and Residual Error
Sr = (Dependent-FittedCurve)' * (Dependent-FittedCurve);
CD = (St-Sr)/St

%% Repeat previous for first variable replaced with random

Vander = [randn(200000,1), x.^2, x.*y, y, y.^2, ones(200000,1)];

Parameters = pinv(Vander) * Dependent;
FittedCurve = Vander * Parameters;

St = (Dependent-mean(Dependent))' * (Dependent-mean(Dependent));
Sr = (Dependent-FittedCurve)' * (Dependent-FittedCurve);
CD1 = (St-Sr)/St;

%% Repeat previous for second variable replaced with random

Vander = [x, randn(200000,1), x.*y, y, y.^2, ones(200000,1)];

Parameters = pinv(Vander) * Dependent;
FittedCurve = Vander * Parameters;

St = (Dependent-mean(Dependent))' * (Dependent-mean(Dependent));
Sr = (Dependent-FittedCurve)' * (Dependent-FittedCurve);
CD2 = (St-Sr)/St;

%% Repeat previous for third variable replaced with random

Vander = [x, x.^2, randn(200000,1), y, y.^2, ones(200000,1)];

Parameters = pinv(Vander) * Dependent;
FittedCurve = Vander * Parameters;

St = (Dependent-mean(Dependent))' * (Dependent-mean(Dependent));
Sr = (Dependent-FittedCurve)' * (Dependent-FittedCurve);
CD3 = (St-Sr)/St;

%% Repeat previous for forth variable replaced with random

Vander = [x, x.^2, x.*y, randn(200000,1), y.^2, ones(200000,1)];

Parameters = pinv(Vander) * Dependent;
FittedCurve = Vander * Parameters;

St = (Dependent-mean(Dependent))' * (Dependent-mean(Dependent));
Sr = (Dependent-FittedCurve)' * (Dependent-FittedCurve);
CD4 = (St-Sr)/St;

%% Repeat previous for fifth variable replaced with random

Vander = [x, x.^2, x.*y, y, randn(200000,1), ones(200000,1)];

Parameters = pinv(Vander) * Dependent;
FittedCurve = Vander * Parameters;

St = (Dependent-mean(Dependent))' * (Dependent-mean(Dependent));
Sr = (Dependent-FittedCurve)' * (Dependent-FittedCurve);
CD5 = (St-Sr)/St;

%% CDs
[CD1, CD2, CD3, CD4, CD5]

%% Repeat but with only important terms.
Vander = [x, y.^2, ones(200000,1)];

Parameters = pinv(Vander) * Dependent;
FittedCurve = Vander * Parameters;

St = (Dependent-mean(Dependent))' * (Dependent-mean(Dependent));
Sr = (Dependent-FittedCurve)' * (Dependent-FittedCurve);
CD_Small = (St-Sr)/St

