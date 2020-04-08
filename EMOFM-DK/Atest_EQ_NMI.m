networkfile1={'karate','dolphin','football','polbooks','jazz','netscience','protein-protein','blogs','Y2H','PPI_D2'};
fid = fopen('result_NMI.txt','w');
Qov=[];
gNMI=[];
for iii=1:10
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
    networkfile = sprintf('RealWorld/%s.txt',networkfile1{iii});
    real_path=sprintf('RealWorld/real_%s.txt',networkfile1{iii});
    AdjMatrix=load(networkfile);
    if min(min(AdjMatrix))==0
        add=1;
    else
        add=0;
    end
    if size(AdjMatrix,2)==2
        M=load(networkfile)+add;
        numVar=single(max(M(:,2)));
        AdjMatrix=Adjreverse(M,numVar,0);
        degree=sum(AdjMatrix);
        index=find(degree==0);
        a=setdiff(1:length(AdjMatrix),index);
        AdjMatrix=AdjMatrix(a,a);
        numVar=length(AdjMatrix);
    end
    if iii<9
        Datalable=load(real_path);
        %Datalable([29 91])=11;
    else
        Datalable=zeros(1,numVar);
    end
    numVar=length(AdjMatrix);
    if length(find(Datalable==0))==0
        clu_file_real=zeros(max(Datalable),numVar);
        for i=1:max(Datalable)
            real_community{i}=find(Datalable==i);
            clu_file_real(i,1:length(real_community{i}))=real_community{i};
        end
    else if iii<=8
            clu_file_real=zeros(1,numVar);
            real_community{1}=1:numVar;
            clu_file_real(1,1:length(real_community{1}))=real_community{1};
        else
            
            real_string=importdata(real_path,'r');
            clu_file_real=zeros(length(real_string),numVar);
            for i=1:length(real_string)
                if length(str2num(char((real_string(i)))))>0
                    A=str2num(char((real_string(i))))+1;
                    real_community{i}=A(find(A>0));
                    str2num(char((real_string(i))))+1;
                    clu_file_real(i,1:length(real_community{i}))=real_community{i};
                end
            end
        end
    end
    True_Community=real_community;
    weitrix=AdjMatrix;
    [m,n]=size(weitrix);
    
    IndexMatrix=1:m;
    
     Community=[1:m];
     
        Community_length=m;
        %% 初始化种群  即相关参数设置
        model=1;% 拉普拉斯矩阵产生方式
        expo=2;%
        
        degree=sum(weitrix,1);
        edges_num=sum(degree,2)/2;
        vertex_num=size(weitrix,1);
        
%         roughdata=graphMap(model,weitrix);
%         
EQfit=[];
NMIfit=[];
for kkp=1:3

    
    root1=['./result/Community',num2str(kkp),'/',networkfile1{iii}];
%         root1=sprintf('./result/Community/%s',networkfile1{iii});
        Last_com=importdata([root1,'/community.mat']);
        
        for llo=1:length(Last_com)
            [w1,w2]=Calculate_EQ(Last_com{llo},weitrix,degree,edges_num,vertex_num);
            fitness(llo,1)=w1+w2;
            NMI(llo,1) = Calculate_NMI( Last_com{llo},True_Community );
        end
        
    EQfit(kkp,1)=max(fitness);
    NMIfit(kkp,1)=max(NMI);
end
TT=[max(EQfit) mean(EQfit) std(EQfit);max(NMIfit) mean(NMIfit) std(NMIfit)]
networkfile1{iii}
        aaaaa=1;
end