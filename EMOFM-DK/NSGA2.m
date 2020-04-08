function [Population,FunctionValue]=NSGA2(Population,FunctionValue,Generations,N,Community_length,Boundary,Community,weitrix,expo,IndexMatrix,roughdata,genmodel,degree,edges_num,vertex_num,Num,MaskCode)
        FrontValue                   = F_NDSort(FunctionValue,'half');
        CrowdDistance                = F_distance(FunctionValue,FrontValue);
        Max_K=Community_length;
        for Gene = 1 : Generations
            
            MatingPool            = F_mating(Population,FrontValue,CrowdDistance);
           
            Offspring_kore=MatingPool(:,1:Community_length);            
            Offspring_lamata=P_generator(MatingPool(:,Community_length+1:end),Boundary,'Real',N);
            Offspring_lamata=Offspring_lamata.*MaskCode;
            Offspring=[Offspring_kore Offspring_lamata];
           
            
            Func=zeros(N,2);            
            for jj=1:size(Offspring,1)
                [Func(jj,1), Func(jj,2)]=FunValue1(Offspring(jj,:),Community,weitrix,expo,IndexMatrix,roughdata,genmodel,degree,edges_num,vertex_num,Community_length);                 
            end
            
            
            Func(:,1)=1-Func(:,1);
            Func(:,2)=-Func(:,2);
            
            Population            = [Population;Offspring];
            FunctionValue         = [FunctionValue;Func];
            
            
            
            [FrontValue,MaxFront] = F_NDSort(FunctionValue,'half');            
            CrowdDistance         = F_distance(FunctionValue,FrontValue);           
            Next        = zeros(1,N);
            NoN         = numel(FrontValue,FrontValue<MaxFront);
            Next(1:NoN) = find(FrontValue<MaxFront);
            Last          = find(FrontValue==MaxFront);
            [~,Rank]      = sort(CrowdDistance(Last),'descend');
            Next(NoN+1:N) = Last(Rank(1:N-NoN));          
            Population    = Population(Next,:);
            FunctionValue=FunctionValue(Next,:);
            FrontValue    = FrontValue(Next);
            CrowdDistance = CrowdDistance(Next);
            [~,MaxFront] = F_NDSort(FunctionValue,'all');

            
            
            clc;
            fprintf(['NSGA-II',' Complete %4s%%, Speed %5ss, MaxFront %d\n'],...
                num2str(roundn(((0.05*Gene/Generations)+(Num-1)*0.05+0.5)*100,-4)),...
                num2str(roundn(toc,-2)),...
                MaxFront);
            
        end

end