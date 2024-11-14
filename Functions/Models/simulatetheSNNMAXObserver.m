function [decisionTPT,decisionTAT]= simulatetheSNNMAXObserver(varEXP,settSim)
% loop around the amplitude scalars for psychometric function
for t=1:size(settSim.amplitudeSCALARS,2)
    % adjust the amplitude
    TrialAmplitudesADJ=varEXP.TrialAmplitudes.*settSim.amplitudeSCALARS(t);
    % prepare matricies
    ampMATP=repmat(TrialAmplitudesADJ,1,size(varEXP.VPS,1));
    contrMAT=repmat(varEXP.TrialContrasts,1,size(varEXP.VPS,1));
    
    
    % calculate the R (normalized responses)
    R_Present=(ampMATP./contrMAT).*varEXP.TargetResponse+varEXP.ExpBaseRespPRSNTORD;
    R_Absent=varEXP.ExpBaseRespABSNTORD;
    
    
    cellSizes = cellfun(@(x) size(x, 1), settSim.VPS);
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
        %         objectiveFunction = @(x) singlecriterionFORnormMAX(x, R_Present, R_Absent, cellSizes, correctNESS_P, correctNESS_A,varEXP.logcategory);
        %         x0 = [prctile(max(R_Absent, [], 2), settSim.absentprior * 100)];
        %         lb = [min(R_Absent(:))];
        %         ub = [max(R_Absent(:))];
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
        objectiveFunction = @(x) singlecriterionFORnormMAX(x, R_Present, R_Absent, cellSizes, correctNESS_P, correctNESS_A, varEXP.logcategory);
        
        % Define initial bounds
        lb = min(R_Absent(:));
        ub = max(R_Absent(:));
        
        % Run fminbnd
        [pc, fval] = fminbnd(objectiveFunction, lb, ub, optimset('Display', 'iter', 'TolX', 1e-2));
        
        
        xef=[varEXP.logcategory pc(1:end-1)'];
        xlargeP=repmat(repelem(xef, cellSizes),size(R_Present,1),1);
        xlargeA=repmat(repelem(xef, cellSizes),size(R_Absent,1),1);
        cate=repelem(1:size(cellSizes,2), cellSizes);
        % READ THE MAXIMUM
        R_Present=R_Present+xlargeP;
        R_Absent=R_Absent+xlargeA;
        
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
        % find criteria
        % Define the function to minimize
        objectiveFunction = @(x) criterionFORnormMAX(x, R_Present, R_Absent, cellSizes, correctNESS_P, correctNESS_A);
        
        % Set initial guess for x (you should replace `x0` with your initial vector)
        x0 = [zeros(size(cellSizes,2)-1,1); prctile(max(R_Absent,[],2), settSim.absentprior*100)];
        lb=[repmat(min(R_Present(:)),size(cellSizes,2)-1,1); min(R_Absent(:))];
        ub=[repmat(max(R_Present(:)),size(cellSizes,2)-1,1); max(R_Absent(:))];
        
        
        
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
        
        % Run patternsearch with bounds
        [pc, fval] = patternsearch(objectiveFunction, x0, [], [], [], [], lb, ub, [], options);
        
        
        
        
        
        xef=[pc(1:end-1)' 0];
        xlargeP=repmat(repelem(xef, cellSizes),size(R_Present,1),1);
        xlargeA=repmat(repelem(xef, cellSizes),size(R_Absent,1),1);
        cate=repelem(1:size(cellSizes,2), cellSizes);
        % READ THE MAXIMUM
        R_Present=R_Present+xlargeP;
        R_Absent=R_Absent+xlargeA;
        
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