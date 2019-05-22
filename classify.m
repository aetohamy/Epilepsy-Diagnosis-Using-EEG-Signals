function [O] = classify(x)
  O = x >= 0.65;
  O = double(O);
end