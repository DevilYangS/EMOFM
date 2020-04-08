function [ cf ] = compute_objective( adj_mat,clu_assignment,ll )
% Compute the community fittness for each partition.
% adj_mat: the adjacency matrix of the network.
% clu_assignment: the cluster label vector.

a = 1;  % a parameter in the formula of community fittness.
cf = 0;
ec=0;
numVar=size(adj_mat,1);
clu_num = length(clu_assignment);
for i = 1:clu_num
    s_index =clu_assignment{i};
    s = adj_mat(s_index,s_index);
    s_cardinality = length(s_index);
    if s_cardinality>0
    kins_sum = 0;
    kouts_sum = 0;
    for j = 1:s_cardinality
        kins = sum(s(j,:));
        %ksum = sum(adj_mat(s_index(j),:));
        %kouts = ksum - kins;
        kins_sum = kins_sum + kins;
        %kouts_sum = kouts_sum + kouts;
        ec=kins_sum;
    end
    cf_s = ec*1.0/(s_cardinality);
    cf = cf + cf_s;
    end
end

cf = 2*(numVar-length(clu_assignment))-cf;
end

