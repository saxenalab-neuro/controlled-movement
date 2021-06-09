function outKinematics = readkinematics(filename)

%B = importdata(filename,' ', 14).data;
fid = fopen(filename);

% THIS IS JANK
linenum = 9;
tmp = textscan(fid,'%*s %f','HeaderLines',linenum-1);
frewind(fid)

columns = tmp{1,1}(1);
rows = tmp{1,1}(2);
% END JANK

% Create format specifier
format = '';
for tmp = 1:columns
    format = sprintf(format, '%f');
    if (tmp ~= columns)
        format = strcat(format, '\t'); % add a tab
    end
end

outKinematics = cell2mat(textscan(fid,format,rows,'HeaderLines',14));

% close file
fclose(fid);

end


	     