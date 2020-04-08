function [Q1 Q2]=Calculate_EQ(community,Adj_mat,degree,edges_num,vertex_num)
%%计算EQ的值
%community是一个细胞结构

% global vertex_num degree edges_num EP;
% %clu_num = max(clu_assignment);
% degree=sum(Adj_mat,1);
% edges_num=sum(degree,2)/2;
% vertex_num=size(Adj_mat,1);

% for i = 1:clu_num
%     s_index = find(clu_assignment == i);
%     A=[];
%     for ii=1:length(s_index)
%         A=[A EP(s_index(ii),:)];
%     end
%     s_index1=unique(A);
%     community{i}=s_index1;
%     end

%在计算EQ之前，先获得一张表，这张表示2*n，n为在community中出现的节点的个数(不包括重复的)
temp=unique([community{:,:}]);
% N=length(community);
% for i=1:N
%     a=community{i};
%     temp=[temp a];
%     temp=unique(temp);
% end;
temp2=[community{:,:}];
n=length(temp);

Table=zeros(2,n);

for j=1:n
    node=temp(j);
    num=sum(ismember(temp2,node));
    Table(1,j)=node;
    Table(2,j)=num;
end


N=length(community);

EQ=0;
temp111=0;
temp222=0;
for i=1:N
    a=community{i};
    v_num=length(a);%v_num为每个社团的节点数目
%     temp=0;
    temp11=0;
    temp22=0;
    for j=1:v_num
        v1=a(j);
        
        %计算所有社团中包含v1节点的个数
        contain_v1_num=Table(2,v1);
%         contain_v1_num=Table(2,find(Table(1,:)==v1));
%         contain_v1_num=contain(community,v1);
        for k=j+1:v_num
            v2=a(k);        
            
           
          contain_v2_num=Table(2,v2);
%             contain_v2_num=Table(2,find(Table(1,:)==v2));
            
            ttl=contain_v1_num*contain_v2_num;
%             contain_v2_num=contain(community,v2);   
            temp1=Adj_mat(v1,v2)/ttl;
            temp21=-(degree(v1)*degree(v2)/(2*edges_num))/ttl;
%             temp3=(temp1+temp2)/();
            temp11=temp11+temp1;
            temp22=temp22+temp21;
           
        end
    end
    temp111=temp111+temp11;
    temp222=temp222+temp22;
    
end
Q1=temp111/(2*edges_num);
Q2=temp222/(2*edges_num);
% EQ=(temp111+temp222)/(2*edges_num);


function num=contain_num(community,v)
%%函数功能：输出community中包含节点v的社团的个数
%community是一个细胞结构
num=0;
n=length(community);
for i=1:n
    a=community{i};
    if any(a==v)==1
        num=num+1;
    end;
end;
end
end

