clear;clc;


% Load xml file
model = xml2struct('../sysid/setup/arm26.xml');


% Remove geometry

Body = model.OpenSimDocument.Model.BodySet.objects.Body;

numbodies = numel(Body);

if (numbodies > 1)
    
    for numbody=1:numel(Body)
        Mesh = Body{numbody}.attached_geometry.Mesh;

        nummeshes = numel(Mesh);

        
        if (nummeshes > 1)
            
            for nummesh=1:numel(Mesh)
                mesh = Mesh{nummesh};
                Mesh{nummesh} = rmfield(mesh, 'mesh_file');
            end
            
        else
            Mesh = rmfield(Mesh, 'mesh_file');
        end
        
        Body{numbody}.attached_geometry.Mesh = Mesh;
    end
    
end

model.OpenSimDocument.Model.BodySet.objects.Body = Body;


% Save to xml file
struct2xml(model, '../sysid/setup/test_arm26.xml');
copyfile ../sysid/setup/test_arm26.xml ../sysid/setup/test_arm26.osim