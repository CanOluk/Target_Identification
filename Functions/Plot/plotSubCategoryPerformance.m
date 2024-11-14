function plotSubCategoryPerformance(allResults, pNumb, pNumb2, settSim,pltType,models,levelsSHOWN)

leaveModel=setdiff([1 2 3],models);
for kl=1:size(leaveModel,2)
    allResults(leaveModel(kl)).Results=[];
    allResults(leaveModel(kl)).Type=[];
end

if pltType==1
    % Define color palette
    C = {[0 0 0], [.2 .2 .8], [1 .2 .2], [.1 .7 .1], [.4 .9 .4], [.6 .6 1], [1 0 0], [1 .4 .4], [1 .6 .6], [.3 .9 .3]};
    
    % Create a figure and save its handle
    hFig = figure('Name', 'Overall Performance All Models');
    
    % Set up the first subplot for Hit Rate
    subplot(1, 2, 1);
    hold on;
    xlabel('SubCategory');
    ylabel('Hit Rate');
    ylim([-0.1 1.1]);
    set(gca, 'FontSize', 18, 'XMinorTick', 'on', 'YMinorTick', 'on');
    box on;
    axis square;
    
    % Set up the second subplot for CRJ Rate
    subplot(1, 2, 2);
    hold on;
    xlabel('SubCategory');
    ylabel('CRJ Rate');
    ylim([-0.1 1.1]);
    set(gca, 'FontSize', 18, 'XMinorTick', 'on', 'YMinorTick', 'on');
    box on;
    axis square;
elseif pltType==2
    num_of_results=0;
    % Create logical arrays for non-empty 'Results' and 'Type'
    nonEmptyResults = arrayfun(@(x) ~isempty(x.Results), allResults);
    nonEmptyType = arrayfun(@(x) ~isempty(x.Type), allResults);
    
    % Combine the logical arrays with an AND operation
    nonEmptyIndices = nonEmptyResults & nonEmptyType;
    
    % Count the number of true values
    nonEmptyCount = sum(nonEmptyIndices);
end


