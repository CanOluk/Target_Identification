if sub_example==1
    %% sub-example 1: detection under orientation, scale uncertainty
    
    settSim.nImage = 60000; % different number of images
    settSim.amplitudeSCALARS=0.01:0.1:3; % different amplitude scalars
    rng(2,"twister")  
    settSim.RNG = rng;
    settSim.filename ='OriScale_UNC_EXAMPLE1'; % Different file name!
    settSim.models= models; 
    settSim.singleCriteria=1;
 
    settSim.absentprior=0.5; 
    settSim.absentCat_index=-2; 
    settSim.absentnCat_levels=5; % no contrast uncertainty
    settSim.absentCat_priors=1; 
  
    settSim.discriminationCat_index=0; 
    settSim.discriminationCat_levels=1; 
    settSim.discriminationCat_priors=1; 
    
    
    subCats=[1 2 -1]; 
    repeat_options=[0 1 1]; 
    subCat.levels{1}=0:1:359; % dense levels
    subCat.levels{2}=1:0.1:6;  % dense levels
    subCat.levels{3}=1; % no amplitude uncertainty
    subCat.priors{1}=repmat(1./size(subCat.levels{1},2),1,size(subCat.levels{1},2)); 
    subCat.priors{2}=repmat(1./size(subCat.levels{2},2),1,size(subCat.levels{2},2)); 
    subCat.priors{3}=1; % no amplitude uncertainty
    
    settSim = generateSubcategoryMatrix(settSim,subCat, subCats, repeat_options);   
    settSim=process_settings(T,settSim);
    
elseif sub_example==2
    %% sub-example 2: discrimination of scale (with target-absent) under orientation uncertainty
    
    settSim.nImage = 60000; 
    settSim.amplitudeSCALARS=0.01:0.1:3; % adjusted amplitude scalars
    rng(2,"twister")  
    settSim.RNG = rng;
    settSim.filename ='OriScale_UNC_EXAMPLE2'; % Different file name!
    settSim.models= models; 
    settSim.singleCriteria=1;
    
    settSim.absentprior=1/52; % prior of target absent
    settSim.absentCat_index=-2; 
    settSim.absentnCat_levels=5; 
    settSim.absentCat_priors=1; 
    
    settSim.discriminationCat_index=2;  % discrimination of scale!
    settSim.discriminationCat_levels=1:0.1:6; % scale levels!
    settSim.discriminationCat_priors=repmat(1./size(settSim.discriminationCat_levels,2),1,size(settSim.discriminationCat_levels,2)); 
    
    subCats=[1 -1]; % scale uncertainty removed!
    repeat_options=[0 1]; % scale uncertainty removed!
    subCat.levels{1}=0:1:359; 
    subCat.levels{2}=1; 
    subCat.priors{1}=repmat(1./size(subCat.levels{1},2),1,size(subCat.levels{1},2)); 
    subCat.priors{2}=1; 
    
    settSim = generateSubcategoryMatrix(settSim,subCat, subCats, repeat_options);
    settSim=process_settings(T,settSim);

else
    error('Undefined subexample')
end
