function [res] = dxsigmoid(x)
res = sigmoid(x) .* (1-sigmoid(x));
end