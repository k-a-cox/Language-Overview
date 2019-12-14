dt = 1E-6; % step size
steps = 1000;

% Initial values
R1 = 2;
L = 1E-3;
C = 1E-6;
RL = [10, 3, 5, 20];

for i = 1:4
    % Run the model.
    [t,x,Vi] = SystemResponseProj4( R1, L, C, RL(i), dt, steps );

    % Plot
    figure(2*i-1)
    plot(t, Vi, 'r' , t, x(2,:), 'k', t, x(1,:), 'b');
    grid;
    title("VIN and VOUT and IL VS Time for Load Resistance " + int2str(RL(i)) + " Ohms" );
    xlabel("Time (secs)");
    ylabel("Voltage (V), Current (A)");
    legend("Vin", "Vout", "IL");
    
    % Zoomed Plot
    figure(2*i)
    plot(t, Vi, 'r' , t, x(2,:), 'k', t, x(1,:), 'b');
    grid;
    title("Zoomed VIN and VOUT and IL VS Time for Load Resistance " + int2str(RL(i)) + " Ohms" );
    xlabel("Time (secs)");
    ylabel("Voltage (V), Current (A)");
    legend("Vin", "Vout", "IL");
    xlim([.0000, .0002]);
    
    % RMS
    rmsLoad(i) = sum(x(2,(steps/2):end).^2 / RL(i) );
    rmsPower(i) = sum( Vi((steps/2):end) .* x(1,(steps/2):end) );
    
    % Stable frequency
    temp = 0;
    for k = (steps/2):steps
        if(Vi(k) ~= Vi(k-1)) % Change in input
            temp = temp + 1;
        end %if
    end % for
    
    freq(i) = (temp/2) / ( (steps/2) * dt );
    
    % Stable amplitude
    min = x(2, (steps/2));
    max = min;
    
    for j = (steps/2) : steps
        if ( x(2,j) > max)
            max = x(2,j);
        end % if Max
        
        if ( x(2,j) < min)
            min = x(2,j);
        end % if Min
    end % for
    amp(i) = (max / min);
end % for

Efficiency = rmsLoad ./ rmsPower;