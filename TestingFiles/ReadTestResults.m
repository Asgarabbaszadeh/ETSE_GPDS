function [OutMatrix]=ReadTestResults(Column_Total)
 load MATRIX_MUL_IP_CORE_S_INT_CSV.txt;
 temp=MATRIX_MUL_IP_CORE_S_INT_CSV;
 M=size(temp,1);
 N=size(temp,2);
 MatrixNumbers=M/Column_Total
 OutMatrix=zeros(size(temp,1),size(temp,2));
 for i=1:MatrixNumbers
    OutMatrix((i-1)*Column_Total+1:i*Column_Total,:)=Circulat_to_normal(temp((i-1)*Column_Total+1:i*Column_Total,:));
 end
end