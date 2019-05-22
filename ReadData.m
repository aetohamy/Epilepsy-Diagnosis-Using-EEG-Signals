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

% OPTIONAL [ADDING 0 IDENTIFIER TO UNHEALTHY PEOPLE]
label(rows*2+1:rows*5,1) = 0;
end

