clear;clc;

controlsfile = "ComputedMuscleControl/Results/cmc_output_controls.xml";
controls = xml2struct(controlsfile);


% Function inputs
tstart = 0.10;
tend = 2;
musclenames = ["TRIlong", "TRIlat", "TRImed", "BIClong", "BICshort", "BRA"]; 
ractuatornames = ["r_shoulder_elev", "r_elbow_flex"];
%muscleexcitations = ones(11,6); % [[] [] [] [] [] []] An array of excitations for each muscle
%ractuatorexcitations = ones(11,2); % [[] []] An array of excitations for each reserve actuator


% Set the starting properties
time = tstart:0.01:tend;
[~, timecount] = size(time);
[~, musclecount] = size(musclenames);
[~, ractuatorcount] = size(ractuatornames);

[muscleexcitations, ractuatorexcitations] = createexcitations(tstart,tend); % An array of excitations for each reserve actuator

[muscleexcitationcount, musclecountetest] = size(muscleexcitations);
[ractuatorexcitationcount, ractuatorcountetest] = size(ractuatorexcitations);


% Possible input errors
if (muscleexcitationcount ~= timecount) || (ractuatorexcitationcount ~= timecount)
    fprintf("CRIT_ERR - Excitation count does not match the time interval!");
end

if (musclecountetest ~= musclecount)
    fprintf("CRIT_ERR - Muscle count does not match the given excitations!");
end

if (ractuatorcountetest ~= ractuatorcount)
    fprintf("CRIT_ERR - Reserve actuator count does not match the given excitations!");
end



% Now for all the ControlLinear muscle objects

% Set the time points for all x_nodes
ControlLinearNode = cell(1,timecount);
for i = 1:timecount
    ControlLinearNode{1,i}.t.Text = num2str(time(1,i));
end

% Hardcoded properties for each muscle
muscle.is_model_control.Text = 'true';
muscle.extrapolate.Text = 'true';
muscle.default_min.Text = '0.02';
muscle.default_max.Text = '1';
muscle.filter_on.Text = 'false';
muscle.use_steps.Text = 'true';
muscle.x_nodes.ControlLinearNode = ControlLinearNode;
muscle.min_nodes.Text = '';
muscle.max_nodes.Text = '';
muscle.kp.Text = '100';
muscle.kv.Text = '20';
%foreach: Attributes.name = '[#musclename]';


% Hardcoded properties for each reserve actuator
ractuator.is_model_control.Text = 'true';
ractuator.extrapolate.Text = 'true';
ractuator.default_min.Text = '-10000';
ractuator.default_max.Text = '10000';
ractuator.filter_on.Text = 'false';
ractuator.use_steps.Text = 'false';
ractuator.x_nodes.ControlLinearNode = ControlLinearNode;
ractuator.min_nodes.Text = '';
ractuator.max_nodes.Text = '';
ractuator.kp.Text = '100';
ractuator.kv.Text = '20';
%foreach: Attributes.name = '[#ractuatorname]';


% Set the hardcoded properties for each muscle
ControlLinear = cell(1,musclecount+ractuatorcount);
for i = 1:musclecount
    ControlLinear{1,i} = muscle;
    musclename = strcat(char(musclenames(1,i)), '.excitation'); % define the correct muscle name
    ControlLinear{1,i}.Attributes.name = musclename;
end


% Set the hardcoded properties for each reserve actuator
for i = musclecount+1:musclecount+ractuatorcount % Normalizing i to musclecount to make adding it in the last ControlLinear cells easier
    ControlLinear{1,i} = ractuator;
    ractuatorname = strcat(char(ractuatornames(1,i-musclecount)), '_reserve.excitation'); % define the correct reserve actuator name
    ControlLinear{1,i}.Attributes.name = ractuatorname;
end


% Set the excitations for each dang thing
for i = 1:musclecount
    for j = 1:timecount
        ControlLinear{1,i}.x_nodes.ControlLinearNode{1,j}.value.Text = num2str(muscleexcitations(j,i));
    end
end


% Set the hardcoded properties for each reserve actuator
for i = musclecount+1:musclecount+ractuatorcount % Normalizing i to musclecount to make adding it in the last ControlLinear cells easier
    for j = 1:timecount
        ControlLinear{1,i}.x_nodes.ControlLinearNode{1,j}.value.Text = num2str(ractuatorexcitations(j,i-musclecount));
    end
end


% Create the hollistic structure
c.OpenSimDocument.ControlSet.objects.ControlLinear = ControlLinear;
c.OpenSimDocument.Attributes.Version = '40000';
c.OpenSimDocument.ControlSet.groups.Text = '';
c.OpenSimDocument.ControlSet.Attributes.name = 'arm26';

struct2xml(c,"controls.xml");

% Amazing I wrote my own controls xml file!

