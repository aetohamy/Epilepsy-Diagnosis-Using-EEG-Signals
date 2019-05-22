function [eAcc cAcc] = KNN(K)
fid   = fopen('Dataset/F.txt');
lines = textscan(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f');
F = cell2mat(lines);
fclose(fid);
fid   = fopen('Dataset/S.txt');
lines = textscan(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f');
S = cell2mat(lines);
fclose(fid);
fid   = fopen('Dataset/N.txt');
lines = textscan(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f');
N = cell2mat(lines);
fclose(fid);
fid   = fopen('Dataset/z.txt');
lines = textscan(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f');
Z = cell2mat(lines);
fclose(fid);
fid   = fopen('Dataset/O.txt');
lines = textscan(fid, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f');
O = cell2mat(lines);
fclose(fid);

trainFeatures=[F;S;N;Z;O];
onesvec=ones(1200,1);
zerosvec=zeros(800,1);
trainLables=[onesvec;zerosvec];

[XTrain, YTrain, XTest, YTest]=SplitDataN(trainFeatures,trainLables);
cTrueClassified=0;
eTrueClassified=0;
for j=1:size(XTest,1)
    D=calculateDistance(XTrain,XTest(j),"E");
    EnormalC=0;
    EupnormalC=0;
    %for E-distance
    for i=1 :K
        
        
    
        [M,I] = min(D);
        if YTrain(I)==1
            EupnormalC=EupnormalC+1;
        else
            EnormalC=EnormalC+1;
        end
    
        D(I)=NaN;
    end
    %for cosine similarity
    D=calculateDistance(XTrain,XTest(i),"C");
    CnormalC=0;
    CupnormalC=0;
    for i=1 :K
        
    
        [M,I] = max(D);
        if YTrain(I)==1
            CupnormalC=CupnormalC+1;
        else
            CnormalC=CnormalC+1;
        end
    
        D(I)=0;
    end
    
    if EnormalC>EupnormalC
        eClass=0;
    else
        eClass=1;
    end
    
    if CnormalC>CupnormalC
        cClass=0;
    else
        cClass=1;
        
    end
    if YTest(j)==eClass
        eTrueClassified=eTrueClassified+1;
    end
    if YTest(j)==cClass
        cTrueClassified=cTrueClassified+1;
    end
    
   
end

eAcc=eTrueClassified/size(XTest,1)*100
cAcc=cTrueClassified/size(XTest,1)*100

end

