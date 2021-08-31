% create some dummy data
time = rand(20,1);                                % irregular sampled measurements
input = sin(2*pi*time);                           % some input signal
output = cos(2*pi*time);                          % some output signal

% define new time vector and interpolate input and output data
Ts = 0.01;                                        % new sampling time in seconds
newTime = min(time) : Ts : max(time);             % new time vector
inputInterp = interp1(time, input, newTime);      % interpolated  input data
outputInterp = interp1(time, output, newTime);    % interpolated  output data

% lets see what just happend
figure
plot(time,input,'o'), hold on
plot(time,output,'ro');

plot(newTime, inputInterp, 'x')
plot(newTime, outputInterp, 'rx')

legend({'Original Input', 'Original Output', 'Interpolated Input', 'Interpolated Output'})