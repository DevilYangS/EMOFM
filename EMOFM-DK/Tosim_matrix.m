function S=Tosim_matrix(NetM,beta)
%  S :similarity
%  DS:dissimilarity

degree=sum(NetM);         % degree
Net_size=length(degree);
LL=diag(degree)-NetM;     % Laplacian matrix

N=expm(-beta*LL);         % Diffusion kernel         
dd=diag(N);

% normalization
for i=1:Net_size
    for j=1:Net_size
     S(i,j)=N(i,j)/sqrt(dd(i)*dd(j));        
   end
end
  
