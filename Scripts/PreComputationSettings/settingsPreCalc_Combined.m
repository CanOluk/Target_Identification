%% main parameters

settng.nImage=200000; % number of noise images

settng.radR = 100; % image radius, the overall size is (radR*2)+1

settng.filename ='Combined_UNC'; % set a file name

rng(2,"twister");settng.RNG = rng; % set rng


%% raisedcosinetargets function options

settng.orientationSpace=0:10:359; % set alternative orientations
settng.scaleSpace=1:0.5:6; % set alternative scales

% frequency for the scale one.
settng.freq=1/60;% target frequency cy/pix

% plotting to understand the scale.
settng.pxPerDeg=60;% assumption pixel per degree
figure
plot(settng.scaleSpace,(((settng.radR./settng.scaleSpace)*2)+1)/settng.pxPerDeg,'o-','LineWidth',2,'MarkerSize',4)
xlabel('Scale');ylabel('Diameter(Visual Degree)');ylim([0.5 3.5]);
figure;
plot(settng.scaleSpace,1./((1/settng.freq)./settng.scaleSpace)*settng.pxPerDeg,'o-','LineWidth',2,'MarkerSize',4)
xlabel('Scale');ylabel('Spatial Frequency (cpd)');ylim([0.9 6.1])
