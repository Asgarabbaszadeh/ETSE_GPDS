function [] = WriteMatrixToFileNormal(FileName,M)
 fid = fopen(FileName, 'a'); % Open for appending.
 fprintf(fid, '\n');
 x = size(M,1);
for i=1:x 
   fprintf(fid, '%-10.4f', M(i,:)); 
   fprintf(fid, '\n');
   
end
fclose(fid);
end
