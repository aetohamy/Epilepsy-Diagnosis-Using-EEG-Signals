function [ res ] = ReLU(x)
res = (x > 0);
res = res .* x;
end