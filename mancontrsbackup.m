% Set the hardcoded properties for each reserve actuator
% for i = musclecount+1:musclecount+ractuatorcount % Normalizing i to musclecount to make adding it in the last ControlLinear cells easier
%     ControlLinear{1,i}.is_model_control = ractuator.is_model_control;
%     ControlLinear{1,i}.extrapolate = ractuator.extrapolate;
%     ControlLinear{1,i}.default_min = ractuator.default_min;
%     ControlLinear{1,i}.default_max = ractuator.default_max;
%     ControlLinear{1,i}.filter_on = ractuator.filter_on;
%     ControlLinear{1,i}.use_steps = ractuator.use_steps;
%     ControlLinear{1,i}.min_nodes = ractuator.min_nodes;
%     ControlLinear{1,i}.max_nodes = ractuator.max_nodes;
%     ControlLinear{1,i}.kp = ractuator.kp;
%     ControlLinear{1,i}.kv = ractuator.kv;
%     ractuatorname = strcat(ractuatornames(1,i-musclecount), '_reserve.excitation'); % define the correct muscle name
%     ControlLinear{1,i}.Attributes.name = ractuatorname;
% end