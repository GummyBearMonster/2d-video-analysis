function y=isEdge(input,i,j)
y=false;
if input(i,j)==0
    if input(i-1,j)==1 && input(i+1,j)==1 && (input(i,j+1)==0||input(i+1,j+1)==0||input(i-1,j+1)==0) && (input(i,j-1)==0||input(i+1,j-1)==0||input(i-1,j-1)==0) 
        y=true;
    elseif input(i,j-1)==1 && input(i,j+1)==1 && (input(i-1,j)==0||input(i-1,j+1)==0||input(i-1,j-1)==0) && (input(i+1,j-1)==0||input(i+1,j)==0||input(i+1,j+1)==0) 
        y=true;
    elseif input(i,j-1)==1 && input(i-1,j)==1 && input(i-1,j-1)==0 && (input(i+1,j-1)==0 || input(i-1,j+1)==0 || input(i+1,j+1)==0 || input(i,j+1)==0 || input(i+1,j)==0)
        y=true;
    elseif input(i,j-1)==1 && input(i+1,j)==1 && input(i+1,j-1)==0 && (input(i-1,j-1)==0 || input(i-1,j+1)==0 || input(i+1,j+1)==0 || input(i,j+1)==0 || input(i-1,j)==0)
        y=true;
    elseif input(i,j+1)==1 && input(i-1,j)==1 && input(i-1,j+1)==0 && (input(i-1,j-1)==0 || input(i+1,j-1)==0 || input(i+1,j+1)==0 || input(i,j-1)==0 || input(i+1,j)==0)
        y=true;
    elseif input(i,j+1)==1 && input(i+1,j)==1 && input(i+1,j+1)==0 && (input(i-1,j-1)==0 || input(i+1,j-1)==0 || input(i-1,j+1)==0 || input(i,j-1)==0 || input(i-1,j)==0)
        y=true;
    end
end


end