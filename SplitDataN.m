function [XTrain, YTrain, XTest, YTest] = SplitDataN(data_matrix,label)


XTrain(1:900,:) = data_matrix(1:900,:);
YTrain(1:900,:) = label(1:900,:);
XTrain(901:1500,:)=data_matrix(1201:1800,:);
YTrain(901:1500,:)=label(1201:1800,:);

XTest(1:300,:) = data_matrix(901:1200,:);
YTest(1:300,:) = label(901:1200,:);
XTest(301:500,:)=data_matrix(1801:2000,:);
YTest(301:500,:)=label(1801:2000,:);

end

