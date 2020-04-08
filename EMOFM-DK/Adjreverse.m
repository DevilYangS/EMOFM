function f=Adjreverse(EDGE,numVar,edge_add)
%numVar=5;
%EDGE=[1 2;1 3;2 3;3 4;3 5;4 5]; 
EDGE=EDGE+edge_add;      

f=zeros(numVar,numVar);
for i=1:numVar
    index=find(EDGE(:,1)==i);
    f(i,EDGE(index,2))=1;
    f(EDGE(index,2),i)=1;
end
end