function [DytQ]=DQ(weitrix,nodei,Community,Community1,M)
% Community={2 4 8 12 13 14 18 20 22 1 5 6 7 11 17 };
% Community1={3 34 30 33 27 31 19 9 15 16 21 23 24 25 26 28 29 32 10 };
% weitrix=importdata('C:\Users\小岚包\Desktop\核聚类社团\网络\karate.txt');
% nodei=3;
% M=sum(sum(weitrix,2));
% M=78;
[m,n]=size(weitrix);

I=cell2mat(Community);
SUM_Community_weights=sum(weitrix(:,I),2);
% weights_Community_in=sum(SUM_Community_weights(I',:));
weights_Community_tot=sum(SUM_Community_weights);

J=cell2mat(Community1);
SUM_Community1_weights=sum(weitrix(:,J),2);
weights_Community1_tot=sum(SUM_Community1_weights);

Nodei_weights=weitrix(:,nodei);

weights_nodei_i_I=sum(Nodei_weights(I',:));
weights_nodei_i_J=sum(Nodei_weights(J',:));

weights_nodei=sum(Nodei_weights);

% DytQ=(weights_nodei_in/M)-((weights_Community_tot+weights_nodei)/(2*M))^2+(weights_Community_tot/(2*M))^2+(weights_nodei/(2*M))^2;
DytQ=(weights_nodei_i_I-weights_nodei_i_J-(weights_nodei*(weights_Community_tot-weights_Community1_tot+weights_nodei)/(2*M)))/M;


end