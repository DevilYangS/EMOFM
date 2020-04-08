function Q = Modularity(solution,AdjacentMatrix)
%% 获取无向无权网络的某种划分的模块度
%% 模块度的提出和计算方法见如下文献:
%% 简化版求Q
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