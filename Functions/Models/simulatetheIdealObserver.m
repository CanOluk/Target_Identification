function [decisionTPT,decisionTAT]= simulatetheIdealObserver(varEXP,settSim, infdebug)
% loop around the amplitude scalars for psychometric function
for t=1:size(settSim.amplitudeSCALARS,2)
    % adjust the amplitude
    TrialAmplitudesADJ=varEXP.TrialAmplitudes.*settSim.amplitudeSCALARS(t);
    % prepare matricies
    ampMATP=repmat(TrialAmplitudesADJ,1,size(varEXP.VPS,1));
    contrMAT=repmat(varEXP.TrialContrasts,1,size(varEXP.VPS,1));
    contrMATABSENT=repmat(varEXP.TRIALS_A,1,size(varEXP.VPS,1));
    
    % calculate the R (normalized responses)
    R_Present=(ampMATP./contrMAT).*varEXP.TargetResponse+varEXP.ExpBaseRespPRSNTORD;
    
    
    % calculate likelihoods while contrast is given, first integrate over
    % the visual patterns
    for tt=1:size(settSim.VPS,2)
        % find the relevant levels
        [~, vpi, ~]=intersect(varEXP.VPS,settSim.VPS{tt});
        ampi=varEXP.ADJ_AMPS{tt}.*settSim.amplitudeSCALARS(t);
        
        clear decision_PVP
        clear decision_AVP
        for ttt=1:size(ampi,1)
            %amplitudesEXP=varEXP.amplitudesRedefined(tt,:).*settSim.amplitudesCALARS(t);
            dprimes=repmat(ampi(ttt,:),size(R_Present(:,vpi),1),1)./contrMAT(:,vpi);
            
            dprimesABSENT=repmat(ampi(ttt,:),size(varEXP.ExpBaseRespABSNTORD(:,vpi),1),1)./contrMATABSENT(:,vpi);
            
            %target present trials
            decision_PVP(:,ttt)= exp(R_Present(:,vpi).*dprimes - 0.5 .*(dprimes).^2)*settSim.VPprior{tt};
            
            if infdebug==1
                if any(isinf(decision_PVP(:)))
                    warning('The matrix contains Inf values.');
                end
            end
            
            % absent trials
            decision_AVP(:,ttt)= exp(varEXP.ExpBaseRespABSNTORD(:,vpi).*dprimesABSENT - 0.5 .*(dprimesABSENT).^2)*settSim.VPprior{tt};
            
        end
        % integrate over amplitude
        decision_PVP_A(:,tt)=log(decision_PVP *settSim.AMPprior{tt})+varEXP.logcategory(tt);
        decision_AVP_A(:,tt)=log(decision_AVP *settSim.AMPprior{tt})+varEXP.logcategory(tt);
        
    end
    
    % READ THE MAXIMUM
    
    [maxVAL_P,loc_P]=max(decision_PVP_A,[],2);
    [maxVAL_A,loc_A]=max(decision_AVP_A,[],2);
    
    decvec_P=zeros(size(loc_P));
    decvec_A=zeros(size(loc_A));
    
    decvec_P(maxVAL_P>varEXP.logabsent)=loc_P(maxVAL_P>varEXP.logabsent);
    decvec_A(maxVAL_A>varEXP.logabsent)=loc_A(maxVAL_A>varEXP.logabsent);
    
    decisionTPT(:,t)=decvec_P;
    decisionTAT(:,t)=decvec_A;
    
    
end
end