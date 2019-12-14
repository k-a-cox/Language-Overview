function Double2CSV( x, name, permission )
%
% Double2CSV( x, name, permission );
%
% This function will append the data in the array x, to a file in a 
% CSV format based on the permission.

[n,m] = size( x ); % get size of x.
fid = fopen( name, permission); % open file
if fid ~= 0  % check for valid file open
    for h = 1:n % loop through rows
        for k = 1:m-1 % loop through columns, except for last column.            
            fprintf( fid, '%18.16g,', x(h,k) ); % write out data
        end% last column is a special case.        
        fprintf( fid, '%18.16g\n', x(h,m) ); 
        % note new line terminator.
    end% close file.    
    fclose( fid );
end

% done.
return