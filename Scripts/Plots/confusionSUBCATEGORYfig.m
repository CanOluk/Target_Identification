leaveModel=setdiff([1 2 3],modelsPLOT);
for kl=1:size(leaveModel,2)
    allResults(leaveModel(kl)).Results=[];
    allResults(leaveModel(kl)).Type=[];
end

num_of_results=0;
% Create logical arrays for non-empty 'Results' and 'Type'
nonEmptyResults = arrayfun(@(x) ~isempty(x.Results), allResults);
nonEmptyType = arrayfun(@(x) ~isempty(x.Type), allResults);

% Combine the logical arrays with an AND operation
nonEmptyIndices = nonEmptyResults & nonEmptyType;

% Count the number of true values
nonEmptyCount = sum(nonEmptyIndices);

% Loop over each result in allResults
for idx = 1:length(allResults)
    % Skip iteration if Results or Type field is empty
    if isempty(allResults(idx).Results) || isempty(allResults(idx).Type)
        continue
    end
    
    % Extract the current result structure and observer type
    resultsStrctID = allResults(idx).Results;
    observerType = allResults(idx).Type;
    
    
    
    
    % Average the target-present responses across subcategories
    if settSim.discriminationCat_index == 0
        indcs = [2:2 + size(settSim.subCat_index, 2)];
        indcs((settSim.subCat_index == pNumb2)) = [];
        dims = repmat({':'}, 1, ndims(resultsStrctID.htmatrix));
        dims{2} = pNumb;
        htrates = squeeze(sum(resultsStrctID.htmatrix(dims{:}), indcs));
    else
        indcs = [3:2 + size(settSim.subCat_index, 2)];
        indcs(find(settSim.subCat_index == pNumb2) ) = [];
        dims = repmat({':'}, 1, ndims(resultsStrctID.htmatrix));
        dims{2} = pNumb;
        htrates = squeeze(sum(resultsStrctID.htmatrix(dims{:}), indcs));
    end
    
    % Process the absent responses
    if pNumb2 == -2
        crjmatrix = squeeze(resultsStrctID.crjmatrix(:, pNumb, :));
    else
        crjmatrix = squeeze(sum(resultsStrctID.crjmatrix(:, pNumb, :), [3]));
    end
    correct_rejections = crjmatrix(1, :);
    total_sum_Absentresponses = sum(crjmatrix, 1);
    
    % Calculate hit and correct rejection rates
    hitrates = htrates ./ sum(htrates);
    crjrates = crjmatrix ./ sum(crjmatrix);
    
    % Determine the levels
    if pNumb2 == -2
        levels = settSim.absentnCat_levels;
        levelsORDER=1:size(levels,2);
    else
        if settSim.discriminationCat_index == 0
            levels =unique(settSim.subCat_levelMAT{1}(:,find(settSim.subCat_index == pNumb2)))';
            levelsORDER=1:size(levels,2);
        else
            for tk=1:size(settSim.subCat_levelMAT,2)
                levelsTEMP{tk} =unique(settSim.subCat_levelMAT{tk}(:,find(settSim.subCat_index == pNumb2)));
            end
            levelsUNSORTED=cell2mat(levelsTEMP(:));
            levelsUNSORTED=levelsUNSORTED';
            levelsUNSORTED = unique(levelsUNSORTED, 'stable');
            [levels levelsORDER]=sort(levelsUNSORTED);
        end
    end
    
    hitrates=hitrates(:,levelsUNSORTED);
    
    % Plot each confusion matrix on a grid
    subplot(1,nonEmptyCount,idx)
    imagesc([crjrates hitrates])
    axis square
    colormap gray
    caxis([0 1])
    colorbar
    
    % Set x-ticks and y-ticks based on the number of columns in the matrix
    numTicksx = size([crjrates, hitrates], 2);
    numTicksy = size([crjrates, hitrates], 1);
    xticks(1:numTicksx);
    yticks(1:numTicksy);
    
    % Create tick labels with 'Absent' as the first label and the rest from `levels`
    tickLabelsX = [{'Absent'}, arrayfun(@num2str, levelsUNSORTED(1:numTicksx-1), 'UniformOutput', false)];
    
    
    % Create tick labels with 'Absent' as the first label and the rest from `levels`
    tickLabelsY = [{'Absent'}, arrayfun(@num2str, settSim.discriminationCat_levels(1:numTicksy-1), 'UniformOutput', false)];
    
    
    % Set the tick labels for both x and y axes
    xticklabels(tickLabelsX);
    ax1 = gca;
    ax1.XAxis.FontSize = 4;  % Make x-axis font size extremely small for this subplot only
    yticklabels(tickLabelsY);
    
    % Label axes and set the title
    xlabel('Presented Image');
    ylabel('Response');
    title(['Model: ', observerType]);
    
    
    
    
    
    
    
    
end