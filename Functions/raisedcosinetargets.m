function [T] = raisedcosinetargets(settings)
% Generate Target Patterns Using Raised Cosine Window and Sine-Wave
% This function creates a dictionary of target patterns based on specified orientations and scales.
% Targets are generated using sine-wave function windowed by a raised cosine.

% NOTE: !The radius is scaled to maintain odd-sized templates, which
% slightly differs from scaling the entire size.!

% Parameters
sz = 2 * settings.radR + 1; % Total image size: diameter
cen = settings.radR + 1;    % Center of the image

% Initialize the output structure
ij = 1;
numOrientations = size(settings.orientationSpace, 2);
numScales = size(settings.scaleSpace, 2);
T.VECS = zeros(sz * sz, numOrientations * numScales);
T.PROPERTIES = zeros(numOrientations * numScales, 2);

% Generate targets for each combination of orientation and scale
for jj = 1:numOrientations
    orientation = settings.orientationSpace(jj);
    for ii = 1:numScales
        scale = settings.scaleSpace(ii);
        radius = settings.radR * (1 / scale); % Scale effect on radius
        
        % Initialize target matrix
        target = zeros(sz, sz);
        window = zeros(sz, sz); % Raised-cosine window
        
        % Compute target pattern
        for i = 1:sz
            for j = 1:sz
                distance = sqrt((i - cen)^2 + (j - cen)^2);
                if distance <= radius
                    j0 = j - cen;
                    i0 = i - cen;
                    iR = -j0 * sind(orientation) * scale + i0 * cosd(orientation) * scale;
                    target(i, j) = 0.5 * (1 + cos(pi * distance / radius)) * sin(2 * pi * settings.freq * iR);
                    window(i, j) = 0.5 * (1 + cos(pi * distance / radius));
                end
            end
        end
        
        % Normalize peak to 1
        normalizedTarget = target / max(target(:));
        T.VECS(:, ij) = normalizedTarget(:);
        
        % Store properties
        T.PROPERTIES(ij, :) = [orientation, scale];
        ij = ij + 1;
    end
end
end
