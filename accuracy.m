function [a] = accuracy(x,label)
acc = (x == label);
acc = sum(acc,1);
a = acc*100/size(label,1);
end