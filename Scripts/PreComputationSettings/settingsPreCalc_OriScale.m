%% main parameters

settng.nImage=60000; % change the number

settng.radR = 100; 

settng.filename ='OriScale_UNC'; % different name

rng(2,"twister");settng.RNG = rng; 

%% raisedcosinetargets function options

settng.orientationSpace=0:1:359; % dense levels
settng.scaleSpace=1:0.1:6; % dense levels


settng.freq=1/60;

settng.pxPerDeg=60;
figure
plot(settng.scaleSpace,(((settng.radR./settng.scaleSpace)*2)+1)/settng.pxPerDeg,'o-','LineWidth',2,'MarkerSize',4)
xlabel('Scale');ylabel('Diameter(Visual Degree)');ylim([0.5 3.5]);
figure;
plot(settng.scaleSpace,1./((1/settng.freq)./settng.scaleSpace)*settng.pxPerDeg,'o-','LineWidth',2,'MarkerSize',4)
xlabel('Scale');ylabel('Spatial Frequency (cpd)');ylim([0.9 6.1])
