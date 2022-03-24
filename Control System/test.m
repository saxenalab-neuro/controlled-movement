clear;clc;




filestring = "input_signals/testing_101.mot";

infile = fopen(filestring, 'r');
c = textscan(infile, '%f%f%f', 'delimiter', '\n', 'HeaderLines', 14);
fclose(infile);

pos = transpose(c{3});
vel = [0 diff(pos)/0.001];
signal.t = transpose(c{1});
signal.data = [pos; vel];
signal.ti = signal.t(1);
signal.tf = signal.t(end);
signal.Ts = 0.001;

signal.data

plot(signal.t, signal.data)