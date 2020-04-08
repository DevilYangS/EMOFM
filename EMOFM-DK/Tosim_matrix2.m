function S=Tosim_matrix(NetM,beta,gamma)
%  S :similarity
%  DS:dissimilarity


%I=eye(size(NetM));
%S=I+beta*NetM+beta^2*NetM^2;
S=NetM+beta*NetM^2+gamma*NetM^3;
%S=inv(I-beta*NetM);
%S=S.^(1/5);

N=size(S,1);
  
  for i=1:N
      S(i,:)=S(i,:)/max(max(S));
      S(i,i)=1;
  end
  S