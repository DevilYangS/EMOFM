function PLOTFUNCTION(last,weitrix)

ll=sum(sum(weitrix,1));

for i=1:100
    C_Community=last{:,i};
     FunctionValue(i,1)=compute_objective( weitrix,C_Community,ll );     
     FunctionValue(i,2) = community_score(weitrix,C_Community,ll);
     
end
plot(FunctionValue(:,1),FunctionValue(:,2),'D')
hold on
for i=101:size(last,2)
    
    C_Community1=last{:,i};
     FunctionValue1(i,1)=compute_objective( weitrix,C_Community1,ll );     
     FunctionValue1(i,2) = community_score(weitrix,C_Community1,ll);
     
end
plot(FunctionValue1(:,1),FunctionValue1(:,2),'.')
end