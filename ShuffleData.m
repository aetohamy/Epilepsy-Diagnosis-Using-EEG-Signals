function [ ndata , label ] = ShuffleData(data,label)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
data(:,end+1) = label;
rand_pos = randperm(length(data)); %array of random positions
    for i = 1:size(data,1)
        data_shuffled(i,:) = data(rand_pos(i),:);
    end

ndata = data_shuffled(:,1:end-1);
label = data_shuffled(:,end);
end

