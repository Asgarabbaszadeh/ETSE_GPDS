clc;
clear all;
close all;
Column_TOTAL=4;
I_MAX=20;
%%%%%%%%%%%%%%%%%%%%%%%%%Generate and save G matrix%%%%%%%%%%%%%%%%%%%%%
G_Filename= 'Gdata.txt';
% G=randi(I_MAX,Column_TOTAL);
G=[13 12 7 9;
    2 6 17 18;
    29 10 11 21;
    5 19 4 8]
WriteMatrixToFileNewlinePerElement(G_Filename, G,0);
%%%%%%%%%%%%%%%%%%%%%%%%%Generate and save P Matrix%%%%%%%%%%%%%%%%%%%%%
P_Filename= 'Pdata.txt';
% P=randi(I_MAX,Column_TOTAL);
P=[1 2 3 ;
    5 6 7 8 ;
    9 10 11 12 ;
    13 14 15 16]
WriteMatrixToFileNewlinePerElement(P_Filename, P,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Creat CMD file%%%%%%%%%%%%%%%%
WriteCodesToCMD(P,G);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Test Results%%%%%%%%%%%%%%%%%%%%
 TestResult=ReadTestResults(Column_TOTAL);
%load MATRIX_MUL_IP_CORE_S_INT_CSV.txt
 load MatlabResults.txt; 
 aa=TestResult;
 bb=MatlabResults;
 aa-bb
% % MatlbResult=ReadMatlabResults(Column_TOTAL);
