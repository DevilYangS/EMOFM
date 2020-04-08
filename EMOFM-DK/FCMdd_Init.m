function Kmedoids_index=FCMdd_Init(X,param)

sim_matrix=X;
N=size(X,2);
dissim_matrix=1-sim_matrix;
tmpmatrix=dissim_matrix;

k=param.c;
Kmedoids_index=zeros(1,k);
[minv, v]=min(sum(dissim_matrix,1));

rand('state',sum(100*clock));
v=floor(1+(rand(1)*N));

Kmedoids_index(1)=v;
iter=1;

while(iter<k)
    index=Kmedoids_index(iter);
    vindex=Kmedoids_index(1:iter);
    tmpmatrix(:,index)=-100;
    submatrix=tmpmatrix(vindex,:);
    [maxv,v]=max(min(submatrix,[],1));
    iter=iter+1;
    Kmedoids_index(iter)=v;
end

    
    
    
    




