function [ D ] = calculateDistance( trainFeatures,value,S)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
valueVec = repmat(value,1500,1);
if S=="E"
    
    D=trainFeatures-valueVec;
    D=D.^2;
    D=sum(D,2);
    D=sqrt(D);
else 
    
    

    temp=trainFeatures;
    temp=temp.^2;
    temp=sum(temp,2);
    temp=sqrt(temp);
    
    temp2=valueVec;
    temp2=temp2.^2;
    temp2=sum(temp2,2);
    temp2=sqrt(temp2);
    
    
    D=trainFeatures.*valueVec;
    D=sum(D,2);
    magMult=temp.*temp2;
    D=D./magMult;
    
    


end

