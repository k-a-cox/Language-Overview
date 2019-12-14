tic %Time for loading the .csv
load("Data01.csv");
toc

tic %Time for loading the .mat
load("Data02.mat");
toc

%Find the max relative error
MaxARE = max(max(abs(Data01-Data02)./Data02))