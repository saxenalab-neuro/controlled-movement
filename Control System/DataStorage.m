% EXAMPLE:  GETTING DATA OUT OF THE APP
% FIRST, CREATE A SIMPLE HANDLE-CLASS OBJECT FOR STORING STUFF
% SAVE THIS AS "DataStorage.m" IN A SEPARATE FILE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIS IS A HANDLE-CLASS, JUST FOR STORING STUFF.  
% WITHIN THE MATLAB SCRIPT THAT LAUNCHES YOUR APP, CREATE AN 
% INSTANCE OF THIS HANDLE CLASS AND PASS IT INTO YOUR APP WHEN 
% YOU LAUNCH IT.    THE APP WILL STORE STUFF IN IT.
% SINCE THIS IS A HANDLE CLASS, WHEN THE APP STORES DATA IN IT, 
% IT'S MODIFYING THE *ORIGINAL* OBJECT CREATED IN YOUR SCRIPT,
% OUTSIDE OF YOUR APP.  
% WHEN THE APP IS DESTROYED, YOUR DATA STILL EXISTS IN YOUR SCRIPT.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef DataStorage < handle  %  <===== THIS LINE MAKES IT A HANDLE CLASS
    properties 
        % We can store any amount of data in this empty structure
        dataArea = struct(); 
    end
    
    methods 
        function obj = DataStorage(obj)
            return;
        end
    end
end