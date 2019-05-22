function [ weights ] = InitializeWeights(n,hnodes)
nhidden = length(hnodes);

% INITIALIZING WEIGHT MATRICES
    % Input Layer (n+1 => bias)
    weights{1} = rand(hnodes(1),n+1); 
    
    % N hidden Layers
    for i = 2 : nhidden
        weights{i} = rand(hnodes(i),hnodes(i-1)+1);
    end
    
    % Output Layer
    weights{nhidden+1} = rand(1,hnodes(nhidden)+1);
    
end

