function [T, settng] = loadPrecomputedData(precalculationName)
    % Loads precomputed data for the experiment
    varsFile = strcat(precalculationName, '_VARS.mat');
    stngsFile = strcat(precalculationName, '_STNGS.mat');
    
    % Load variables and settings
    load(varsFile);
    settings = load(stngsFile);
    settng = settings.settng;
end
