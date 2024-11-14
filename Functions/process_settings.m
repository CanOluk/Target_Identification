function [settSim]=process_settings(T,settSim)
%(i)Find the correspondence between sibcategries in precomputed dictionary:
%see the settSim.indices
%(ii) Calculates number of trials for each condition
%(iii) Generate some useful variables for further processing
% initialize

% it should be within the range.
if any(settSim.subCat_index>size(T.PROPERTIES,2))
    error('Cannot find the subcategory dimension, please see properties of visual pattern')
end


settSim.numtrialPERcond_P=[];
settSim.numtrialPERcond_A=[];
settSim.VPS=[];
ttl_sum_condtPresent=0;

% insert the category index to subcategories
if settSim.discriminationCat_index==0
else
    settSim.subCat_index=[settSim.discriminationCat_index settSim.subCat_index];
end

%% loop over the category levels (k)
for n = 1:size(settSim.discriminationCat_levels, 2)
    %% FIND THE CORRESPONDENCE OF THE SUBCATEGORIES IN THE PRE-COMPUTED VARIABLES
    
    % insert the category index to subcategories
    if settSim.discriminationCat_index==0
    else
        settSim.subCat_levelMAT{n}=[repmat(settSim.discriminationCat_levels(n),size(settSim.subCat_levelMAT{n},1),1) settSim.subCat_levelMAT{n}];
        settSim.subCat_priorMAT{n}=[repmat(settSim.discriminationCat_priors(n),size(settSim.subCat_priorMAT{n},1),1) settSim.subCat_priorMAT{n}];
    end
    
    % generate working copies
    temp_subCatTable=  settSim.subCat_levelMAT{n};
    temp_priorTable=  settSim.subCat_priorMAT{n};
    temp_copyIndex = settSim.subCat_index;
    
    % sort the visual pattern dimensions in order and find the unique rows
    [~, sortIndex]=  sort(temp_copyIndex(temp_copyIndex > 0), 'ascend');
    locIndex=find(temp_copyIndex > 0);
    [unique_rows, ~, orderREP] = unique(temp_subCatTable(:,locIndex(sortIndex)), 'rows');
    previousNumIND=size(cell2mat(settSim.VPS(:)),1);
    
    % all visual pattern properties has to be decided
    if size(T.PROPERTIES, 2) ~= size(unique_rows, 2)
        error('SizeMismatchError: T.PROPERTIES and unique_rows must have the same number of columns for row-wise comparison.');
    end
    
    % can you find all the conditions
    VPFOUND=ismember(unique_rows,T.PROPERTIES, 'rows');
    if all(VPFOUND)
    else
        error('PatternNotFoundError: The pattern cannot be found  in the dictionary.');
    end
    
    % find the dictonary index for each visual pattern.
    [~,index_A,~] = intersect(round(10^5.*T.PROPERTIES)./10^5,round(10^5.*unique_rows)./10^5,'rows');
    settSim.VPS{n}= index_A(unique(orderREP, 'stable'));
    
    % save the order of repeatitions of index (assumes that you will
    % collapse indices): cell2mat(settSim.indices(:))
    settSim.VPorder{n}= orderREP+previousNumIND;
    
    %% PRIORS AND NUMBER OF CONDITIONS
    
    % calculate the prior probability of each condition
    uniquePriors= prod(temp_priorTable,2).*(1-settSim.absentprior);

    % test the min
    if 1/min([uniquePriors])<settSim.nImage
    else
        error('You need at least %.1f trials', ceil(1/min(uniquePriors)));
    end
    
    % calculate the number of conditions in each
    temp_numbers=floor(uniquePriors.*settSim.nImage);
    ttl_sum_condtPresent=sum(temp_numbers)+ttl_sum_condtPresent;
    settSim.numtrialPERcond_P{n}=temp_numbers;
    
    %% SOME USEFUL VECTORS
    
    % 1. prior for each visual pattern
    tempsubCATs=temp_copyIndex;
    % all category indecises except zero
    if sum(temp_copyIndex==settSim.discriminationCat_index)>0
        tempsubCATs(temp_copyIndex==settSim.discriminationCat_index)=0;
    end
    % calculate the prior
    [~,aa,~]=unique(temp_subCatTable(:,tempsubCATs > 0),'rows');
    temp_priortargets=temp_priorTable(aa,tempsubCATs > 0);
    settSim.VPprior{n}=prod(temp_priortargets,2);
    
    % 2.unique amplitudes and their order
    [unAMP,aa,maskAMP]=unique(temp_subCatTable(:,temp_copyIndex == -1),'rows');
    settSim.AMPS{n}= unAMP;
    settSim.AMPorder{n}= maskAMP;
    settSim.AMPprior{n}=prod(temp_priorTable(aa,temp_copyIndex == -1),2);
    
    % 3. unique contrast and their order
    [unCT,~,maskCT]=unique(temp_subCatTable(:,temp_copyIndex == -2),'rows');
    settSim.CTS{n}= unCT;
    settSim.CTorder{n}= maskCT;
    
end
%% Adjust the absent trials
% calculate the absent trials
uniquePriorsabsent= prod(settSim.absentCat_priors',2);
% test the min
if 1/min([uniquePriorsabsent])<round((ttl_sum_condtPresent/(1-settSim.absentprior))*settSim.absentprior)
else
    error('You need at least %.1f trials', ceil(1/min(uniquePriorsabsent)));
end
temp_numbersabsent=floor(uniquePriorsabsent.*round((ttl_sum_condtPresent/(1-settSim.absentprior))*settSim.absentprior));
settSim.numtrialPERcond_A=temp_numbersabsent;

end