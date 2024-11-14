if sub_example==1
    %% sub-example 1: detection of CIFAR100 target
    
    settSim.nImage = 20000; % different number of images
    settSim.amplitudeSCALARS=0.001:0.003:0.058; % amplitude scalars
    rng(2,"twister")  
    settSim.RNG = rng;
    settSim.filename ='CIFAR100test_UNC_EXAMPLE1'; % Different file name!
    settSim.models= models; 
    settSim.singleCriteria=1;
 
    settSim.absentprior=0.5; 
    settSim.absentCat_index=-2; 
    settSim.absentnCat_levels=10; % no contrast uncertainty
    settSim.absentCat_priors=1; 
  
    settSim.discriminationCat_index=0; 
    settSim.discriminationCat_levels=1; 
    settSim.discriminationCat_priors=1; 
    
    % Custom (i) settSim.subCat_index, (ii)  settSim.subCat_levelMAT, (iii) settSim.subCat_priorMAT
    % see the documentation in the demo_1 subexample 1.
    settSim.subCat_index=[1 2 3 -1 -2];
    settSim.subCat_levelMAT{1}=[(T.PROPERTIES) ones(size(T.PROPERTIES,1),1) ones(size(T.PROPERTIES,1),1)*settSim.absentnCat_levels];
    settSim.subCat_priorMAT{1}=[repmat(1/20,size(T.PROPERTIES,1),1) repmat(1/5,size(T.PROPERTIES,1),1) repmat(1/100,size(T.PROPERTIES,1),1)  ones(size(T.PROPERTIES,1),1) ones(size(T.PROPERTIES,1),1)]; % equal prior
    % CIFAR100 test: 20 main category (INDEX:1), 5 subcategory each (INDEX:2), 100 examples in each
    % subcategory (INDEX: 3) amplitude uncertainty (-1). All priors are equal.
    
    settSim=process_settings(T,settSim);
    
elseif sub_example==2
    %% sub-example 2: discrimination of main categories of CIFAR100
    
    settSim.nImage = 20000; 
    settSim.amplitudeSCALARS=0.005:0.001:0.03; % amplitude scalars
    rng(2,"twister")  
    settSim.RNG = rng;
    settSim.filename ='CIFAR100test_UNC_EXAMPLE2'; % Different file name!
    settSim.models= models; 
    settSim.singleCriteria=1;
    
    settSim.absentprior=1/100; % low target absent prior
    settSim.absentCat_index=-2; 
    settSim.absentnCat_levels=5; 
    settSim.absentCat_priors=1; 
    
    settSim.discriminationCat_index=1;  % discrimination main category!
    settSim.discriminationCat_levels=1:1:20; % category levels!
    settSim.discriminationCat_priors=repmat(1./size(settSim.discriminationCat_levels,2),1,size(settSim.discriminationCat_levels,2));
    
    % Custom 
    settSim.subCat_index=[2 3 -1 -2]; % no uncertainty about index 1 of T.PROPERTIES.
    for n=1:size(settSim.discriminationCat_levels,2)
        temp=T.PROPERTIES(T.PROPERTIES(:,1)==settSim.discriminationCat_levels(n),[2 3]);
        settSim.subCat_levelMAT{n}=[temp ones(size(temp,1),1) ones(size(temp,1),1)*settSim.absentnCat_levels];
        settSim.subCat_priorMAT{n}=[repmat(1/5,size(temp,1),1) repmat(1/100,size(temp,1),1)  ones(size(temp,1),1) ones(size(temp,1),1)]; % equal prior
    end

    
    settSim=process_settings(T,settSim);
else
    error('Undefined subexample')
end