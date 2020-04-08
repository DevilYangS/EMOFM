% This program extracts an adjacency matrix from a pajek text (.net) file
% INPUT .net text filename, n - number of nodes in the graph
% OUTPUT: adjacency matrix, nxn, n - # nodes
% Other routines used: pajek2edgeL.m, edgeL2adj.m

function adj = pajek2adj(filename)
% pajek2adj('C:\Users\ximen\Desktop\ÍøÂç\test.txt')
fid = fopen(filename);
tline = fgetl(fid);
c = {};
i = 1;
while ischar(tline)
    c{i} = regexp(tline, '\s+', 'split');
    i = i+1;
    tline = fgetl(fid);
end
n = str2num(c{1}{1,2});
adj = zeros(n,n);
for j = n+3:length(c)
    adj(str2num(c{j}{1,1}),str2num(c{j}{1,2})) = 1;
    adj(str2num(c{j}{1,2}),str2num(c{j}{1,1})) = 1;
end
fclose(fid);
end