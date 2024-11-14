% Reference:
% Oluk, C., & Geisler, W. (2024). Target Identification Under High Levels of Amplitude, Size, Orientation, and Background Uncertainty. bioRxiv, 2024-08.

% Mathematical framework:
% Identification tasks as a hierarchy of exhaustive and mutually exclusive events
% Evaluation of ideal observers for additive targets in white noise

% General Information:
% Four demos are provided here, each involving a distinct set of visual targets.
% With each set of visual targets, a variety of computational experiments can be conducted.
% These experiments can be designed by manipulating the category-subcategory structure, allowing users to adjust:
% (i) Task type,
% (ii) Target uncertainty,
% (iii) Target amplitude and background contrast uncertainty,
% (iv) Relationships among these uncertainties,
% (v) Category and sub-category prior probabilities.

% Simulation Computer:
% CPU: AMD Ryzen Threadripper 2950X 16-Core Processor 3.50 GHz
% RAM: 128 GB 

% Notes:
% (i) The simulation of NN and SNN MAX observers takes a long time due to the need to optimize criteria.
% (ii) Likelihoods sometimes reach infinity, resulting in abnormal
% behavior. To test, go to runModels.m (Functions) and chage the variable 
% infdebug to 1.
% (iii) Currently, RAM is the main bottleneck for running simulations, so it is best to use a machine with large RAM capacity.
% (iv) I aim to improve the efficiency of many sub-components over time.

%% Demo 1: Combined Uncertainty - 36 orientations x 11 scales for sine-wave targets
% Description
% - Total targets: 396
% - Total images: 200,000
% Pre-computation time: 107.477427 seconds / 400 MB
% - Three computational simulation experiments
% Ideal observer Simulation time: 
% (1) 94.090721(10 levels) 
% (2) 111.238655(10 levels)
% (3) 5.819631 (10 levels)

% Run Example 1 Demo
demo_example_1;

%% Demo 2: Orientation-Scale Uncertainty - 360 orientations x 51 scales for sine-wave targets
% Description:
% - Total targets: 18,360
% - Total images: 60,000
% Pre-computation time: 734.796083 seconds / 11 GB
% - Two computational simulation experiments
% Ideal observer Simulation time: 
% (1) 291.144893(30 levels) 
% (2) 571.904708(30 levels)

% Run Example 2 Demo
demo_example_2;

%% Demo 3: Custom Uncertainty - CIFAR100 TEST DATASET
% Description:
% - Total targets: 10,000 
% - Total images: 30,000
% Pre-computation time: 91.292862 seconds / 3 GB
% - Two computational simulation experiments
% Ideal observer Simulation time: 
% (1) 57.506785 (20 levels) 
% (2) 46.686183 (26 levels)

% Run Example 3 Demo
demo_example_3;

%% Demo 4: Custom Uncertainty - CIFAR100 TRAIN DATASET
% Description:
% - Total targets: 50,000 
% - Total images: 100,000
% Pre-computation time: 2237.322747 seconds / 57 GB
% - One computational simulation experiment
% (1) 2044.376536 (26 levels) 

% Run Example 4 Demo
demo_example_4;

