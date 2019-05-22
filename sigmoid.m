function [res] = sigmoid(x)
res = 1.0 ./(1+exp(-x));
end