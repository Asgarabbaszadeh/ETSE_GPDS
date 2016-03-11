function []=WriteCodesToCMD();
fid=fopen('OperationSequenc.txt','r');
fid1=fopen('CMD.txt','w');
%endfile='';
i=0;
while(1)
    i=i+1;
    s='';
    s=fgets(fid)
    endfile=ferror(fid)
    if (strncmp(s,'LP',2))     
       code='0 0 0 000';
    elseif (strncmp(s,'Pt*Gt',5))
        code='0 1 1 001';
    elseif (strncmp(s,'P*Gt',4))
        code='0 0 1 001';
    elseif (strncmp(s,'Pt*G',4))
        code='0 1 0 001';    
    elseif (strncmp(s,'P*G',3))
        code='0 0 0 001';
    elseif (strncmp(s,'Rt*Gt',5))
        code='1 1 1 001'; 
   elseif (strncmp(s,'R*Gt',4))
        code='1 0 1 001';
    elseif (strncmp(s,'Rt*G',4))
        code='1 1 0 001';
    elseif (strncmp(s,'R*G',3))
        code='1 0 0 001';
   elseif (strncmp(s,'Pt+Gt',5))
        code='0 1 1 010';
   elseif (strncmp(s,'P+Gt',4))
        code='0 0 1 010';
    elseif (strncmp(s,'Pt+G',4))
        code='0 1 0 010';     
    elseif (strncmp(s,'P+G',3))
        code='0 0 0 010';
    elseif (strncmp(s,'Rt+Gt',5))
        code='1 1 1 010';
   elseif (strncmp(s,'R+Gt',4))
        code='1 0 1 010';
    elseif (strncmp(s,'Rt+G',4))
        code='1 1 0 010';
    elseif (strncmp(s,'R+G',3))
        code='1 0 0 010';
    elseif (strncmp(s,'Pt-Gt',5))
        code='0 1 1 011';
    elseif (strncmp(s,'P-Gt',4))
        code='0 0 1 011';
    elseif (strncmp(s,'Pt-G',4))
        code='0 1 0 011';
    elseif (strncmp(s,'P-G',3))
        code='0 0 0 011';
    elseif (strncmp(s,'Rt-Gt',5))
        code='1 1 1 011';
    elseif (strncmp(s,'R-Gt',4))
        code='1 0 1 011';
    elseif (strncmp(s,'Rt-G',4))
        code='1 1 0 011';
    elseif (strncmp(s,'R-G',3))
        code='1 0 0 011';
    elseif (strncmp(s,'Gt-Pt',5))
        code='0 1 1 100';
    elseif (strncmp(s,'Gt-P',4))
        code='0 0 1 100';
    elseif (strncmp(s,'G-Pt',4))
        code='0 1 0 100';
    elseif (strncmp(s,'G-P',3))
        code='0 0 0 100';
    elseif (strncmp(s,'Gt-Rt',5))
        code='1 1 1 100';
    elseif (strncmp(s,'Rt-P',4))
        code='1 0 1 100';
    elseif (strncmp(s,'G-Rt',4))
        code='1 1 0 100';
   elseif (strncmp(s,'G-R',3))
        code='1 0 0 100';
   elseif (strncmp(s,'Pt.Gt',5))
        code='0 1 1 101'; 
   elseif (strncmp(s,'P.Gt',4))
        code='0 0 1 101';
    elseif (strncmp(s,'Pt.G',4))
        code='0 1 0 101'; 
    elseif (strncmp(s,'P.G',3))
        code='0 0 0 101';
     elseif (strncmp(s,'Rt.Gt',5))
        code='1 1 1 101';
    elseif (strncmp(s,'R.Gt',4))
        code='1 0 1 101';
    elseif (strncmp(s,'Rt.G',4))
        code='1 1 0 101';
     elseif (strncmp(s,'R.G',3))
        code='1 0 0 101';  
    end
    fprintf(fid1,'%s',code);
    fprintf(fid1, '\n');
    if strncmp(endfile,'At end-of-file.',15)
        break;
    end
end
fclose(fid);
fclose(fid1);
%end