function [U_new IndexMatrix]=Myfunction1(Community,f,expo,IndexMatrix,roughdata)
[~,n]=size(Community);
ClusterData=roughdata(:,2:n);
    

%找中心点
Community=Community';
center=ClusterData(Community,:);
remained=IndexMatrix(~f);

dist=distfcm1(center,ClusterData(remained,:));

% dist=pdist2(center,ClusterData(remained,:)); %余弦距离可能导致有 0

tmp=dist.^(-2/(expo-1));
U_new=tmp./(ones(n,1)*sum(tmp));



IndexMatrix=remained;
end