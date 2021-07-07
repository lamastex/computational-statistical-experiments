function deMoivreMap = createDeMoivreSampler(weights)
%CREATEDEMOVIRESAMPLER Summary of this function goes here
%   Detailed explanation goes here

    % If we only recive 1 weight then assume equi 1/weights
    if (size(weights,2) == 1),
        deMoivreMap = createEqui(weights);
        return;
        % weights = ones(1, weights) * 1/weights;
    end

    deMoivreMap = createWeighted(weights);
 
end

function m = createEqui(k)
    
    function s = map(u)
        s = ceil(u * k);
    end
    m = @map;
end

function m = createWeighted(weights)
      
    weights = cumsum(weights);
    l = size(weights, 2);
    % Normalise
    weights = (1/weights(l)) * weights;
    
    function s = map(u)
        for s = 1:l,
            if (u < weights(s)), break; end
        end
    end
    m = @map;
end