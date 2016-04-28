function []=WriteCodesToCMD(P,G);
fid=fopen('OperationSequenc.txt','r');
fid1=fopen('CMD.txt','w');
fid2=fopen('MatlabResults.txt','w');
%endfile='';
N=0;
for j=1:size(P,2)
    for i=1:size(P,2)
        fprintf(fid2,'%d ',P(j,i));
    end
    fprintf(fid2,'\r\n');
end
Source=0;
LM=zeros(size(P,2),size(P,2));
HM=zeros(size(P,2),size(P,2));
while(1)
    s='';
    s=fgets(fid);
    endfile=ferror(fid);
    if (strncmp(s,'LP',2))     
        code='0 0 0 0000';
        LM=P;
        A=P;
    elseif (strncmp(s,'HP',2)) 
        code='1 0 0 0000';
        HM=P;
        A=P;
    elseif (strncmp(s,'PV',2)) 
        code='0 0 0 0111';
        A(:,1)=LM*G(:,1);
        HM=A;
    elseif (strncmp(s,'PtV',3)) 
        code='0 0 1 0111';
        A(:,1)=LM*G(:,1);
        HM=A;
    elseif (strncmp(s,'RV',2)) 
        code='1 0 0 0111';
        A(:,1)=HM*G(:,1);
        LM=A;   
    elseif (strncmp(s,'RtV',2)) 
        code='1 0 1 0111';
        A(:,1)=HM*G(:,1);
        LM=A;   
    elseif (strncmp(s,'VPt',3)) 
        code='0 0 1 0110';
        A(1,:)=G(1,:)*LM;
        HM=A;

    elseif (strncmp(s,'VP',2)) 
        code='0 0 0 0110';
        A(1,:)=G(1,:)*LM;
        HM=A;
    elseif (strncmp(s,'VRt',3)) 
        code='1 0 1 0110';
        A(1,:)=G(1,:)*HM;
        LM=A;

     elseif (strncmp(s,'VR',2)) 
        code='1 0 0 0110';
        A(1,:)=G(1,:)*HM;
        LM=A;
       
    elseif (strncmp(s,'SP',2)) 
        code='0 0 0 1000';
        A=G(1,1).*LM;
        HM=A;

%%%%%%%%%%%%%%%%%%%%%%%%%%%----PtGt--PGt---PtG----PG-----%%%%%%%%%%%%%%%%%%%%%%%       
    elseif (strncmp(s,'PtGt',4))
        code='0 1 1 0001';
        A=LM'*G';
        HM=A;
    elseif (strncmp(s,'PGt',3))
        code='0 0 1 0001';
        A=LM*G';
        HM=A;
    elseif (strncmp(s,'PtG',3))
        code='0 1 0 0001';    
        A=LM'*G;
        HM=A;
    elseif (strncmp(s,'PG',2))
        code='0 0 0 0001';
        A=LM*G;
        HM=A;
