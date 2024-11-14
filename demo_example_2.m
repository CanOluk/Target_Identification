%% IMPORTANT: Only changes are commented here. For comments, refer to demo_1: Subexample 1.
%% Pre-Computation Phase
clear;close all;clc;
setupPaths();

settingsPreCalc_OriScale % settings are different!

tic
T = raisedcosinetargets(settng);
T = preprocessTemplates(T, settng);
savePreComputed(T, settng, 'PreComputed');
toc  
%% computational simulation experiments
clear;close all;clc; 
setupPaths('PreComputed'); 
settSim.precalculationNAME='OriScale_UNC'; % different file name
[T, settng] = loadPrecomputedData(settSim.precalculationNAME);

% Computational Simuatilation Settings
% SubExample 1: Detection under target orientation, scale uncertainy.
% SubExample 2: Discrimination of scale (with target-absent) under target orientation uncertainy.
sub_example = 1;
models = [1];
settingsSimExp_OriScale  % different settings file 

tic
varEXP=prepareExperiment(T,settSim);
allResults = runModels(varEXP, settSim);
saveResults(allResults, settSim, varEXP.TRIALS_A,varEXP.TRIALS_P, 'Results');

figure_1 
figure_2 

%% Additional Plotting

clear;close all;clc; 
setupPaths('Results');

settSim.filename ='OriScale_UNC_EXAMPLE1';
load(strcat(settSim.filename , '.mat'));

figure_1 
open_indices=[3 6 9]; % refers to indices of amplitudeSCALARS. Show the confusion matrices for these levels.
figure_2 

% plot subcategory performance
pNumb=3; % pick an amplitude scalar level
pNumb2=-2; % pick a subcatgory dimension (-2 contrast, -1 amplitude)
modelsPLOT=[1 2 3]; % 1 ideal, 2 likelihood 
pltType=2; % 1 for overall hit and correct rejections, 2 for confusion matricises
levels=[2 4]; % if plot type is two: refers to indices of selected subcategory. Show the confusion matrices for these levels.

%plot
plotSubCategoryPerformance(allResults, pNumb, pNumb2, settSim,pltType,modelsPLOT,levels)

