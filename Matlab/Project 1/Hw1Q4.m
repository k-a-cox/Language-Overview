Base = 1.0; %First value

Error = zeros(3, 31); %Matrix to hold base, position, and ratio
Position = 1; %Placeholder in matrix

%Calculate precision and ratio for many values
while Base >= 1e-30
    
    Error(Position) = Base; %number
    Error(Position + 1) = PrecisionVersusBase( Base ); %precision
    Error(Position + 2) = Error(Position + 1) / Error(Position); %ratio
    
    %Increment values
    Base = Base / 10.0;
    Position = Position + 3;
    
end % while

%Opens/makes new file
fid = fopen('test.cvs', 'w');

%If file is open, write
if fid ~= 0
    %Sets headers
    fprintf(fid, 'base,' );
    fprintf(fid, 'precision,' );
    fprintf(fid, 'precision/base\n' );
    
    %close file
    fclose(fid);
end % if

Error = Error'; %Transforms from rows to columns of triples
Double2CSV( Error, 'test.cvs', 'a' ); %Uses function to convert the triples to csv format

figure(1) 
loglog(Error(:,1), Error(:,2), 'k',Error(:,1), Error(:,3), 'r');

xlabel('Base');
ylabel('Precision');
title('Base vs precision (log vs log)');
grid();

figure(2)
semilogx(Error(:,1), Error(:,3), 'r');

xlabel('Base (log)');
ylabel('Relative Precision');
title('Base vs precision/base');
grid();
