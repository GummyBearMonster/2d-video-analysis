folders = dir('*psi*');
for j=1:size(folders,1)
    cd(folders(j,1).name)
    movefile([folders(j,1).name '.mp4'], '../videos')
    cd ..  
end