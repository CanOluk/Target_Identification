function savePreComputed(T, settng, folderName)
    % Saves either the combined struct array and settSim settings or the target data in the specified folder based on the 'choice' parameter
    targetFolder = fullfile(pwd, folderName);

    % Check if the folder exists; if not, create it
    if ~isfolder(targetFolder)
        mkdir(targetFolder);
    end

    % Save T and settings with unique filenames
    save(fullfile(targetFolder, strcat(settng.filename, '_VARS')), 'T', '-v7.3');
    save(fullfile(targetFolder, strcat(settng.filename, '_STNGS')), 'settng');
end