function Q = Modularity(solution,AdjacentMatrix)
%% ��ȡ������Ȩ�����ĳ�ֻ��ֵ�ģ���
%% ģ��ȵ�����ͼ��㷽������������:
%% �򻯰���Q
degree=sum(AdjacentMatrix,2);
edge_num=sum(degree)/2;
solution=solution;
m=max(solution);
Q=0;
for i=1:m
    Community_AdjMatrix=logical(AdjacentMatrix(find(solution==i),find(solution==i)));
    Degree_Matrix=degree(find(solution==i))*degree(find(solution==i))'/(2*edge_num);
    Q=Q+sum(sum(Community_AdjMatrix-Degree_Matrix,1));
    clear Community_AdjMatrix Degree_Matrix;
end
Q=Q/(2*edge_num);



end