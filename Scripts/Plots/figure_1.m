% Define color palette
C = {[0 .0 .0],[.2 .2 .8],[1 .2 .2],...
    [.1 .7 .1],[.4 .9 .4],[.6 .6 1],...
    [1 .0 .0],[1 .4 .4],[1 .6 .6],...
    [.3 .9 .3],[.2 .2 .2],[.4 .4 1],...
    [.5 .9 .5],[.8 .8 .8],[.6 .9 .6],...
    [102 153 153]./255,[153 102 153]./255,[153 153 102]./255};

% Initialize figure
figure
hold on
box on
axis square
grid off
xlabel('Amplitude Scalar')
ylabel('Percent Correct')
set(gca, 'FontSize', 18)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')

% Initialize legend entries
legendEntries = {};

% Loop through each result in allResults
for idx = 1:length(allResults)
    % Skip iteration if Results or Type field is empty
    if isempty(allResults(idx).Results) || isempty(allResults(idx).Type)
        continue
    end
    
    % Extract the current result structure
    result = allResults(idx).Results;
    observerType = allResults(idx).Type;

    % Process target-present responses
    if settSim.discriminationCat_index == 0
        if size(settSim.amplitudeSCALARS, 2) == 1
            indcs = 3:2 + size(settSim.subCat_index, 2);
            dims = repmat({':'}, 1, ndims(result.htmatrix));
            htrates = sum(result.htmatrix(dims{:}), indcs);
        else
            indcs = 3:2 + size(settSim.subCat_index, 2);
            dims = repmat({':'}, 1, ndims(result.htmatrix));
            htrates = squeeze(sum(result.htmatrix(dims{:}), indcs));
        end
    else
        if size(settSim.amplitudeSCALARS, 2) == 1
            indcs = 4:2 + size(settSim.subCat_index, 2);
            dims = repmat({':'}, 1, ndims(result.htmatrix));
            htrates = sum(result.htmatrix(dims{:}), indcs);
        else
            indcs = 4:2 + size(settSim.subCat_index, 2);
            dims = repmat({':'}, 1, ndims(result.htmatrix));
            htrates = squeeze(sum(result.htmatrix(dims{:}), indcs));
        end
    end

    % Calculate hits as a function of amplitude scalar
    [~, slices, ~] = size(htrates);
    correct_hits = zeros(1, slices);
    total_sum_Presentresponses = zeros(1, slices);

    for k = 1:slices
        slice = squeeze(htrates(:, k, :));
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

    % Process target-absent responses
    if size(settSim.amplitudeSCALARS, 2) == 1
        crjmatrix = sum(result.crjmatrix(:,:,:), [3]);
    else
        crjmatrix = squeeze(sum(result.crjmatrix(:,:,:), [3]));
    end
    correct_rejections = crjmatrix(1, :);
    total_sum_Absentresponses = sum(crjmatrix, 1);

    % Calculate percentage correct
    MS_ID_PC = ((correct_hits ./ total_sum_Presentresponses) .* (1 - settSim.absentprior) + ...
                (correct_rejections ./ total_sum_Absentresponses) .* (settSim.absentprior));

    % Plot the percentage correct for this observer
    plot(settSim.amplitudeSCALARS, MS_ID_PC, 'Color', C{idx}, 'LineWidth', 2, ...
         'Marker', 'o', 'MarkerFaceColor', C{idx}, 'MarkerEdgeColor', C{idx}, 'MarkerSize', 3);

    % Add observer type to legend entry
    legendEntries{end+1} = observerType;
end

% Customize plot appearance
legend(legendEntries, 'Location', 'best')
hold off
