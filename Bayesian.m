function [accuracy] = Bayesian()
    clc
    clear all
    XTestSize = 150;
    XTrainSize = 250;
    %0. Call ReadData
    [data , label] = ReadData();
    %1. Call PrepareTheData   
    [XTrain, YTrain, XTest, YTest] = PrepareTheData(data,label,XTrainSize,XTestSize);
    %2. Call EstimateMus given XTrain
    MusMatrix = EstimateMus(XTrain,XTrainSize);
    %3. Call EstimateSigmas given Xtrain and mus   
    SigmasMatrix = EstimateSigmas(XTrain,MusMatrix,XTrainSize);

    %4. Call GeneralBayesClassifier given XTest, mus and sigmas
    YPredict = GeneralBayesClassifier(XTest,MusMatrix,SigmasMatrix,XTestSize*2);
    %5. Call CalculateAccuracy given YTest and YPredict
    accuracy = CalculateAccuracy(YTest,YPredict);
    txt = sprintf('Accuracy : %f %', accuracy);
    disp(txt);
end

function [data label] = ReadData()
cols = 20;
rows = 400;

% READING HEALTHY PEOPLE Z
fid = fopen('Dataset/z.txt');
Z = fscanf(fid,'%f',[cols,rows])';
data(1:rows,1:cols) = Z;

% READING HEALTHY PEOPLE O
fid = fopen('Dataset/O.txt');
O = fscanf(fid,'%f',[cols,rows])';
data(rows+1:rows*2,1:cols) = O;

% [ADDING 1 IDENTIFIER TO HEALTHY PEOPLE]
label(1:rows*2,1) = 1;

%READING UNHEALTHY PEOPLE N 
fid = fopen('Dataset/N.txt');
N = fscanf(fid,'%f',[cols,rows])';
data(rows*2+1:rows*3,1:cols) = N;

%READING UNHEALTHY PEOPLE F
fid = fopen('Dataset/F.txt');
F = fscanf(fid,'%f',[cols,rows])';
data(rows*3+1:rows*4,1:cols) = F;

%READING UNHEALTHY PEOPLE S
fid = fopen('Dataset/S.txt');
S = fscanf(fid,'%f',[cols,rows])';
data(rows*4+1:rows*5,1:cols) = S;

% OPTIONAL [ADDING 2 IDENTIFIER TO UNHEALTHY PEOPLE]
label(rows*2+1:rows*5,1) = 2;
end

