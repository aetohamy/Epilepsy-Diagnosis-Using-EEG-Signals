function [acc] = NNTest(data,label,weights,nhidden)
n = size(data,2); %input layer size (features)
r = size(data,1); % number of rows (examples)
x = data';
a0 = [ones(1,r);x];
last = nhidden+1;

[Z activation] = FeedForward(r,nhidden,a0,weights);
acc = accuracy(activation{last}',label);

end

