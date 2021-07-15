clear;clc;

% Screw SIMULINK, this should work better

% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model


% Remove previous entries in the opensim.log file
fid = fopen("opensim.log", 'w');
fclose(fid);


% Initialize cumulative files
initCumulativeFiles();


% Initialize the Forward Dynamics Tool
fdSetupFile = "Tools\fd_loop_setup.xml";
forwardTool = ForwardTool(fdSetupFile); % Initialize Forward Tool



target_coordinates = [130, 0];


% INITIALIZE PIDS %
PIDs = initializePIDS();


% INITIALIZE SIGNALS %
signal = receivesignal(); % TODO: MAKE "receivesignal()"
feedback = 0;
controls = zeros(1, model.numMuscles());

% Initalize time properties
ti = 0.0000;
dt = 1e-2;

% Initialize interrpution handler values
FLAG_Interruption_Pertubation = 0;

%%%% TODO: ADD DECAY FOR PERTUBATION FORCES %%%%






while true
    
    
    % INITIAL %

    %%%% MODEL RANDOM PERTUBATION %%%%
    %%% ADD PERTUBATION GENERATION 


    % CHECK FOR INTERRUPTS %
    if (FLAG_Interruption_Pertubation)
        %%% ADD external loads ot forward tool
    end

    signal = signal - feedback;

    for muscle = 1:model.numMuscles() % for each muscle in muscles
        controls(muscle) = PID(signal, muscle);
        %%%% MAYBE NEED TF HERE TO GENERATE THE NICE CURVES? %%%%
    end
    
    % EXECUTE %

    forwardtoolloopstep(forwardTool, controls, ti, dt);
    
    
    % END %
    
    
    
    ti = ti + dt; % Update time

    % Remove external load addition once exhausted
    if (externalloads == 0)
        %%% REMOVE EXTERNAL LAODS
    end

    %%%% TODO: ADD EXCEPTION AND CONTROL STATEMENTS TO ALLOW FOR PERTUBATIONS

    
    
    
end