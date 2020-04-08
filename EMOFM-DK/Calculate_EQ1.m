function EQ=Calculate_EQ1(community,Adj_mat,degree,edges_num,vertex_num)
%%����EQ��ֵ
%community��һ��ϸ���ṹ



% for i = 1:clu_num
%     s_index = find(clu_assignment == i);
%     A=[];
%     for ii=1:length(s_index)
%         A=[A EP(s_index(ii),:)];
%     end
%     s_index1=unique(A);
%     community{i}=s_index1;
%     end

%�ڼ���EQ֮ǰ���Ȼ��һ�ű����ű�ʾ2*n��nΪ��community�г��ֵĽڵ�ĸ���(�������ظ���)
temp=[];
N=length(community);
for i=1:N
    a=community{i};
    temp=[temp a];
    temp=unique(temp);
end;
n=length(temp);
Table=zeros(2,n);

for j=1:n
    node=temp(j);
    num=contain_num(community,node);
    Table(1,j)=node;
    Table(2,j)=num;
end;


N=length(community);
EQ=0;
for i=1:N
    a=community{i};
    v_num=length(a);%v_numΪÿ�����ŵĽڵ���Ŀ
    temp=0;
    for j=1:v_num
        v1=a(j);
        %�������������а���v1�ڵ�ĸ���
        contain_v1_num=Table(2,find(Table(1,:)==v1));
%         contain_v1_num=contain(community,v1);
        for k=j+1:v_num
            v2=a(k);
            contain_v2_num=Table(2,find(Table(1,:)==v2));
%             contain_v2_num=contain(community,v2);   
            temp1=Adj_mat(v1,v2)-(degree(v1)*degree(v2)/(2*edges_num));
            temp2=temp1/(contain_v1_num*contain_v2_num);
            temp=temp+temp2;
        end;
    end;
    EQ=EQ+temp;
end;
EQ=EQ/(2*edges_num);


function num=contain_num(community,v)
%%�������ܣ����community�а����ڵ�v�����ŵĸ���
%community��һ��ϸ���ṹ
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

