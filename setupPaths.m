function setupPaths(varargin)
    % Adds paths to 'Scripts' and 'Functions' directories and all their subfolders
    currentPath = pwd;
    addpath(genpath(fullfile(currentPath, 'Scripts')));
    addpath(genpath(fullfile(currentPath, 'Functions')));
    
    % Loop through each optional path provided and add it with all subfolders
    for i = 1:length(varargin)
        optionalPath = varargin{i};
        if ~isempty(optionalPath)
            addpath(genpath(fullfile(currentPath, optionalPath)));
        end
    end
end