%%%%%%%%%%%%%%%% PART 0 Data Preparation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function recieves the filename.csv                         %%%
%%% It returns 4 vectors X and Y for Training and Testing           %%%
%%% XTrain, Size (20,4,3)                                           %%%
%%% YTrain, Size (20,1,3) (You won't need this in this task         %%%
%%% XTest, Size (90, 4)                                             %%%
%%% YTest, Size (90,1)                                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [XTrain, YTrain, XTest, YTest] = PrepareTheData(Data,label,XTrainSize,XTestSize)
    %read the csv data and return an output volume 
    %%% Training Size
    %%% XTrain --> 20X4X3
    %%% YTrain --> 20X4X1
    
    %%% Testing Size
    %%% XTest --> 90X4 (Urolled Vector)
    %%% YTest --> 90X1 (Urolled Vector)
    %Hint:: you can parse the csv file using the line below.
    % Forming the XTrain Matrix
    
    XTrain = ones(XTrainSize,20,2);
    XTrain(:,:,1) = datasample(Data(1:500,:),XTrainSize);
    XTrain(:,:,2) = datasample(Data(801:1500,:),XTrainSize);
    
    %Forming the XTest Matrix
    XTest(1:XTestSize,:)   = datasample(Data(501:800,:),XTestSize);
    XTest(XTestSize+1:XTestSize*2,:) = datasample(Data(1501:2000,:),XTestSize);
    
    %Forming the XTest Matrix
    YTest = zeros(XTestSize*2,1);
    YTest(1:XTestSize) = 1;
    YTest(XTestSize+1:XTestSize*2) = 2;
    
    YTrain = ones(20,1,3);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% PART 1 Params Estimate %%%%%%%%%%%%%%%%%%%%%%%
%%% Estimate Both of Mu and Sigma                                    %%%
%%% given a vector of data points X                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mus = EstimateMus(X,XTrainSize)
   %Hint:: you can validate the output by using "mean(X)"
   
   MusMatrix = ones(2,20);
   S1 = sum(X(:,:,1),1);
   MusMatrix(1,:) = S1/XTrainSize;
   S2 = sum(X(:,:,2),1);
   MusMatrix(2,:) = S2/XTrainSize;
   mus = MusMatrix;
   %Your code goes here ...
   
end
function sigmas = EstimateSigmas(X, Mus,XTrainSize)
    %Hint:: you can validate the output by using "std(X)"
    
   sigmas = ones(2,20);
   sigmas(1,:) = sqrt(sum((X(:,:,1) - Mus(1,:)).^2)/XTrainSize);
   sigmas(2,:) = sqrt(sum((X(:,:,2) - Mus(2,:)).^2)/XTrainSize);

   
   %O = std(X);
    %Your code goes here ...
   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%% PART 3 Classification  %%%%%%%%%%%%%%%%%%%%%%%
%%%                     General Bayes Calssifier                     %%%
%%% Recieves:                                                        %%%
%%% X -> Testing samples, Size = (90,4)                              %%%
%%% Mus -> Estimated Mus for classes, Size = (1,4,3)                 %%%
%%% Sigmas -> Estimated Sigmas for classes Size = (1,4,3)            %%%
%%% Returns:                                                         %%%
%%% YPredict -> Predicted labels, Size (90,1)                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [YPredict] = GeneralBayesClassifier(X, Mus, Sigmas,XTestSize)
    
    AllLikelihoods = ones(XTestSize,20,2);
    
    mus = repmat(Mus(1,:),XTestSize,1);
    sig = repmat(Sigmas(1,:),XTestSize,1);
    AllLikelihoods(:,:,1) = EstimateLikelihoods(X,mus,sig,XTestSize);
    
    mus = repmat(Mus(2,:),XTestSize,1);
    sig = repmat(Sigmas(2,:),XTestSize,1);
    AllLikelihoods(:,:,2) = EstimateLikelihoods(X,mus,sig,XTestSize);
    
    m = prod(AllLikelihoods,2);
    o(:,:,1) = 2/5 .* m(:,:,1);
    o(:,:,2) = 3/5 .* m(:,:,2);
    evidence = sum(o,3);
    evidence_dup = repmat(evidence(:,1),1,1,2);
    result = o ./ evidence_dup;
    [probabilities , class] = max(result, [], 3);
    YPredict = class;
    %Your code goes here.... 
end

function [Likelihoods] = EstimateLikelihoods(X,Mus,Sigmas,XTestSize)
Likelihoods = mynormalfn(X,Mus,Sigmas,XTestSize);
end

function p = mynormalfn(x, mu, sigma,XTestSize)
p = ones(XTestSize,20);
i= power(x-mu,2) ./ (2.*(sigma.^2));
y=exp(-i);
z=sqrt((2*pi).*(sigma.^2));
p=(1./z).*y;
end

%%%%%%%%%%%%%%%%%%%%%%%%% PART 4 Accuracy Calculation %%%%%%%%%%%%%%%%%%
%%%                 Calculates the classification accuracy           %%%
%%% Recieves:                                                        %%%
%%% YTrue    --> Testing true labels (YTest), Size = (90,1)          %%%
%%% YPredict --> Classifier predicted labels, Size = (90,1)          %%%
%%% Returns:                                                         %%%
%%% Accuracy percentage (Excepected accuracy > 95)                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function accuracy = CalculateAccuracy(YTrue, YPredict)
    
    %Hint:: you can get the 1 dimenssion of the vector by size(vec,1)
    sz = size(YTrue, 1);
    
    accuracyvec = (YTrue == YPredict);
    result = sum(accuracyvec);
    accuracy = (result/size(YTrue,1)) * 100;
    %Hint:: you can know the true predictions by creating a boolean vector 
    %using YTrue == YPredict;
   
    %Hint:: accuracy = summation(truePredictions) / #samples
end

