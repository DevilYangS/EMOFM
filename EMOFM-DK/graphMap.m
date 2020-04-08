function roughdata=graphMap(model,weitrix) % Map the given network (weitrix) into vectors with given dimention in E-space
 
   [m,n]=size(weitrix);
   D=zeros(m,n);                       
   for i=1:m                   % Construct the matrix D from the adjacent matrix of the network.
        for j=1:n
		    D(i,i)=D(i,i)+weitrix(i,j);
	    end
    end    
    
    if model==1
        Laplace=D-weitrix;           % Construct the Laplace matrix from D and A in three ways
    elseif model==2
            Laplace=inv(D)*weitrix;
    elseif model==3
                Laplace=D^(-1/2)*weitrix*D^(-1/2);
    end
    
    if model==4
         [eigenvec,eigenval]=eig(weitrix,D);
     elseif model==1|model==2|model==3
        [eigenvec,eigenval]=eig(Laplace);
    end           % Compute the eigenvectors and eigenvalues of the Laplace matrix. 
    if model==4
        roughdata=normalize_1st(eigenvec);
    else
        roughdata=eigenvec;
    end
   
  
