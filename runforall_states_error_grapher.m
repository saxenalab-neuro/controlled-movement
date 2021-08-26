function [] = runforall_states_error_grapher(numfunctions, newstatesbool)

% Run Comparision Graphs
for i = 1:numfunctions
    states_error_grapher(i, newstatesbool);
end

end