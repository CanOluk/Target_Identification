function [pc] = criterionFORnormMAX(x,decision_PVP,decision_AVP,cellSizes,correctNESS_P,correctNESS_A)
% Precompute repeated elements for efficiency
xef = [x(1:end-1); 0];
xlargeBase = repelem(xef, cellSizes);

% Check if xlargeBase is a column vector and transpose if true
if iscolumn(xlargeBase)
    xlargeBase = xlargeBase.';  % Transpose to make it a row vector
end

% Replicate xlargeBase only once for both PVP and AVP
xlargeP = repmat(xlargeBase, size(decision_PVP, 1), 1);
xlargeA = repmat(xlargeBase, size(decision_AVP, 1), 1);

% Vectorize category assignment
cate = repelem(1:size(cellSizes, 2), cellSizes);

% Add xlarge matrices to decision matrices
decision_PVP = decision_PVP + xlargeP;
decision_AVP = decision_AVP + xlargeA;

% Find maximum values and locations
[maxVAL_P, loc_P] = max(decision_PVP, [], 2);
[maxVAL_A, loc_A] = max(decision_AVP, [], 2);

% Use category assignment only once
loc_P = cate(loc_P);
loc_A = cate(loc_A);

% Vectorized decision vectors based on condition
decvec_P = loc_P' .* (maxVAL_P > x(end));
decvec_A = loc_A' .* (maxVAL_A > x(end));

% Calculate the penalty
pc = -(sum(decvec_P == correctNESS_P) + sum(decvec_A == correctNESS_A));

end

