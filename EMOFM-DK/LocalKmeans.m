function  [new_pop,MaskCode,Boundary]=LocalKmeans(Pop,Community,weitrix,expo,IndexMatrix,roughdata,Community_length)

    f=logical(Pop(1,1:Community_length));
    lamata=Pop(1,Community_length+1:end);

    lambda=lamata(~f);
    
    [U ,IndexMatrix1]=Myfunction_similarity(Community,f,IndexMatrix,roughdata);
    
    U=U';
    IndexMatrix1=IndexMatrix1';
    [U_max, ~]=max(U,[],2);
    [U_min, ~]=min(U,[],2);
    %% 得到community及其 bianjie掩码
   Label_community=zeros(1,Community_length);
    if sum(f)>1
        MaskCode=zeros(1,Community_length);
        degree=sum(weitrix,2);
        U_partition=U>=U_max; 
        C_Community=num2cell(Community(1,f));
        
        for jj=1:size(U,2)
            Temp= unique([C_Community{jj} IndexMatrix1(logical(U_partition(:,jj)),:)']);%C_Community{jj}
            Label_community(Temp)=jj;
            MaskCode(Temp(degree(Temp)~=sum(weitrix(Temp,Temp),2)))=1;
        end
    else
         C_Community={IndexMatrix};
    end
    MaskCode(f)=0;
   %% 计算Boundary
   Boundary=zeros(1,Community_length);
    for ip=1:Community_length
        if MaskCode(ip)==1
%           label=Label_community(ip);
            num=length(unique(Label_community(logical(weitrix(ip,:)))))-1;
            S_i=sort( U(IndexMatrix1==ip,:),'descend');
            Boundary(ip)=(max(S_i)- S_i(num+1))/(max(S_i)-min(S_i));
            
        end
        
    end
   
   clear num;
    
    %% 阈值 
    
    U_dist=U_max-U_min;
    
    U_cluster_yuzhi=[];
    
    for i=1:size(U,1)
        if isnan(U(i,1)')
            continue;
        end
        cluster=kmeans(U(i,:)',2)';
        cluster1=U(i,find(cluster==1));
        
         if sum(ismember(cluster1,U_max(i,:)))
             [yuzhi,~]=min(cluster1,[],2);
             
         else
             cluster2=U(i,find(cluster==2));
             [yuzhi,~]=min(cluster2,[],2);
             
         end
         U_cluster_yuzhi(i,1)=yuzhi;
    end
  
    
    U_cluster_yuzhi=1-(U_cluster_yuzhi-U_min)./U_dist;
    U_cluster_yuzhi(isnan(U_cluster_yuzhi)) = rand;
    
    lamata(~f)=U_cluster_yuzhi;
    
    offspringpop=[Pop(1,1:Community_length) zeros(1,Community_length)];
    
    
    lambda1=zeros(1,Community_length);
    Cnum=sum(f);
    for i=1:6
        lambda1=zeros(1,Community_length);
        for j=1:Community_length
            if f(j)==1
                lambda1(j)=0;
            else 
                num=randi(Cnum);
              [Usorti]=sort( U(IndexMatrix1==j,:),'descend');
              lambda1(j)=(max(Usorti)- Usorti(num))/(max(Usorti)-min(Usorti));
                
            end
           
        end
        lambda1(lambda1>Boundary)=Boundary(lambda1>Boundary);
        
         Pop1(i,:)=[Pop(1,1:Community_length) lambda1 ];
    end
    offspringpop1=Pop1;
    offspring_pop=[offspringpop;offspringpop1];
   
%     if sum(f)==2
        
%     else
    new_pop=[Pop(1,1:Community_length) lamata;Pop(1,1:Community_length) Boundary;Pop(1,1:Community_length) Boundary;offspring_pop];
%     end

end