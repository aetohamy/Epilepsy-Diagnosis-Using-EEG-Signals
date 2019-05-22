function [accuracy] = NeuralNetwork()
%% DATA ACQUISTION
[data label] = ReadData();

%normalizing data:
ndata = NormalizeData(data);

% shuffling data for training and testing
[ndata , label] = ShuffleData(ndata,label);

%Split data into training and testing
[XTrain YTrain XTest YTest] = SplitData(ndata,label,75);

%%%%%%%%%%%%    FOR DEBUGING PURPOSES  %%%%%%%
%XTrain = [0.1 0.2 1;0.1 0.1 0.9;0.3 0.4 0.2;0.2 0.03 0.7;0.6 0.6 0.3;];
%YTrain = [1;1;0;1;0];
%%%%%%%%%%%%%%%%%%                      %%%%%%%%%%%%%%%%%%%%%%

%% NEURAL NETWORK
m = size(XTrain,1);
lr = 0.1;
epochs = 70;
ninput = size(XTrain,2); %without the bias
hnodes = [4];

W = NNTrain(XTrain,YTrain,epochs,hnodes,lr);
TestAcc = NNTest(XTest,YTest,W,length(hnodes));
display("Testing Accuracy : " + TestAcc + "%");

accuracy = TestAcc;
end

