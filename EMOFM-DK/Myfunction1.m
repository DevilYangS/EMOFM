function [U_new IndexMatrix]=Myfunction1(Community,f,expo,IndexMatrix,roughdata)
[~,n]=size(Community);
ClusterData=roughdata(:,2:n);
    

%�����ĵ�
Community=Community';
center=ClusterData(Community,:);
remained=IndexMatrix(~f);

dist=distfcm1(center,ClusterData(remained,:));

% dist=pdist2(center,ClusterData(remained,:)); %���Ҿ�����ܵ����� 0

tmp=dist.^(-2/(expo-1));
U_new=tmp./(ones(n,1)*sum(tmp));



IndexMatrix=remained;
end