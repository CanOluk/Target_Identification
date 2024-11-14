function [decisionTPT,decisionTAT]= simulatetheNNMAXObserver(varEXP,settSim)
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
    decision_PVP=[];
    decision_AVP=[];
    
    
    cate=[];
    cellSizes=zeros(1,size(settSim.VPS,2));
    % calculate likelihoods while contrast is given, first integrate over
    % the visual patterns
    for tt=1:size(settSim.VPS,2)
        % find the relevant levels
        [~, vpi, ~]=intersect(varEXP.VPS,settSim.VPS{tt});
        ampi=varEXP.ADJ_AMPS{tt}.*settSim.amplitudeSCALARS(t);
        
        
        for ttt=1:size(ampi,1)
            
            cellSizes(tt) = cellSizes(tt)+size(settSim.VPS{tt},1);
            dprimes=repmat(ampi(ttt,:),size(R_Present(:,vpi),1),1)./contrMAT(:,vpi);
            
            dprimesABSENT=repmat(ampi(ttt,:),size(varEXP.ExpBaseRespABSNTORD(:,vpi),1),1)./contrMATABSENT(:,vpi);
            
            %target present trials
            decision_PVP= [decision_PVP (R_Present(:,vpi).*dprimes - 0.5 .*(dprimes).^2)];
            
            
            % absent trials
            decision_AVP= [decision_AVP (varEXP.ExpBaseRespABSNTORD(:,vpi).*dprimesABSENT - 0.5 .*(dprimesABSENT).^2)];
            
            
        end
        cate=[cate;repmat(tt,size(settSim.VPprior{tt},1).*size(settSim.AMPprior{tt},1),1)];
        
    end
    
    % calculate likelihoods while contrast is given, first integrate over
    % the visual patterns
    if settSim.discriminationCat_index==0
        correctNESS_P=ones(size(varEXP.TRIALS_P,1),1);
    else
        [~,~,correctNESS_P]=unique(varEXP.TRIALS_P(:,1));
    end
    correctNESS_A=zeros(size(varEXP.TRIALS_A,1),1);
    
    
    
    
    
    if settSim.singleCriteria
        %         % Define the objective function
        %         objectiveFunction = @(x) singlecriterionFORnormMAX(x, decision_PVP, decision_AVP, cellSizes, correctNESS_P, correctNESS_A,varEXP.logcategory);
        %         x0 = [prctile(max(decision_AVP, [], 2), settSim.absentprior * 100)];
        %         lb = [min(decision_AVP(:))];
        %         ub = [max(decision_AVP(:))];
        %
        %         % Configure refined patternsearch options
        %         options = optimoptions('patternsearch', ...
        %             'Display', 'iter', ...
        %             'MeshTolerance', 1e-2, ...             % Slightly smaller tolerance for balanced exploration
        %             'InitialMeshSize', 1, ...              % Moderate initial mesh size
        %             'MeshExpansionFactor', 2, ...          % Moderate expansion for smooth exploration
        %             'MeshContractionFactor', 0.5, ...      % Standard contraction factor
        %             'UseCompletePoll', true, ...           % Poll all points for thorough search in parallel
        %             'MaxIterations', 1000, ...             % Allow more iterations for accuracy
        %             'MaxFunctionEvaluations', 10000);      % Allow more evaluations
        %
        %         % Run patternsearch
        %         [pc, fval] = patternsearch(objectiveFunction, x0, [], [], [], [], lb, ub, [], options);
        
        
        % Define the objective function
        objectiveFunction = @(x) singlecriterionFORnormMAX(x, decision_PVP, decision_AVP, cellSizes, correctNESS_P, correctNESS_A, varEXP.logcategory);
        
        % Define initial bounds
        lb = min(decision_AVP(:));
        ub = max(decision_AVP(:));
        
        % Run fminbnd
        [pc, fval] = fminbnd(objectiveFunction, lb, ub, optimset('Display', 'iter', 'TolX', 1e-2));
        
        
        xef=[varEXP.logcategory pc(1:end-1)'];
        xlargeP=repmat(repelem(xef, cellSizes),size(decision_PVP,1),1);
        xlargeA=repmat(repelem(xef, cellSizes),size(decision_AVP,1),1);
        cate=repelem(1:size(cellSizes,2), cellSizes);
        % READ THE MAXIMUM
        R_Present=decision_PVP+xlargeP;
        R_Absent=decision_AVP+xlargeA;
        
        [maxVAL_P,loc_P]=max(R_Present,[],2);
        [maxVAL_A,loc_A]=max(R_Absent,[],2);
        loc_P=cate(loc_P);
        loc_A=cate(loc_A);
        
        decvec_P=zeros(size(loc_P));
        decvec_A=zeros(size(loc_A));
        
        decvec_P(maxVAL_P>pc(end))=loc_P(maxVAL_P>pc(end));
        decvec_A(maxVAL_A>pc(end))=loc_A(maxVAL_A>pc(end));
        
        
        decisionTPT(:,t)=decvec_P;
        decisionTAT(:,t)=decvec_A;
        
        
    else
        % Define the objective function
        objectiveFunction = @(x) criterionFORnormMAX(x, decision_PVP, decision_AVP, cellSizes, correctNESS_P, correctNESS_A);
        % Initial guess for x
        x0 = [zeros(size(cellSizes, 2) - 1, 1); prctile(max(decision_AVP, [], 2), settSim.absentprior * 100)];
        lb = [repmat(min(decision_PVP(:)), size(cellSizes, 2) - 1, 1); min(decision_AVP(:))];
        ub = [repmat(max(decision_PVP(:)), size(cellSizes, 2) - 1, 1); max(decision_AVP(:))];
        
        % Configure refined patternsearch options
        options = optimoptions('patternsearch', ...
            'Display', 'iter', ...
            'MeshTolerance', 1e-2, ...             % Slightly smaller tolerance for balanced exploration
            'InitialMeshSize', 1, ...              % Moderate initial mesh size
            'MeshExpansionFactor', 2, ...          % Moderate expansion for smooth exploration
            'MeshContractionFactor', 0.5, ...      % Standard contraction factor
            'UseCompletePoll', true, ...           % Poll all points for thorough search in parallel
            'MaxIterations', 1000, ...             % Allow more iterations for accuracy
            'MaxFunctionEvaluations', 10000);      % Allow more evaluations
        
        % Run patternsearch
        [pc, fval] = patternsearch(objectiveFunction, x0, [], [], [], [], lb, ub, [], options);
        
        
        
        
        
        
        xef=[pc(1:end-1)' 0];
        xlargeP=repmat(repelem(xef, cellSizes),size(decision_PVP,1),1);
        xlargeA=repmat(repelem(xef, cellSizes),size(decision_AVP,1),1);
        cate=repelem(1:size(cellSizes,2), cellSizes);
        % READ THE MAXIMUM
        R_Present=decision_PVP+xlargeP;
        R_Absent=decision_AVP+xlargeA;
        
        [maxVAL_P,loc_P]=max(R_Present,[],2);
        [maxVAL_A,loc_A]=max(R_Absent,[],2);
        loc_P=cate(loc_P);
        loc_A=cate(loc_A);
        
        decvec_P=zeros(size(loc_P));
        decvec_A=zeros(size(loc_A));
        
        decvec_P(maxVAL_P>pc(end))=loc_P(maxVAL_P>pc(end));
        decvec_A(maxVAL_A>pc(end))=loc_A(maxVAL_A>pc(end));
        
        
        decisionTPT(:,t)=decvec_P;
        decisionTAT(:,t)=decvec_A;
    end
    
end
end