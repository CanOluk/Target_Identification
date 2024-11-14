if sub_example==1
    %% sub-example 1: detection under target orientation, scale, amplitude and background contrast uncertainty
    
    % simulation parameters
    settSim.nImage = 200000; % number of images. should be less or equal to number of images in the precomputation
    settSim.amplitudeSCALARS=0.05:0.2:2; % for evaluating the psychometric function
    rng(2,"twister")  % set rng
    settSim.RNG = rng;
    settSim.filename ='Combined_UNC_EXAMPLE1'; % set a file name for the results
    settSim.models= models;
    settSim.singleCriteria=1; % for MAX models: single criterion or multiple criteria for categories
    
    % set the uncertainty
    % 1: prepare the absent category (repeated for every unique target condition)
    settSim.absentprior=0.5; % prior of target absent
    settSim.absentCat_index=-2; % index of the background contrast 
    settSim.absentnCat_levels=3:0.2:5; % levels of background contrast
    settSim.absentCat_priors=repmat(1./size(settSim.absentnCat_levels,2),1,size(settSim.absentnCat_levels,2)); % equal prior for sub-categories
    
    % 2: prepare the target categories
    settSim.discriminationCat_index=0;  % 0 for detection, for discrimination refer to the columns in T.PROPERTIES
    settSim.discriminationCat_levels=1; % 1 for detection
    settSim.discriminationCat_priors=1; % 1 for detection
    
    % 3: prepare target subcategories
    subCats=[1 2 -1]; % order of the subcategories: the index refers to the columns in T.PROPERTIES. (-1 is the index for amplitude uncertainty)
    repeat_options=[0 1 1]; % have to start with zero. rest: if one, the levels will repeated for each unique condition.
    subCat.levels{1}=0:10:359;  % levels for subcategory 1
    subCat.levels{2}=1:0.5:6;   % levels for subcategory 2
    subCat.levels{3}=0.5:0.1:2; % levels for subcategory 3
    subCat.priors{1}=repmat(1./size(subCat.levels{1},2),1,size(subCat.levels{1},2)); % equal prior, subcategory 1
    subCat.priors{2}=repmat(1./size(subCat.levels{2},2),1,size(subCat.levels{2},2)); % equal prior, subcategory 2
    subCat.priors{3}=repmat(1./size(subCat.levels{3},2),1,size(subCat.levels{3},2)); % equal prior, subcategory 3
    
    % generate the subcategory matix
    settSim = generateSubcategoryMatrix(settSim,subCat, subCats, repeat_options);
    % Please check:
    % (i)   settSim.subCat_index: the order of the subcategories described 
    %       by the index. Always specify -2 for background contrast and -1 
    %       for target amplitude. The remaining indices refer to the columns of T.PROPERTIES.
    % (ii)  settSim.subCat_levelMAT: unique subcategory conditions for each category.
    % (iii) settSim.subCat_priorMAT: corresponding prior probabilities for settSim.subCat_levelMAT.

    
    % process the settings
    settSim=process_settings(T,settSim);
    % please check: 
    %(i)  settSim.numtrialPERcond_P: number of trials for each unique
    % condition of target present.
    %(ii) settSim.numtrialPERcond_A: number of trials for each unique
    % condition of target absent.
    
    % IMPORTANT: Due to the limited number of trials, slight differences 
    % between prior probabilities may not be accurately reflected in number
    % of trials.

    
    
