%% Load variables
load("StatsData.mat");
StatsDataTurned = StatsData';

%% Mean and Variance of first 49 terms of each row

%Use the built in functions to find the mean and std of each row
mean49 = mean( StatsDataTurned(1:49,:) );
std49 = std( StatsDataTurned(1:49,:) );

%Go one standard deviation down and up for the 90% confidence range
CI49(1:5, 1) = mean49 - 1.65*(std49/7);
CI49(:, 2) = mean49 + 1.65*(std49/7);

%% Histograms
for i = 1:5
    % Create Histogram and PDF using sqrt( length ) bins.    
    [ countsSqrt, centersSqrt] = hist(StatsDataTurned(:,i),floor(sqrt( max(size(StatsDataTurned(:,i))) )));
    % Convert counts to Probability estimates    
    countsSqrt = countsSqrt/max(size(StatsDataTurned(:,i)));

    %Full row
    Mean = mean(StatsDataTurned(:,i));
    STD = std(StatsDataTurned(:,i));

    %Finds the PDF 
    PdfSqrt = ((centersSqrt(2)-centersSqrt(1))/(sqrt( 2 * pi ) * STD )) * ...
         exp( - (centersSqrt - Mean).^2 / (2 * STD^2));
    
    % plot results  
    figure(i);    
    bar( centersSqrt, countsSqrt );
    hold on
    plot( centersSqrt, PdfSqrt, 'r-' );
    title( ['Histogram and PDF"s of Row ' int2str(i)]);
    xlabel( ['Row ' int2str(i)] );
    ylabel( 'Probabilities' );
    legend( 'Histogram', 'PDF');
    
    %Save important terms to reuse later.
    meanMast(i) = Mean;
    stdMast(i) = STD;
    countsSqrtMast(i,:) = countsSqrt;
    PdfSqrtMast(i,:) = PdfSqrt;
    
end %for

%% Part C for full data.

Std = zeros(5,2500); %preallocate

%Calculate the mean and variance of each segment
for i = 1:2500 %This many sets of 49 terms.
    Mean(1:5,i) = mean(StatsDataTurned( ((i*49 - 48) : i*49) , : ));
    Std(1:5,i) = std(StatsDataTurned((i*49 - 48) : i*49 , :));
end %For

MeanFull = mean(Mean'); %Set of the 5 means
StdFull = std(Mean'); %Set of the 5 STDs

%% Part D

%Finds Mean and STD per row.
Means = mean(StatsDataTurned)';
Stds = std(StatsDataTurned)';

%Initialize
Hits = zeros(5,1);

for i = 1:5 %Isolate Rows
    for j = 1:2500 %Isolate each set of 49 terms
        if(Mean(i,j) >= CI49(i,1) ... %If mean is above the lower CI
                && Mean(i,j) <= CI49(i,2)) %and mean is below upper CI
            Hits(i,1) = Hits(i,1) + 1; % add one to the in range tracker.
        end %if
    end %inner for
end %outer for

%% Part e

%Calculates the difference, then the square, then sums each column up.
SSD = sum((countsSqrtMast - PdfSqrtMast) .^ 2,2);
 