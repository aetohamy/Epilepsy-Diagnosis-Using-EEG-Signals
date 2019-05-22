function [Z activation ] = FeedForward(r,nhidden,a0,weights)
last = nhidden+1;
% initializing Z and activations 
     Z{1} =  weights{1} * a0;
     activation{1} = sigmoid(Z{1});
     activation{1} = [ones(1,r);activation{1}];
     
     for i = 2 : nhidden
        Z{i} =  weights{i} * activation{i-1};
        activation{i} = sigmoid(Z{i});
        activation{i} = [ones(1,r);activation{i}];
     end
     
     Z{last} =  weights{last} * activation{last-1};
     activation{last} = sigmoid(Z{last});
     sig = activation{last};
     activation{last} = classify(activation{last});
end

