function  [excitations]  = readsinglecontrol(time_index)


% Open controls xml file
controlsfile = "ComputedMuscleControl/Results/cmc_output_controls.xml";
controls = xml2struct(controlsfile);



nummuscles = size(controls.OpenSimDocument.ControlSet.objects);

excitations = zeros(1,nummuscles);

t = controls.OpenSimDocument.ControlSet.objects.ControlLinear{1,1}.x_nodes.ControlLinearNode{1,time_index}.value.Text;


for muscle_index = 1:nummuscles
    excitations(1,time_index) = controls.OpenSimDocument.ControlSet.objects.ControlLinear{1,muscle_index}.x_nodes.ControlLinearNode{1,t_index}.value.Text;
end

end