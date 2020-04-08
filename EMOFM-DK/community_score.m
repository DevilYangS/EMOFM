function [ cs ] = community_score(adj_mat,clu_assignment,ll)
% Compute the community score for each partition.
% adj_mat: the adjacency matrix of the network.
% clu_assignment: the cluster label vector.

r = 1;  % a parameter in the formula of community score.
cs = 0;
clu_num = length(clu_assignment);
de=0;
for i = 1:clu_num
    s_index =clu_assignment{i};
    s = adj_mat(s_index,s_index);
    s_cardinality = length(s_index);
    if s_cardinality>0
    kins_sum = 0;
    kouts_sum = 0;
    for j = 1:s_cardinality
        kins = sum(s(j,:));
        ksum = sum(adj_mat(s_index(j),:));
        kouts = ksum - kins;
        kins_sum = kins_sum + kins;
        kouts_sum = kouts_sum + kouts;
        de=kouts_sum;
    end
    cf_s = de*1.0/(s_cardinality);
    cs = cs + cf_s;
    end
end
cs =cs;
end

