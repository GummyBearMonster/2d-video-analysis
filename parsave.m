function parsave(fname, binarizedArray,nblock,bar,gaussian_sigma,xmax,xmin,ymax,ymin,dx)
  save(fname,'binarizedArray','nblock','bar', ...
'gaussian_sigma','xmax','xmin','ymax','ymin','dx','-v7.3')
end