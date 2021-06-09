function [] = writekinematics(filename, kinematics)

infile = fopen("ComputedMuscleControl/kinematics.mot", 'r');

headerlines = 7;
buffer = '';
for tmp = 1:headerlines
    buffer = strcat(buffer, fgets(infile));
    buffer = strcat(buffer, '\n');
end


fclose(infile); % close file for writing
outfile = fopen(filename, 'w'); % open outfile for writing
fprintf(outfile, buffer); % write buffer to file
writematrix(kinematics,filename,'FileType','text','Delimiter',' ','WriteMode','append');
readmatrix(filename);
fclose(outfile);

end