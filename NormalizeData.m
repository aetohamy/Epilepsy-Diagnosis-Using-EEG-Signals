function [ normalized ] = NormalizeData(M)
mn = min(M);
mx = max(M);
    for i = 1 : size(M,2)
        x = (M(:,i) - mn(i)) ./ (mx(i)-mn(i));
        normalized(:,i) = x;
    end
end