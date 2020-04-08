function  [C_Community,NMI]=FuncNMI(Pop,Community,weitrix,expo,IndexMatrix,roughdata,degree,edges_num,vertex_num,Community_length,True_Community)

genmodel=2;

f=logical(Pop(1,1:Community_length));
lamata=Pop(1,Community_length+1:end);

lambda=lamata(~f);



if sum(f)>=2
    

    
%     [U ,IndexMatrix1]=Myfunction1(Community(1,f),f,expo,IndexMatrix,roughdata);
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
    
    
    
    C_Community=num2cell(Community(1,f));
    
    for jj=1:size(U,2)
%         pati_temp=logical(U_partition(:,jj));
%         pati_IndexMatrix1=IndexMatrix1(pati_temp,:)';
%         C_Community{jj}= [C_Community{jj} pati_IndexMatrix1];
%         pati_temp=[];
%         pati_IndexMatrix1=[];
          C_Community{jj}= [C_Community{jj} IndexMatrix1(logical(U_partition(:,jj)),:)'];
        
    end
else
    C_Community={IndexMatrix};
end


NMI = Calculate_NMI( C_Community,True_Community );
end