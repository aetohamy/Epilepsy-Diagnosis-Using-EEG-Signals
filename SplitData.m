function [XTrain YTrain XTest YTest] = SplitData(data_matrix,label,percentage_training)
nTraining = (percentage_training*size(data_matrix,1))/100; %  PercentageTraining

XTrain = data_matrix(1:nTraining,:);
YTrain = label(1:nTraining,:);

XTest = data_matrix(nTraining+1:end,:);
YTest = label(nTraining+1:end,:);

end

