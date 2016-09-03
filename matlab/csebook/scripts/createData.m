function data = createData(trials, replicates, dimension, sampler, prngSetup)
%CREATEMODEL Summary of this function goes here
%   trials = number of levels (this includes buckets)
%   dimension = the dimension of the data
%   sampler = sampler function that is used to create samples from a 
%             random vector
%   prngSetup = this function is run before the random vector is drawn,
%               allowing you to set up the prng
% Example:
% s = createDeMoivreSampler(2);
% m = createModel(5, 7, 2, s, @()(rand('twister',123)) );

    % Initialise Model
    data = zeros(trials,replicates,dimension);

    % Create Samples that choose direction
    prngSetup();
    samples = arrayfun(sampler, rand(trials * replicates));
    
    % Create Unit Vectors
    for t = 1:replicates,
        for d = 1:trials,
            % WARNING this can skew your results if your sampler is
            % producing samples are higher than the current dimension
            rDimension = min( samples(1, (trials * (t-1)) + d), dimension);
            
            % Set the distance to travel along rDimension to 1, you could
            % make this non discrete by changing this a random amount,
            % You could also make it travel by an arbitary vector by doing
            % something like... data(d,t,1:dimension) = rand(1,dimension);
            data(d,t, rDimension) = 1;
        end
    end
    
    % Create ball trajectory
    data = cumsum(data,1);
    
 end