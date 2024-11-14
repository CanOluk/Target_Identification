%% Pre-Computation Phase
% Generates targets, processes templates, and saves results.

% Clear workspace, close figures, and clear command window
clear;close all;clc;

% Set up paths
setupPaths();

% Load settings for pre-computation
settingsPreCalc_Combined

tic

% Generate targets based on settings
T = raisedcosinetargets(settng);

% Process target templates according to settings
T = preprocessTemplates(T, settng);

% Save data 
savePreComputed(T, settng, 'PreComputed');

toc  

%% Computational Simulation Experiments
% Loads precomputed data, prepares experiments, runs models, and saves results.

% Clear workspace, close all figures, and clear command window
clear;close all;clc;

% Set up paths
setupPaths('PreComputed'); 

% Load precomputed data
settSim.precalculationNAME = 'Combined_UNC';
[T, settng] = loadPrecomputedData(settSim.precalculationNAME);

% Computational Simuatilation Settings
% SubExample 1: Detection under target orientation, scale, amplitude, and background contrast uncertainy.
% SubExample 2: Discrimination of scale (with target-absent) under target, orientation, amplitude, and background contrast uncertainy.
% SubExample 3: SubExample 2 with custom settings
sub_example = 1;  % Choose the example number to execute
models = [1]; % list of models: add 1 for ideal observer, 2 for NN-MAX, 3 for SNN-MAX
settingsSimExp_Combined;  % Load combined settings for the chosen example

% Initialize timer to measure execution time
tic;

% Prepare the experiment with pre-calculated settings
varEXP = prepareExperiment(T, settSim);

% Execute model simulations and store results
allResults = runModels(varEXP, settSim);
% allResults.Results dimensions:
% 1: Response Categories
% 2: Amplitude scalar
% 3: Presented Target Category (if a discrimination experiment)
% The rest of dimensions represent the rest of subcategories. 

% Save the results along with configuration settings using a specified filename
saveResults(allResults, settSim, varEXP.TRIALS_A,varEXP.TRIALS_P, 'Results');

% Display figures for model evaluation
figure_1; % Display the general percent correct across models
figure_2; % Create GIFs and display each model's confusion matrix


%% Additional Plotting
% clear anything
clear;close all;clc; 

% Set up paths
setupPaths('Results');

% load the results
settSim.filename ='Combined_UNC_EXAMPLE1';
load(strcat(settSim.filename , '.mat'));

% Basic Figures
figure_1 
open_indices=[3 6 9]; % refers to indices of amplitudeSCALARS. Show the confusion matrices for these levels.
figure_2

% plot subcategory performance
pNumb=3; % pick an amplitude scalar level
pNumb2=2; % pick a subcatgory dimension (-2 contrast, -1 amplitude)
modelsPLOT=[1 2 3]; % 1 ideal, 2 likelihood 
pltType=1; % 1 for overall hit and correct rejections, 2 for confusion matricises
levels=[2 4]; % if plot type is two: refers to indices of selected subcategory. Show the confusion matrices for these levels.

%plot
plotSubCategoryPerformance(allResults, pNumb, pNumb2, settSim,pltType,modelsPLOT,levels)

