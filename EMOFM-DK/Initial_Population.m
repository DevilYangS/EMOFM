function [Population]=Initial_Population(N,pop_length,weitrix)
% Community= duzhongxin2(weitrix);

Community= duzhongxin(weitrix,0.3);
Community=cell2mat(Community);
Population=zeros(N,pop_length);

Num=2;

for i=1:N
    if i<round(N/2)
        Population(i,unique(Community(randi([1,length(Community)],1,randi([2,length(Community)],1,1))))) = 1;
    else
        Population(i,randi([1,pop_length],1,2))=1;
    end
end


end