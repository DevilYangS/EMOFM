function  [QFunc ,KFunc,C_Community]=FinalFunc_withouNMI(Pop,Community,weitrix,model,expo,IndexMatrix,roughdata,degree,edges_num,vertex_num,Community_length)
genmodel=2;
f=logical(Pop(1,1:Community_length));
lamata=Pop(1,Community_length+1:end);

% content=cell2mat(Community);
% lamata(:,content(1,f))=[];

if sum(f)>=2
    [U ,IndexMatrix1]=Myfunction1(Community(1,f),weitrix,model,expo,IndexMatrix,roughdata);
    U=U';IndexMatrix1=IndexMatrix1';
    [U_max, ~]=max(U,[],2);
    
    if genmodel==1
        Utemp=U_max-0;
    elseif genmodel==2
%         Utemp=U_max-0.1*U_max;
%           Utemp=U_max-0;
        Utemp=U_max-lamata(1,1).*U_max;
%         Utemp=U_max-lamata';
    end
    
    U_partition=U>=Utemp;
    
    
    
    C_Community=Community(1,f);
    
    for jj=1:size(U,2)
        pati_temp=logical(U_partition(:,jj));
        pati_IndexMatrix1=IndexMatrix1(pati_temp,:)';
        C_Community{jj}= [C_Community{jj} pati_IndexMatrix1];
        pati_temp=[];
        pati_IndexMatrix1=[];
        
    end
    % C_Community{1}
    % C_Community{2}
else
    C_Community={IndexMatrix};
end

    if genmodel==2
%         KFunc=size(C_Community,2);
        KFunc=length([C_Community{:,:}])-length(unique([C_Community{:,:}]));
        [KFunc1 QFunc]=Calculate_EQ(C_Community,weitrix,degree,edges_num,vertex_num);
        QFunc=KFunc1+QFunc;
%         QFunc=2*(vertex_num-size(C_Community,2))-QFunc;
    elseif genmodel==1
        ll=sum(sum(weitrix,1));
        QFunc=compute_objective( weitrix,C_Community,ll );
        % f(1) = community_fitness_mod2(AdjMatrix,clu_assignment,ll);
        %f(2)= -Calculate_EQ(clu_assignment,AdjMatrix);
        KFunc = community_score(weitrix,C_Community,ll);
    end

end