function  [QFunc ,KFunc,Num,C_Community,NMI]=FinalFunc(Pop,Community,weitrix,expo,IndexMatrix,roughdata,degree,edges_num,vertex_num,Community_length,True_Community)

genmodel=2;
f=logical(Pop(1,1:Community_length));
lamata=Pop(1,Community_length+1:end);
lambda=lamata(~f);



if sum(f)>=2
    
    [U ,IndexMatrix1]=Myfunction_similarity(Community,f,IndexMatrix,roughdata);
    U=U';IndexMatrix1=IndexMatrix1';
    [U_max, U_index]=max(U,[],2);    
    Utemp=U_max;    
    
    U_partition=U>=Utemp;
    error_index=find(sum(U_partition,2)>1);
    U_partition(error_index,:)=0;
    
    for lp=1:length(error_index)
        U_partition(error_index(lp),U_index(error_index(lp)))=1;        
    end
    
    if genmodel==2
        [U_min,~]=min(U,[],2);
        U_dist=U_max-U_min;        
        Utemp1=U_max-lambda'.*U_dist;
        para_index=find(lambda>0);        
        U_partition_temp=U>=Utemp1;        
        U_partition(para_index,:)=U_partition_temp(para_index,:);
    end
    
    % avoid the elements being equal to 0 in similarity matrix
    U_Nan_index = find(isnan(Utemp));
    zero_similarity_index = IndexMatrix1(U_Nan_index);    
    for lop=1:length(U_Nan_index)
        index_i = zero_similarity_index(lop);
        neigh_i = find(weitrix(index_i,:));
        neigh_i_trans = find(ismember(IndexMatrix1,neigh_i));
        [~,one_index]=max(sum(U_partition(neigh_i_trans,:)),[],2);
        U_partition(U_Nan_index(lop),one_index)=1;        
    end
    
    
    
    C_Community=num2cell(Community(1,f));
    
    for jj=1:size(U,2)        
        C_Community{jj}= [C_Community{jj} IndexMatrix1(logical(U_partition(:,jj)),:)'];        
    end
    
else
    C_Community={IndexMatrix};
end


NMI = Calculate_NMI( C_Community,True_Community );
Num=length([C_Community{:,:}])-vertex_num;

if genmodel==2

    A=tabulate([C_Community{:}]);
    KFunc=length(find(A(:,2)>1));
    
    [KFunc1,QFunc]=Calculate_EQ(C_Community,weitrix,degree,edges_num,vertex_num);
    QFunc=KFunc1+QFunc;
   
elseif genmodel==1
    ll=sum(sum(weitrix,1));
    
    QFunc=compute_objective( weitrix,C_Community,ll );

    KFunc = community_score(weitrix,C_Community,ll);
end
end