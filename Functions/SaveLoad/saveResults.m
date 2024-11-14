function saveResults(allResults, settSim, TRIALS_A,TRIALS_P, folderName)
% Saves either the combined struct array and settSim settings or the target data in the specified folder based on the 'choice' parameter
targetFolder = fullfile(pwd, folderName);

% Check if the folder exists; if not, create it
if ~isfolder(targetFolder)
    mkdir(targetFolder);
end

% Construct file path for allResults, settSim, varEXP
filePath = fullfile(targetFolder, strcat(settSim.filename, '.mat'));
varEXP.TRIALS_A=TRIALS_A;
varEXP.TRIALS_P=TRIALS_P;
% Save allResults, settSim, varEXP
save(filePath, 'allResults', 'settSim', 'varEXP', '-v7.3');
end
