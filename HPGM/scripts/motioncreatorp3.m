function motioncreatorp3(datatype)


% Check if datatype is correct
if (~any(datatype == ["Testing", "Validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "Testing" or "Validation"')
end


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";


tempdir = HPGMdir + "sysid/" + datatype + "/temp/";

files = dir(fullfile(tempdir, '*.mat'));

motions = cell(1,numel(files)); % Preallocate the motions cell array


for number=1:numel(files)
    tempfilename = tempdir + files(number).name;
    motions{number} = load(tempfilename).motion;
end


% Save motion data
datafilename = HPGMdir + "sysid/" + datatype + "/" + lower(datatype) + "_motiondata.mat";
save(datafilename, 'motions')
fprintf("The motions are saved!\n");

end