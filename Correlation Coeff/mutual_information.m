% Matlab Program to find mutual information for two images stored as vectors.
% The images must contain 8-bit (0-255) integer pixels
% Requires two data vectors X,Y which must be the same length and Nx1 in size.
% Written by B. Corner--2003, University of Nebraska-Lincoln
%
% Usage: Ixy=mutual_information(X,Y)

function Ixy = mutual_information(x,y)

if size(x,2)~=1 | size(y,2)~=1
    fprintf('\n Input not a Nx1 vector \n')
    fprintf(' Program Aborting.... \n\n')
    return
end

xysize=size(x,1); %size of image X or Y....both should be the same size

%First find the mutual entropy

storage=zeros(256,256); %matrix to store ordered pairs for 8-bit imagery

%count the number of occurrences of each ordered pair
for i=1:xysize
    xtmp=x(i)+1; %increase index by 1 to prevent zeros from causing index probs
    ytmp=y(i)+1;
    
    storage(xtmp,ytmp)=storage(xtmp,ytmp)+1;
end %for i

total=sum(sum(storage)); %total number of the joint pairs

%Calculate the joint probability Pxy
Pxy=storage/total;

%Calculate the joint entropy Hxy
Hxy=0; %initialize joint ent to zero

for i=1:256
    for j=1:256
        if Pxy(i,j)~=0
            Hxy=Hxy+(-Pxy(i,j)*log2(Pxy(i,j)));
        end
    end
end

%Calculate the marginal entropies and the mutual information
Hx=entropy(x);
Hy=entropy(y);
Hxy;

Ixy=Hx+Hy-Hxy;
end