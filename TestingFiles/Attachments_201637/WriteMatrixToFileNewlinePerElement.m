function [] = WriteMatrixToFileNewlinePerElement(FileName, M)
 fid = fopen(FileName, 'w'); % Open for writing
for j=1:size(M,1)
    for i=1: size(M,2)
        fprintf(fid, '%.4f ', M(j,i));
        fprintf(fid, '\n');
    end
end
fclose(fid);

end