for idx = 1:length(allResults)
    if isempty(allResults(idx).Results) || isempty(allResults(idx).Type)
        continue
    end
    % Extract the current result structure and observer type
    resultsStrctID = allResults(idx).Results;
    observerType = allResults(idx).Type;
    
    % Average the target-present responses across subcategories
    if settSim.discriminationCat_index == 0
        indcs = [3:2 + size(settSim.subCat_index, 2)];
        indcs((settSim.subCat_index == pNumb2)) = [];
        dims = repmat({':'}, 1, ndims(resultsStrctID.htmatrix));
        dims{2} = pNumb;
        htrates = squeeze(sum(resultsStrctID.htmatrix(dims{:}), indcs));
    else
        indcs = [4:2 + size(settSim.subCat_index, 2)];
        indcs(find(settSim.subCat_index == pNumb2) - 1) = [];
        dims = repmat({':'}, 1, ndims(resultsStrctID.htmatrix));
        dims{2} = pNumb;
        htrates = squeeze(sum(resultsStrctID.htmatrix(dims{:}), indcs));
    end
    
    % Calculate hits as a function of amplitude scalar
    if size(htrates,3)==1
        [~, slices] = size(htrates);
    else
        [~, ~, slices] = size(htrates);
    end
    correct_hits = zeros(1, slices);
    total_sum_Presentresponses = zeros(1, slices);
    
    for k = 1:slices
        if size(htrates,3)==1
            slice = squeeze(htrates(:,k));
        else
            slice = squeeze(htrates(:,:,k));
        end
        if size(slice, 2) > 1
            shifted_diag = diag(slice(2:end, :));
            sum_selected = sum(shifted_diag);
        else
            sum_selected = sum(slice(2, 1));
        end
        total_sum = sum(slice(:));
        correct_hits(k) = sum_selected;
        total_sum_Presentresponses(k) = total_sum;
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
    hitrates = correct_hits ./ total_sum_Presentresponses;
    crjrates = correct_rejections ./ total_sum_Absentresponses;
    
    % Determine the levels
    if pNumb2 == -2
        levels = settSim.absentnCat_levels;
        levelsUNSORTED=1:size(levels,2);

    else
        if settSim.discriminationCat_index == 0
            levels =unique(settSim.subCat_levelMAT{1}(:,find(settSim.subCat_index == pNumb2)))';
            levelsUNSORTED=1:size(levels,2);
 
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
    
    if pltType==1
        %%
        % Define color palette
        C = {[0 .0 .0], [.2 .2 .8], [1 .2 .2], [.1 .7 .1], [.4 .9 .4], [.6 .6 1], [1 .0 .0], [1 .4 .4], [1 .6 .6], [.3 .9 .3]};
        % Create a figure with two subplots for combined performance plots
        figure(hFig)
        % Plot on the same figure for hit rates
        subplot(1, 2, 1)
        plot(levels, hitrates(levelsUNSORTED), 'LineWidth', 2, 'Marker', 'o', ...
            'DisplayName', observerType, ...
            'MarkerFaceColor', C{mod(idx-1, length(C)) + 1}, ...
            'MarkerEdgeColor', C{mod(idx-1, length(C)) + 1},...
            'Color', C{mod(idx-1, length(C)) + 1});
        
        % Set custom x-ticks based on levelsUNSORTED for the hit rates subplot
        xticks(levels)  % Set x-ticks to be the values in `levels`
        xticklabels(levelsUNSORTED)  % Label x-ticks with `levelsUNSORTED`
        ax1 = gca;
        ax1.XAxis.FontSize = 4;  % Make x-axis font size extremely small for this subplot only
        
        % Plot on the same figure for CRJ rates
        if size(crjrates,2)==1
            subplot(1, 2, 2)
            plot(levels, crjrates, 'LineWidth', 2, 'Marker', 'o', ...
                'DisplayName', observerType, ...
                'MarkerFaceColor', C{mod(idx-1, length(C)) + 1}, ...
                'MarkerEdgeColor', C{mod(idx-1, length(C)) + 1}, ...
                'Color', C{mod(idx-1, length(C)) + 1});
            % Set custom x-ticks based on levelsUNSORTED for the hit rates subplot
            xticks(levels)  % Set x-ticks to be the values in `levels`
            xticklabels(levelsUNSORTED)  % Label x-ticks with `levelsUNSORTED`
            ax1 = gca;
            ax1.XAxis.FontSize = 4;  % Make x-axis font size extremely small for this subplot only
            % Add legends to both subplots
            subplot(1, 2, 1)
            legend('show', 'Location', 'best')
        else
            subplot(1, 2, 2)
            plot(levels, crjrates(levelsUNSORTED), 'LineWidth', 2, 'Marker', 'o', ...
                'DisplayName', observerType, ...
                'MarkerFaceColor', C{mod(idx-1, length(C)) + 1}, ...
                'MarkerEdgeColor', C{mod(idx-1, length(C)) + 1}, ...
                'Color', C{mod(idx-1, length(C)) + 1});
            % Set custom x-ticks based on levelsUNSORTED for the hit rates subplot
            xticks(levels)  % Set x-ticks to be the values in `levels`
            xticklabels(levelsUNSORTED)  % Label x-ticks with `levelsUNSORTED`
            ax1 = gca;
            ax1.XAxis.FontSize = 4;  % Make x-axis font size extremely small for this subplot only
            % Add legends to both subplots
            subplot(1, 2, 1)
            legend('show', 'Location', 'best')

        end
        
        
        
        
    elseif pltType==2
        %%
        % Plot confusion matrices for each level
        
        num_of_results=num_of_results+1;
        for level = 1:size(levels, 2)
            if any(ismember(levelsSHOWN,level))
                if num_of_results==1
                    fi_handles{level} = figure;  % Create a new figure and store the handle
                    set(fi_handles{level}, 'Name', ['SubCategoryLevel: ', num2str(levels(level))]);  % Set the figure name
                    
                else
                    figure(fi_handles{level})
                end
                if size(htrates,3)==1
                    htmatrixR = htrates(:,  level) ./ sum(htrates(:,  level));
                else
                    htmatrixR = htrates(:, :, level) ./ sum(htrates(:, :, level));
                end
                if pNumb2 == -2
                    crjmatrixR = crjmatrix(:, level) ./ sum(crjmatrix(:, level));
                else
                    crjmatrixR = crjmatrix ./ sum(crjmatrix);
                end
                
                % Plot each confusion matrix on a grid
                subplot(1,nonEmptyCount,num_of_results)
                imagesc([crjmatrixR htmatrixR])
                axis square
                colormap gray
                caxis([0 1])
                colorbar
                
                % Set x-ticks and y-ticks based on the number of columns in the matrix
                numTicks = size([crjmatrixR, htmatrixR], 2);
                xticks(1:numTicks);
                yticks(1:numTicks);
                
                % Create tick labels with 'Absent' as the first label and the rest from `levels`
                tickLabels = [{'Absent'}, arrayfun(@num2str, settSim.discriminationCat_levels(1:numTicks-1), 'UniformOutput', false)];
                
                % Set the tick labels for both x and y axes
                xticklabels(tickLabels);
                yticklabels(tickLabels);
                
                % Label axes and set the title
                xlabel('Presented Image');
                ylabel('Response');
                title(['Model: ', observerType]);
                
            end
        end
        
    end
    
end
end
