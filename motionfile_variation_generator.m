clear;clc;



timerange = linspace(0,0.5,51);
data = linspace(0,140,numel(timerange));

for i = 1:numel(timerange)
    fprintf("%f\t%f\n", timerange(i), data(i));
end

