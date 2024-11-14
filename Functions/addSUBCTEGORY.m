function [settSim]= addSUBCTEGORY(settSim,subCat,levels,priorlevel,repeat_option)

%% Error Check for subcategory
if settSim.discriminationCat_index==subCat
    error ('Category dimension cannot be subcategory.')
elseif ismember( subCat, settSim.subCat_index)
    error ('Subcategory dimension is already in use.')
end
%% THE MAIN BODY
%% if it is visual pattern dimension
if subCat>0
    % a custom levels?
    if iscell(levels)
        % repeat for each element?
        if repeat_option
            for h=1:size(settSim.subCat_levelMAT,2)
                settSim.subCat_levelMAT{h}= [repelem(settSim.subCat_levelMAT{h},size(levels{h},2),1) repmat(levels{h}',size(settSim.subCat_levelMAT{h},1),1)];
                settSim.subCat_priorMAT{h}= [repelem(settSim.subCat_priorMAT{h},size(priorlevel{h},2),1) repmat(priorlevel{h}',size(settSim.subCat_priorMAT{h},1),1)];
            end
        else
            for h=1:size(settSim.subCat_levelMAT,2)
                settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} levels{h}'];
                settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} priorlevel{h}'];
            end
        end
        % a scalar levels?
    elseif  isscalar(levels)
        for h=1:size(settSim.subCat_levelMAT,2)
            if size(settSim.subCat_levelMAT{h},1)==0
                settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} levels];
                settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} priorlevel];
            else
                settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} repmat(levels,size(settSim.subCat_levelMAT{h},1),1)];
                settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} repmat(priorlevel,size(settSim.subCat_priorMAT{h},1),1)];
            end
        end
        % a vector levels?
    elseif isvector(levels)
        % repeat for each element?
        if repeat_option
            for h=1:size(settSim.subCat_levelMAT,2)
                settSim.subCat_levelMAT{h}= [repelem(settSim.subCat_levelMAT{h},size(levels,2),1) repmat(levels',size(settSim.subCat_levelMAT{h},1),1)];
                settSim.subCat_priorMAT{h}= [repelem(settSim.subCat_priorMAT{h},size(priorlevel,2),1) repmat(priorlevel',size(settSim.subCat_priorMAT{h},1),1)];
            end
        else
            for h=1:size(settSim.subCat_levelMAT,2)
                settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} levels'];
                settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} priorlevel'];
            end
        end
        % format levels?
    else
        error('Unexpected format of subcategory levels')
    end
end



%% if it is target amplitude or background contrast
if or(subCat==-1,subCat==-2)
    
    % a custom levels?
    if iscell(levels)
        % repeat for each element?
        if repeat_option
            for h=1:size(settSim.subCat_levelMAT,2)
                settSim.subCat_levelMAT{h}= [repelem(settSim.subCat_levelMAT{h},size(levels{h},2),1) repmat(levels{h}',size(settSim.subCat_levelMAT{h},1),1)];
                settSim.subCat_priorMAT{h}= [repelem(settSim.subCat_priorMAT{h},size(priorlevel{h},2),1) repmat(priorlevel{h}',size(settSim.subCat_priorMAT{h},1),1)];
            end
        else
            for h=1:size(settSim.subCat_levelMAT,2)
                if size(settSim.subCat_levelMAT{h},1) == size(levels{h},2)
                    settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} levels{h}'];
                    settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} priorlevel{h}'];
                elseif size(settSim.subCat_levelMAT{h},1) == 0
                    settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} levels{h}'];
                    settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} priorlevel{h}'];
                end
            end
        end
        % a scalar levels?
    elseif  isscalar(levels)
        for h=1:size(settSim.subCat_levelMAT,2)
            if size(settSim.subCat_levelMAT{h},1)==0
                settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} levels];
                settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} priorlevel];
            else
                settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} repmat(levels,size(settSim.subCat_levelMAT{h},1),1)];
                settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} repmat(priorlevel,size(settSim.subCat_priorMAT{h},1),1)];
            end
        end
        % a vector levels?
    elseif isvector(levels)
        % repeat for each element?
        if repeat_option
            for h=1:size(settSim.subCat_levelMAT,2)
                settSim.subCat_levelMAT{h}= [repelem(settSim.subCat_levelMAT{h},size(levels,2),1) repmat(levels',size(settSim.subCat_levelMAT{h},1),1)];
                settSim.subCat_priorMAT{h}= [repelem(settSim.subCat_priorMAT{h},size(priorlevel,2),1) repmat(priorlevel',size(settSim.subCat_priorMAT{h},1),1)];
            end
        else
            for h=1:size(settSim.subCat_levelMAT,2)
                
                if size(settSim.subCat_levelMAT{h},1) == size(levels,2)
                    settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} levels'];
                    settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} priorlevel'];
                elseif size(settSim.subCat_levelMAT{h},1) == 0
                    settSim.subCat_levelMAT{h}=   [settSim.subCat_levelMAT{h} levels'];
                    settSim.subCat_priorMAT{h}=   [settSim.subCat_priorMAT{h} priorlevel'];
                end
            end
        end
        % format levels?
    else
        error('Unexpected format of subcategory levels')
    end
end

%% track the index
settSim.subCat_index=[settSim.subCat_index subCat];

end