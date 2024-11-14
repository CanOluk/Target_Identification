function settSim = generateSubcategoryMatrix(settSim, subCat, subCats, repeat_options)
    % Initialize tables and subcategory index
    settSim.subCat_levelMAT = cell(1, size(settSim.discriminationCat_levels, 2));
    settSim.subCat_priorMAT = cell(1, size(settSim.discriminationCat_levels, 2));
    settSim.subCat_index = [];
    
    % Add the background contrast uncertainty index at the end
    subCats = [subCats settSim.absentCat_index];
    repeat_options = [repeat_options 1];
    
    % Loop through each subcategory to add to the settings
    for d = 1:length(subCats)
        subCat_ind = subCats(d);
        repeat_option = repeat_options(d);
        
        if d == length(subCats)
            % Use absent category levels and priors for the final subcategory
            level = settSim.absentnCat_levels;
            priorlevel = settSim.absentCat_priors;
        else
            % Use specified levels and priors for each subcategory
            level = subCat.levels{d};
            priorlevel = subCat.priors{d};
        end
        
        % Add subcategory to the settings
        settSim = addSUBCTEGORY(settSim, subCat_ind, level, priorlevel, repeat_option);
    end
end
