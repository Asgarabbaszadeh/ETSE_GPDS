function [] = WriteMatrixToFileNewlinePerElement(FileName, M,Save_method)
 fid = fopen(FileName, 'w'); % Open for writing
 if Save_method==0
     fprintf(fid, '%d ', size(M,1));
     fprintf(fid, '\r\n');
     fprintf(fid, '%d ', size(M,2));
     fprintf(fid, '\r\n');
 end
     for j=1:size(M,1)
         for i=1: size(M,2)
             fprintf(fid, '%d ', M(j,i));
             fprintf(fid, '\r\n');
         end
     end
%  else
%      L=1;
%      for j=1:size(M,1)
%          if j==1
%              L=1;
%          else
%              L=size(M,1)-j+2;
%          end
%          for i=1: size(M,2)
%              if L>size(M,2)
%                  L=1;
%              end
%              fprintf(fid, '%d ', M(j,L));
%              fprintf(fid, '\r\n');
%              L=L+1;
%          end
%      end
%  end
%      
fclose(fid);

end




 
