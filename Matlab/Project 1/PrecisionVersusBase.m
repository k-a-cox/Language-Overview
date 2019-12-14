function [Precision] = PrecisionVersusBase( Base )
%
% [Precision] = PrecisionVersusBase( Base )
%
% This function finds the precision of a double precision
% number relative to the starting number.
%
% Input: Base - number representing the size of the number being processed
% Output: Precision - smallest change in number that can be processed

Precision = Base; % Starting guess of precision

% Loops until the precision has no effect
while( Base + Precision > Base )    
    Precision = Precision / 2.0; % Reduces size by a bit
end % while

Precision = Precision * 2; 
% Move back one bit, to where it effected the value.

return % end of function PrecisionVersusBase