function Community=duzhongxin2(weitrix)

% aa={'karate','football','jazz','dolphin','polbooks','blogs','netscience'};
% kkkk=1;
% weitrix=importdata(['C:\Users\小岚包\Desktop\核聚类社团\网络\' aa{kkkk} '.txt']);

degree=sum(weitrix,2);
[m,n]=size(weitrix);

DDweitrix=weitrix;
DDweitrix(find(DDweitrix==0))=inf;



% 产生等长索引
IndexMatrix=[1:m]';
AA=[IndexMatrix degree];
[B C]=sort(AA(:,2),'descend');
AA_descend=AA(C,:);



DistMatrix=inf.*ones(m,n);

FitnessMatrix=zeros(m,3);

FitnessMatrix(:,1:2)=AA_descend;

for lli=1:m
    for        llj=1:n
        
        DistMatrix(lli,llj)= DDijkstra(DDweitrix, lli, llj);
        
    end
    
end


%% 处理最大的节点
[l1 l2]=max(FitnessMatrix(:,2));
FitnessMatrix(l2,3)=max(DistMatrix(FitnessMatrix(l2,1),:));

DistMatrix(find(DistMatrix==0))=inf;
temp=FitnessMatrix(l2,1);

for llk=length(l2)+1:m
        FitnessMatrix(llk,3)= min(DistMatrix(temp,FitnessMatrix(llk,1)))+(rand-0.5);
%         FitnessMatrix(llk,3)= min(DistMatrix(temp,FitnessMatrix(llk,1)));
    if  FitnessMatrix(llk,3)>1
    temp=[temp;FitnessMatrix(llk,1)];
    end
end

plot(FitnessMatrix(:,2),FitnessMatrix(:,3),'rp')

BB=zeros(m,2);
BB(:,1)=FitnessMatrix(:,1);
BB(:,2)=FitnessMatrix(:,2).*FitnessMatrix(:,3);

% Community=num2cell(BB(1:6,1))';
Community=temp;

end