%%%%%%%%%%%%%%%%%%%%%%%%----RtGt-------RGt---RtGt----RG-------%%%%%%%%%        
    elseif (strncmp(s,'RtGt',4))
        code='1 1 1 0001'; 
        A=HM'*G';
        LM=A;
   elseif (strncmp(s,'RGt',3))
        code='1 0 1 0001';
        A=HM*G';
        LM=A;
    elseif (strncmp(s,'RtG',3))
        code='1 1 0 0001';
        A=HM'*G;
        LM=A;
    elseif (strncmp(s,'RG',2))
        code='1 0 0 0001';
        A=HM*G;
        LM=A;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%-Pt+Gt---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
   elseif (strncmp(s,'Pt+Gt',5))
        code='0 1 1 0010';
        A=LM'+G';
        HM=A;
   elseif (strncmp(s,'P+Gt',4))
        code='0 0 1 0010';
        A=LM+G';
        HM=A;
    elseif (strncmp(s,'Pt+G',4))
        code='0 1 0 0010';     
        A=LM'+G;
        HM=A;
    elseif (strncmp(s,'P+G',3))
        code='0 0 0 0010';
        A=LM+G;
        HM=A;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% R+G---%%%%%%%%%%%%%%%%%%%
    elseif (strncmp(s,'Rt+Gt',5))
        code='1 1 1 0010';
        A=HM'+G';
        LM=A;

    elseif (strncmp(s,'R+Gt',4))
        code='1 0 1 0010';
        A=HM+G';
        LM=A;
    elseif (strncmp(s,'Rt+G',4))
        code='1 1 0 0010';
        A=HM'+G;
        LM=A;
    elseif (strncmp(s,'R+G',3))
        code='1 0 0 0010';
        A=HM+G;
        LM=A;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% P-G
    elseif (strncmp(s,'Pt-Gt',5))
        code='0 1 1 0011';
        A=LM'-G';
        HM=A;
    elseif (strncmp(s,'P-Gt',4))
        code='0 0 1 0011';
        A=LM-G';
        HM=A;
    elseif (strncmp(s,'Pt-G',4))
        code='0 1 0 0011';
        A=LM'-G;
        HM=A;
    elseif (strncmp(s,'P-G',3))
        code='0 0 0 0011';
        A=LM-G;
        HM=A;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% R-G
    elseif (strncmp(s,'Rt-Gt',5))
        code='1 1 1 0011';
        A=HM'-G';
        LM=A;
    elseif (strncmp(s,'R-Gt',4))
        code='1 0 1 0011';
        A=HM-G';
        LM=A;
    elseif (strncmp(s,'Rt-G',4))
        code='1 1 0 0011';
        A=HM'-G;
        LM=A;
    elseif (strncmp(s,'R-G',3))
        code='1 0 0 0011';
        A=HM-G;
        LM=A;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% G-P
    elseif (strncmp(s,'Gt-Pt',5))
        code='0 1 1 0100';
        A=G'-LM';
        HM=A;
    elseif (strncmp(s,'Gt-P',4))
        code='0 0 1 0100';
        A=G'-LM;
        HM=A;
    elseif (strncmp(s,'G-Pt',4))
        code='0 1 0 0100';
        A=G-LM';
        HM=A;
    elseif (strncmp(s,'G-P',3))
        code='0 0 0 0100';
        A=G-LM;
        HM=A;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555 G-R
    elseif (strncmp(s,'Gt-Rt',5))
        code='1 1 1 0100';
        A=G'-HM';
        LM=A;
    elseif (strncmp(s,'Rt-P',4))
        code='1 0 1 0100';
        A=G'-HM;
        LM=A;
    elseif (strncmp(s,'G-Rt',4))
        code='1 1 0 0100';
        A=G-HM';
        LM=A;
   elseif (strncmp(s,'G-R',3))
        code='1 0 0 0100';
        A=G-HM;
        LM=A;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   elseif (strncmp(s,'Pt.Gt',5))
        code='0 1 1 0101'; 
        A=LM'.*G';
        HM=A;
   elseif (strncmp(s,'P.Gt',4))
        code='0 0 1 0101';
        A=LM.*G'
        HM=A;
    elseif (strncmp(s,'Pt.G',4))
        code='0 1 0 0101'; 
        A=LM'.*G;
        HM=A;
    elseif (strncmp(s,'P.G',3))
        code='0 0 0 0101';
        A=LM.*G;
        HM=A;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     elseif (strncmp(s,'Rt.Gt',5))
        code='1 1 1 0101';
        A=HM'.*G';
        LM=A;
    elseif (strncmp(s,'R.Gt',4))
        code='1 0 1 0101';
        A=HM.*G';
        LM=A;
    elseif (strncmp(s,'Rt.G',4))
        code='1 1 0 0101';
        A=HM'.*G;
        LM=A;
     elseif (strncmp(s,'R.G',3))
        code='1 0 0 0101';
        A=HM.*G;
        LM=A;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    else
        code='1 1 1 1111';
    end
    if (strcmp(code,'1 1 1 111')==0)
        fprintf(fid1,'%s',code);
        fprintf(fid1, '\r\n');
        for j=1:size(P,2)
            for i=1:size(P,2)
                fprintf(fid2,'%d ',A(j,i));
            end
            fprintf(fid2,'\r\n');
        end
    end
    if strncmp(endfile,'At end-of-file.',15)
        break;
    end
end

fclose(fid);
fclose(fid1);
fclose(fid2);
%end