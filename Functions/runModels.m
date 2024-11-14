function allResults = runModels(varEXP, settSim)
    allResults = struct(); % Initialize the structure to store results
    infdebug=0; % make this one if you want to test for inf.

    if any(ismember(settSim.models, 1)) % Check if the ideal observer model should be run
        % Simulate the ideal observer
        [ID_D_TPT, ID_D_TAT] = simulatetheIdealObserver(varEXP, settSim, infdebug);
        toc % Display elapsed time
        % Analyze and store the results for the ideal observer
        resultsStrctID = analyzeResult(varEXP, settSim, ID_D_TPT, ID_D_TAT);
        allResults(1).Type = 'IdealObserver';
        allResults(1).Results = resultsStrctID;
    end

    if any(ismember(settSim.models, 2)) % Check if the likelihood maximization observer model should be run
        % Simulate the likelihood maximization observer
        [NN_D_TPT, NN_D_TAT] = simulatetheNNMAXObserver(varEXP, settSim);
        % Analyze and store the results for the likelihood maximization observer
        resultsStrctLMAX = analyzeResult(varEXP, settSim, NN_D_TPT, NN_D_TAT);
        allResults(2).Type = 'NNMAXObserver';
        allResults(2).Results = resultsStrctLMAX;
    end

    if any(ismember(settSim.models, 3)) % Check if the normalized maximum observer model should be run
        % Simulate the normalized maximum observer
        [SNN_D_TPT, SNN_D_TAT] = simulatetheSNNMAXObserver(varEXP, settSim);
        % Analyze and store the results for the normalized maximum observer
        resultsStrctNMAX = analyzeResult(varEXP, settSim, SNN_D_TPT, SNN_D_TAT);
        allResults(3).Type = 'SNNMAXObserver';
        allResults(3).Results = resultsStrctNMAX;
    end

end