elseif sub_example==2
    %% sub-example 2: discrimination of scale (with target-absent) under orientation, amplitude and background contrast uncertainty
    % IMPORTANT: Only changes are commented here. For comments, refer to demo_1: Subexample 1.

    settSim.nImage = 200000; 
    settSim.amplitudeSCALARS = 0.05:0.2:2; 
    rng(2,"twister")  
    settSim.RNG = rng;
    settSim.filename ='Combined_UNC_EXAMPLE2'; % Different file name!
    settSim.models= models;
    settSim.singleCriteria=1;
    
    settSim.absentprior=1/12; % change in the prior of target absent!
    settSim.absentCat_index=-2; 
    settSim.absentnCat_levels=3:0.2:5; 
    settSim.absentCat_priors=repmat(1./size(settSim.absentnCat_levels,2),1,size(settSim.absentnCat_levels,2)); 

    settSim.discriminationCat_index=2; % discrimination of scale!
    settSim.discriminationCat_levels=1:0.5:6; % scale levels!
    settSim.discriminationCat_priors=repmat(1./size(settSim.discriminationCat_levels,2),1,size(settSim.discriminationCat_levels,2));
    
    
    subCats=[1 -1]; % scale uncertainty removed!
    repeat_options=[0 1]; % scale uncertainty removed!
    subCat.levels{1}=0:10:359;
    subCat.levels{2}=0.5:0.1:2;
    subCat.priors{1}=repmat(1./size(subCat.levels{1},2),1,size(subCat.levels{1},2));
    subCat.priors{2}=repmat(1./size(subCat.levels{2},2),1,size(subCat.levels{2},2));
    
    settSim = generateSubcategoryMatrix(settSim,subCat, subCats, repeat_options);
    settSim=process_settings(T,settSim);
    
elseif sub_example==3
    %% sub-example 3: SubExample 2 with custom settings
   % IMPORTANT: Only changes are commented here. For comments, refer to demo_1: Subexample 1.
    
    settSim.nImage = 200000; 
    settSim.amplitudeSCALARS=0.05:0.2:2; 
    rng(2,"twister")  
    settSim.RNG = rng;
    settSim.filename ='Combined_UNC_EXAMPLE3'; % Different file name!
    settSim.models= models;
    settSim.singleCriteria=1;
 
    settSim.absentprior=1/12; 
    settSim.absentCat_index=-2; 
    settSim.absentnCat_levels=3:0.2:5; 
    settSim.absentCat_priors=repmat(1./size(settSim.absentnCat_levels,2),1,size(settSim.absentnCat_levels,2)); 
    
    settSim.discriminationCat_index=2; 
    settSim.discriminationCat_levels=1:0.5:6; 
    settSim.discriminationCat_priors=repmat(1./size(settSim.discriminationCat_levels,2),1,size(settSim.discriminationCat_levels,2)); 
    
    subCats=[1 -1]; 
    repeat_options=[0 1]; 
    subCat.levels{1}={140:90:350;
        140:90:350;
        140:90:350;
        140:90:350;
        140:90:350;
        40:90:280;
        40:90:280;
        90;
        0;
        90;
        0;
        }; % custom orientation for each scale level!
    subCat.levels{2}={0.05:0.25:1.5;
        0.05:0.25:1.5;
        0.05:0.25:1.5;
        0.05:0.25:1.5;
        0.05:0.25:1.5;
        0.5:0.5:2;
        0.5:0.5:2;
        1;
        1;
        2;
        2;
        }; % custom amplitude for each scale level!
    subCat.priors{1}={[2/3 1/6 1/6];
        [2/3 1/6 1/6];
        [2/3 1/6 1/6];
        [2/3 1/6 1/6];
        [2/3 1/6 1/6];
        [1/3 1/3 1/3];
        [1/3 1/3 1/3];
        1;
        1;
        1;
        1;
        }; % custom prior for orientations!
    subCat.priors{2}={[1/6 1/6 1/6 1/6 1/6 1/6];
        [1/6 1/6 1/6 1/6 1/6 1/6];
        [1/6 1/6 1/6 1/6 1/6 1/6];
        [1/6 1/6 1/6 1/6 1/6 1/6];
        [1/6 1/6 1/6 1/6 1/6 1/6];
        [1/4 1/4 1/4 1/4];
        [1/4 1/4 1/4 1/4];
        1;
        1;
        1;
        1;
        }; % custom prior for amplitude!
    
    settSim = generateSubcategoryMatrix(settSim,subCat, subCats, repeat_options);
    settSim=process_settings(T,settSim);

else
    error('Undefined subexample')
end