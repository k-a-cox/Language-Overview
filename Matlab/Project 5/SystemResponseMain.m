%% 2b, IVs

timeInterval = 12;
dt = 10E-3;
J = 100E-3;
Kv = 5;
Kp = 1;
Ki = 2;
NumCoeff = [9,15,29];

for i = 1:3
    [Vout1(i,:), Vin1(i,:), time, ~, ~] = ...
    SystemResponseProj5( J, Kv, Kp, Ki, NumCoeff(i), dt, timeInterval);
end %for
%% Plots for 2b
figure(1)
plot(time, Vin1(1,:), 'b', time, Vin1(2,:), 'r', time, Vin1(3,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("9", "15", "29");
title("Fourier Representation of Input");

figure(2)
plot(time, Vout1(1,:), 'b', time, Vout1(2,:), 'r', time, Vout1(3,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("9", "15", "29");
title("Fourier Representation of Output");

%% Part 2c
Kp = [1,2,4];
Ki = [0,2,3];
Vout = [];
Vin = [];
for i = 1:3
    for j  = 1:3
        [temp1, temp2, time, ~, ~] = ...
            SystemResponseProj5( J, Kv, Kp(i), Ki(j), 9, dt, timeInterval);
        Vout = [Vout; temp1];
        Vin = [Vin; temp2];
    end
end

%% Plots for 2c

%Kp = 1
figure(3)
plot(time, Vout(1,:), 'b', time, Vout(2,:), 'r', time, Vout(3,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("Ki = 0", "Ki = 2", "Ki = 3");
title("Output with Kp = 1");

%Kp = 2
figure(4)
plot(time, Vout(4,:), 'b', time, Vout(5,:), 'r', time, Vout(6,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("Ki = 0", "Ki = 4", "Ki = 6");
title("Output with Kp = 2");

%Kp = 4
figure(5)
plot(time, Vout(7,:), 'b', time, Vout(8,:), 'r', time, Vout(9,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("Ki = 0", "Ki = 8", "Ki = 12");
title("Output with Kp = 4");

%Ki = 0*Kp
figure(6)
plot(time, Vout(1,:), 'b', time, Vout(4,:), 'r', time, Vout(7,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("Kp = 1", "Kp = 2", "Kp = 4");
title("Output with Ki = 0*Kp");

%Ki = 2*Kp
figure(7)
plot(time, Vout(2,:), 'b', time, Vout(5,:), 'r', time, Vout(8,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("Kp = 1", "Kp = 2", "Kp = 4");
title("Output with Ki = 2*Kp");

%Ki = 3*Kp
figure(8)
plot(time, Vout(3,:), 'b', time, Vout(6,:), 'r', time, Vout(9,:), 'g');
grid;
xlabel("Time (sec)");
ylabel("Voltage (V)");
legend("Kp = 1", "Kp = 2", "Kp = 4");
title("Output with Ki = 3*Kp");

%% 2e testing

for i = 1:9
    CC(i) = LinearRegression( time(75:375), Vout(i,75:375) );
end % for
CC

