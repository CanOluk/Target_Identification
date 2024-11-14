function T = preprocessTemplates(T, settng)
    % Normalize the template vectors and calculate their dot products
    
    % Initialize the matrix to store dot products
    T.DOTPRODUCTS = zeros(size(T.PROPERTIES, 1), size(T.PROPERTIES, 1));
    
    % Compute the Euclidean norm of each vector in VECS
    T.euclidianNorm = vecnorm(T.VECS, 2);
    
    % Normalize each vector in VECS by its norm
    T.VECS = T.VECS ./ repmat(T.euclidianNorm, size(T.VECS, 1), 1);
    
    % Compute the dot products of the normalized vectors
    T.DOTPRODUCTS = T.VECS' * T.VECS;

    % Set the random number generator (RNG) for reproducibility
    rng(settng.RNG.Seed, settng.RNG.Type);
    
    % Calculate the number of images and dimensions for memory optimization
    half_nImage = settng.nImage / 2;
    imageSize = ((settng.radR * 2) + 1)^2;

    % Generate the first batch of white noise images
    noiseImages = randn(half_nImage, imageSize);
    T.BaseRs = noiseImages * T.VECS;
    
    % Clear the first batch to free up memory before generating the second batch
    clear noiseImages;
    
    % Generate the second batch of white noise images and append to BaseRs
    noiseImages = randn(half_nImage, imageSize);
    T.BaseRs = [T.BaseRs; noiseImages * T.VECS];
end
