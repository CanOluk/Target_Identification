function varEXP=prepareExperiment(TR,settSim)
rng(settSim.RNG.Seed,settSim.RNG.Type) % set rng
%% collapse numbers and indices
numtrialPERcond_P=cell2mat(settSim.numtrialPERcond_P(:));
numtrialPERcond_A=settSim.numtrialPERcond_A;
varEXP.TRIALS_P=repelem(cell2mat(settSim.subCat_levelMAT(:)),numtrialPERcond_P,1);
varEXP.TRIALS_A=repelem(settSim.absentnCat_levels',numtrialPERcond_A,1);

%% assign trials to absent and present conditions
varEXP.WhichTrialP=datasample(1:size(TR.BaseRs,1),sum(numtrialPERcond_P),'Replace',false);
tempv=1:size(TR.BaseRs,1);
tempv(varEXP.WhichTrialP)=[];
nmbr=(sum(numtrialPERcond_A));
varEXP.WhichTrialA=datasample(tempv,round(nmbr),'Replace',false);

%% generate experimental variables from pre-calculated variables

varEXP.VPS=cell2mat(settSim.VPS(:));

% B for target present and absent trials
varEXP.ExpBaseRespPRSNTORD=TR.BaseRs(varEXP.WhichTrialP,varEXP.VPS);
varEXP.ExpBaseRespABSNTORD=TR.BaseRs(varEXP.WhichTrialA,varEXP.VPS);


% t .T for target present trials
temp_array=TR.DOTPRODUCTS(varEXP.VPS,varEXP.VPS)';

% decide on repeatation pattern of conditions
singlemask=repelem(cell2mat(settSim.VPorder(:)),numtrialPERcond_P,1);
varEXP.TargetResponse=temp_array(singlemask,:);


% amplitude and contrast for each trial
% amplitude for the peak of one, re-calculate it for the equal energy
varEXP.TrialAmplitudesCOND=varEXP.TRIALS_P(:,settSim.subCat_index==-1);
normFORind=TR.euclidianNorm(varEXP.VPS);
varEXP.TrialAmplitudes=varEXP.TrialAmplitudesCOND.*normFORind(singlemask)';
varEXP.TrialContrasts=varEXP.TRIALS_P(:,settSim.subCat_index==-2);

% amplitudes that we look for.
for i=1:size(settSim.AMPS,2)
    varEXP.ADJ_AMPS{i}= settSim.AMPS{i}*TR.euclidianNorm(settSim.VPS{i});  
end
%% log priors for categories
varEXP.logabsent=log(settSim.absentprior);
varEXP.logcategory=log(settSim.discriminationCat_priors.*(1-settSim.absentprior));