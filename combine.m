function [x,output]=combine(input,adpinput)
output=input;
x=0;
for i=2:size(input,1)-1
    for j=2:size(input,2)-1
        if input(i,j)==0 && adpinput(i,j)==1 && (input(i-1,j)==1  ||input(i,j-1)==1 ||input(i,j+1)==1  ||input(i+1,j)==1 )
            
            output(i,j)=1;
            x=x+1;
        end
    end
end
end

