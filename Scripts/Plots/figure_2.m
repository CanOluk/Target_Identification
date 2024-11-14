% Loop over each result in allResults
for idx = 1:length(allResults)
    % Skip iteration if Results or Type field is empty
    if isempty(allResults(idx).Results) || isempty(allResults(idx).Type)
        continue
    end
    
    % Extract the current result structure and observer type
    resultsStrctID = allResults(idx).Results;
    observerType = allResults(idx).Type;

    % Define the GIF filename for this result based on observer type or index
    currentPath=pwd;
    gif_filename = fullfile(fullfile(currentPath, 'Results'), sprintf('confusion_results_%s.gif', observerType));


    % Total number of trials of each target category
    if settSim.discriminationCat_index == 0
        counts_present = size(varEXP.TRIALS_P, 1);
        counts_absent = size(varEXP.TRIALS_A, 1);
    else
        value_range = settSim.discriminationCat_levels;
        counts_present = histcounts(varEXP.TRIALS_P(:, 1), [value_range, max(value_range) + 1]);
        value_range = settSim.absentnCat_levels;
        counts_absent = histcounts(varEXP.TRIALS_A(:, 1), [value_range, max(value_range) + 1]);
    end

    % Determine indices for open figures: beginning, middle, and end (if more than 3 levels)
   if exist('open_indices','var')
   else
    if size(settSim.amplitudeSCALARS, 2) > 3
        open_indices = [2, ceil(size(settSim.amplitudeSCALARS, 2) / 2), size(settSim.amplitudeSCALARS, 2) - 1];
    else
        open_indices = 1:size(settSim.amplitudeSCALARS, 2);
    end
   end

    % Loop over each amplitude scalar level to create confusion matrices
    for pNumb2 = 1:size(settSim.amplitudeSCALARS, 2)
        % Calculate hit rates based on target-present/absent categories
        if settSim.discriminationCat_index == 0
            indcs = 3:2 + size(settSim.subCat_index, 2);
        else
            indcs = 4:2 + size(settSim.subCat_index, 2);
        end

        % Generate indexing cell array with `:` for each dimension
        dims = repmat({':'}, 1, ndims(resultsStrctID.htmatrix));
        dims{2} = pNumb2;  % Set pNumb to always be in the second dimension

        % Apply indexing with the dynamically created dims array
        htrates = squeeze(sum(resultsStrctID.htmatrix(dims{:}), indcs)) ./ counts_present;
        
        % Calculate correct rejection matrix
        crjmatrix = squeeze(sum(resultsStrctID.crjmatrix(:, pNumb2, :), [3])) ./ sum(counts_absent);

        % Create the figure for the current frame
        figure
        imagesc([crjmatrix htrates])
        axis square
        colormap gray
        caxis([0 1])
        colorbar

        % Set x-ticks and y-ticks based on the number of columns in the matrix
        numTicks = size([crjmatrix, htrates], 2);
        xticks(1:numTicks);
        yticks(1:numTicks);

        % Create tick labels with 'Absent' as the first label and the rest from `levels`
        tickLabels = [{'Absent'}, arrayfun(@num2str, settSim.discriminationCat_levels(1:numTicks-1), 'UniformOutput', false)];
        
        % Set the tick labels for both x and y axes
        xticklabels(tickLabels);
        yticklabels(tickLabels);
        xlabel('Presented Image')
        ylabel('Response')

        % Set the title with observer type and amplitude scalar
        title([observerType, ' - Amplitude Scalar: ', num2str(settSim.amplitudeSCALARS(pNumb2))]);

        % Capture the plot as an image for GIF
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);

        % Write to the GIF file for this observer type
        if pNumb2 == 1
            imwrite(imind, cm, gif_filename, 'gif', 'Loopcount', inf, 'DelayTime', 1);
        else
            imwrite(imind, cm, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1);
        end

        % Close the figure if not in the open_indices (to keep only three open)
        if ~ismember(pNumb2, open_indices)
            close(gcf);
        end
    end
end
