function result=FCMdd(sim_matrix,param)

c = param.c;

X=1-sim_matrix;
v=zeros(1,c);

[N,n]=size(X);
if exist('param.m')==1, m = param.m;else m = 2;end;
if exist('param.e')==1, e = param.m;else e = 1e-4;end;

m=1.5;
e=0.0001;


if max(size(param.c))==1,
    c = param.c;
    %index=randperm(N-1);
   index=randperm(N);
   v=FCMdd_Init(sim_matrix,param);
   d=X(:,v);  

   d = (d+1e-10).^(-1/(m-1));
   f0 = (d ./ (sum(d,2)*ones(1,c))); 
 
else
    v = param.c;    
    c = size(param.c,1);
    index=randperm(N-1);
    v0=X(index(1:c)+1,:);
    v0 = v0 + 1e-10;
end 


f = zeros(N,c);                % partition matrix
iter = 0;   
while  max(max(f0-f)) > e
  iter = iter + 1;
  
  f = f0;
  % Calculate centers
  fm = f.^m;
  
  vold=v;
  for i=1:c
    [mv,v(i)]= min(fm(:,i)'*X);
  end

   d=X(:,v);
   distout=sqrt(d);
   J(iter) = sum(sum(f0.*d));
  % Update f0
   d = (d+1e-10).^(-1/(m-1));
   f0 = (d ./ (sum(d,2)*ones(1,c)));
end

%results
result.data.f=f0;
result.data.d=distout;
result.cluster.v=v;
result.iter = iter;
result.cost = J;