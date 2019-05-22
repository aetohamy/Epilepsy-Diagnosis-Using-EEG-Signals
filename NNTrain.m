function [weights] = NNTrain(data,label,epochs,hnodes,lr)
n = size(data,2); %input layer size (features)
r = size(data,1); % number of rows (examples)
output = 1; %output layer nodes
nhidden = length(hnodes); % number of hidden layers 
last = nhidden+1;

%% Initialize Weights
weights = InitializeWeights(n,hnodes);

%% Adding Bias Term to Activation of Input Layer
x = data';
a0 = [ones(1,r);x];

min_err = 10000000;
%% Loop Over Epochs
for z = 1 : epochs
    
    %% FEEED FORWARD
     [Z activation] = FeedForward(r,nhidden,a0,weights);
     
     tr = 1-activation{last};
     if (tr == 0)
         tr = zeros(1,r)* -1000;
     end
     %% Cost Estimation
     %J(z)= -(1/r)* sum(label'.*log(activation{last})-(1-label').*tr);
     J(z) = (0.5 / r).*sum(sum((activation{end} - label').^2));
     
     if(J(z) <= min_err)
         min_err = J(z);
         min_weights = weights;
         min_errs(z) = min_err;
     else
         min_errs(z) = min_err;
     end
     
     sigma{last} = activation{last} - label';
     
     %% BACKWARDS PROPAGATION
     for i = last-1 : -1:2
         sigma{i} = weights{i+1}' * sigma{i+1};
         sigma{i} = sigma{i} .* [ones(1,r); dxsigmoid(Z{i})];
         sigma{i} = sigma{i}(2:end,:);
     end
     
     sigma{1} = weights{2}' * sigma{2};
     sigma{1} = sigma{1} .* [ones(1,r); dxsigmoid(Z{1})];
     sigma{1} = sigma{1}(2:end,:);
     
     delta{1} = (sigma{1} * a0')./r;
     
     for i = 2 : nhidden
         delta{i} = (sigma{i} * activation{i-1}')./r;
     end
     
     delta{last} = (sigma{last} * activation{last-1}')./r;
     
     w1 = weights{1} - lr*delta{1};
     weights{1} = w1;
     
     for i = 2 : nhidden
         w = weights{i} - lr*delta{i};
         weights{i} = w;
     end

     
     w2 = weights{last} - lr*delta{last};
     weights{last} = w2;
     
end

%% Calculate Accuracy Of Training
acc = accuracy(activation{last}',label) 
%display("Training Accuracy: " + acc + "%");
figure , plot(min_errs);

weights = min_weights;
end
