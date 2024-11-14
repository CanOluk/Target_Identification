%% IMPORTANT: Only changes are commented here. For comments, refer to demo_1: Subexample 1.

%% CIFAR100
% Superclass:	Classes
% 1.aquatic mammals:	beaver, dolphin, otter, seal, whale
% 2.fish:	aquarium fish, flatfish, ray, shark, trout
% 3.flowers:	orchids, poppies, roses, sunflowers, tulips
% 4.food containers:	bottles, bowls, cans, cups, plates
% 5.fruit and vegetables:	apples, mushrooms, oranges, pears, sweet peppers
% 6.household electrical devices:	clock, computer keyboard, lamp, telephone, television
% 7.household furniture:	bed, chair, couch, table, wardrobe
% 8.insects:	bee, beetle, butterfly, caterpillar, cockroach
% 9.large carnivores:	bear, leopard, lion, tiger, wolf
% 10.large man-made outdoor things:	bridge, castle, house, road, skyscraper
% 11.large natural outdoor scenes:	cloud, forest, mountain, plain, sea
% 12.large omnivores and herbivores:	camel, cattle, chimpanzee, elephant, kangaroo
% 13.medium-sized mammals:	fox, porcupine, possum, raccoon, skunk
% 14.non-insect invertebrates:	crab, lobster, snail, spider, worm
% 15.people:	baby, boy, girl, man, woman
% 16.reptiles:	crocodile, dinosaur, lizard, snake, turtle
% 17.small mammals:	hamster, mouse, rabbit, shrew, squirrel
% 18.trees:	maple, oak, palm, pine, willow
% 19.vehicles 1:	bicycle, bus, motorcycle, pickup truck, train
% 20.vehicles 2:	lawn-mower, rocket, streetcar, tank, tractor
%% Pre-Computation Phase
clear;close all;clc;
setupPaths();

settingsPreCalc_CIFAR100train % settings are different!

tic

% custom matricises for T.VESCS T.PROPERTIES!
load('CIFAR100_TRAIN.mat')
T.VECS=T_train.VECS;
T.PROPERTIES=T_train.PROPERTIES;
clear T_train

% plot three examples
rng(1) % change random seed to check our different examples
figure
for x=1:3
subplot(1,3,x)
RAND_INDX=randi(size(T.VECS,2));
imagesc(reshape(T.VECS(:,RAND_INDX),(settng.radR*2)+1,(settng.radR*2)+1)'); axis off; axis square; 
title(strcat('Category:',num2str(T.PROPERTIES(RAND_INDX,1)),'Subcategory:',num2str(T.PROPERTIES(RAND_INDX,2))))
colormap gray
end

T = preprocessTemplates(T, settng);
savePreComputed(T, settng, 'PreComputed');
toc 
%% computational simulation experiments
clear;close all;clc;
setupPaths('PreComputed');
settSim.precalculationNAME='CIFAR100train_UNC'; % different file name
[T, settng] = loadPrecomputedData(settSim.precalculationNAME);


% Computational Simuatilation Settings
% SubExample 1: Discrimination of main category
sub_example = 1; 
models = [1];
settingsSimExp_CIFAR100train

tic
varEXP=prepareExperiment(T,settSim);
allResults = runModels(varEXP, settSim);
saveResults(allResults, settSim, varEXP.TRIALS_A,varEXP.TRIALS_P, 'Results');

figure_1 
figure_2 

%% Additional Plotting

clear;close all;clc;
setupPaths('Results');

settSim.filename ='CIFAR100train_UNC_EXAMPLE2';
load(strcat(settSim.filename , '.mat'));

figure_1 
open_indices=[3 6 9]; % refers to indices of amplitudeSCALARS. Show the confusion matrices for these levels.
figure_2

% plot subcategory performance
pNumb=4; % pick an amplitude scalar level
pNumb2=2; % pick a subcatgory dimension (-2 contrast, -1 amplitude)
modelsPLOT=[1]; % 1 ideal, 2 likelihood
pltType=1; % 1 for overall hit and correct rejections, 2 for confusion matricises
levels=[3 5 8]; % if plot type is two, only show these levels

%plot
plotSubCategoryPerformance(allResults, pNumb, pNumb2, settSim,pltType,modelsPLOT,levels)

% ONLY FOR DISCRIMINATION OF MAIN CATEGORIES: SUBEXAMPLE 1
% special figure for CIFAR100 (Confusion Matrix with Unique Subcategories)
pNumb=5; % pick an amplitude scalar level
pNumb2=2; % only meaningful for index 2 since it is not repeated for each category
modelsPLOT=[1]; % 1 ideal
confusionSUBCATEGORYfig

