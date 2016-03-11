function [N]=Circulat_to_normal(M)
 L=size(M,2);
 for j=1:size(M,1)
     for i=1: size(M,2)
         k=j+i;
         if k<=L+1
             N(j,i)=M(j,j+i-1);
         else
             N(j,i)=M(j,j+i-L-1);
         end
     end
 end
end