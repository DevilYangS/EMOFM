
function MAIN(Algorithm, Problem,M,Run)
%% this version is under NSGA-II framework, which has no difference with AR-MOEA
clear all;
clc;
format compact;


networkfile1={'ENZYMES_g163','karate','Ring','Y-shape','Ring K4','dolphin','football','polbooks','SFI','jazz','Y2H','PPI_D2'};
    % data process is complex to adjust , so the last two networks should
    % be 'Y2H','PPI_D2', the others can be arbitrarily adjusted

Trail=2; % number of runs

kind=1; % 1 for networkfile1, 2 for your LFR


for iii=2:14%length(networkfile1)
    
    %% data process, aim to get the Adjacency matrix and  corrsponding real communities if it exists
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
    if kind==1
        networkfile = sprintf('RealWorld/%s.txt',networkfile1{iii});
        real_path=sprintf('RealWorld/real_%s.txt',networkfile1{iii});
        AdjMatrix=load(networkfile);
        if min(min(AdjMatrix))==0
            add=1;
        else
            add=0;
        end
        if size(AdjMatrix,2)==2
            M=load(networkfile)+add;
            numVar=single(max(M(:,2)));
            AdjMatrix=Adjreverse(M,numVar,0);
            degree=sum(AdjMatrix);
            index=find(degree==0);
            a=setdiff(1:length(AdjMatrix),index);
            AdjMatrix=AdjMatrix(a,a);
            numVar=length(AdjMatrix);
        end
        if iii<length(networkfile1)-1
            Datalable=load(real_path);            
        else
            Datalable=zeros(1,numVar);
        end
        numVar=length(AdjMatrix);
        if length(find(Datalable==0))==0
            clu_file_real=zeros(max(Datalable),numVar);
            for i=1:max(Datalable)
                real_community{i}=find(Datalable==i);
                clu_file_real(i,1:length(real_community{i}))=real_community{i};
            end
        else if iii<=length(networkfile1)-2
                clu_file_real=zeros(1,numVar);
                real_community{1}=1:numVar;
                clu_file_real(1,1:length(real_community{1}))=real_community{1};
            else
                
                real_string=importdata(real_path,'r');
                clu_file_real=zeros(length(real_string),numVar);
                for i=1:length(real_string)
                    if length(str2num(char((real_string(i)))))>0
                        A=str2num(char((real_string(i))))+1;
                        real_community{i}=A(find(A>0));
                        str2num(char((real_string(i))))+1;
                        clu_file_real(i,1:length(real_community{i}))=real_community{i};
                    end
                end
            end
        end
        
    else % for LFR    
        
        networkfile= sprintf('LFR/network.dat');
        real_path=sprintf('LFR/community.dat');        
        AdjMatrix = pajek2adj(networkfile);
        real_community=LFR_community2community(real_path);
    end
    
    %% 
    
    
    EQA=[];
    EQB=[];
    EQC=[];
    EQE=[];
    NMIA=[];
    NMIB=[];
    NMIE=[];
    
    
    for tril =1:Trail
        
        % a simple example for testing
        %      AdjMatrix=...
        %         [0 1 1 1 0 0 0;...
        %          1 0 1 1 0 0 0;...
        %          1 1 0 1 0 0 0;...
        %          1 1 1 0 1 1 0;...
        %          0 0 0 1 0 1 1;...
        %          0 0 0 1 1 0 1;...
        %          0 0 0 0 1 1 0];
        %      real_community={[1 2 3 4],[4 5 6 7]}
        
        tic;
        Generations=100;
        N=100;  
        True_Community=real_community;
        weitrix=AdjMatrix;
        [m,n]=size(weitrix);
        degree=sum(weitrix,1);
        edges_num=sum(degree,2)/2;
        vertex_num=size(weitrix,1);
 
        IndexMatrix=1:m;        
        Community=[1:m];        
        Community_length=m;
        
        %%  stage 1
        %% Initialzing the population and setting some parameters
        
        expo=2;% unvalid in this version
        roughdata = Tosim_matrix(weitrix,1);   % get similarity matrix
        
        
        [Population1]=Initial_Population(N,Community_length,weitrix); % designed population initialization strategy
        %         Population1=randi([0 1],N,Community_length); % random population initialization 
   
        
        
        Population2=zeros(N,m);%  fuzzy threshold        
        minvalue1  =  0;      
        maxvalue1  =  1.0;   
        Boundary  =  [maxvalue1;minvalue1];   
        Boundary=repmat(Boundary,1,m);%Boundary for fuzzy threshold
       
        
        Population=[Population1 Population2];  % completed population 
        
        
        
        
        %% calculate objectives value
        genmodel=1; % decide which kind of objectives are used
        
        Func=zeros(N,2);
        for jj=1:size(Population,1)
            [Func(jj,1),Func(jj,2)]=FunValue1(Population(jj,:),Community,weitrix,expo,IndexMatrix,roughdata,genmodel,degree,edges_num,vertex_num,Community_length);
        end
        
        % get front value and CrowdDistance for the  selection of  mating pool
        FunctionValue=Func;        
        FrontValue                   = F_NDSort(FunctionValue,'half');
        CrowdDistance                = F_distance(FunctionValue,FrontValue);     
        
      
        for Gene = 1 :Generations            
             % get mating pool    
            MatingPool            = F_mating(Population,FrontValue,CrowdDistance); 
            % generating offspring    
            Offspring_kore = P_generator(MatingPool(:,1:Community_length),Boundary,'Binary',N );            
            Offspring_lamata=MatingPool(:,Community_length+1:end);
            Offspring=[Offspring_kore Offspring_lamata];
            % computing objectives 
            Func=zeros(N,2);
            for jj=1:size(Offspring,1)
                [Func(jj,1), Func(jj,2)]=FunValue1(Offspring(jj,:),Community,weitrix,expo,IndexMatrix,roughdata,genmodel,...
                    degree,edges_num,vertex_num,Community_length);                
            end
            
            %
            Population            = [Population;Offspring];
            FunctionValue         =[FunctionValue;Func];            
            
            %% environment selection
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
           %%
            
            clc;
            fprintf(['NSGA-II',' Complete %4s%%, Speed %5ss, MaxFront %d\n'],...
                num2str(roundn(Gene/Generations*100,-1)),...
                num2str(roundn(toc,-2)),...
                MaxFront);
            
        end
       
        
        
      
        
        %% calculate objectives value 
        genmodel=2;% computing Qov and number of overlapping nodes
        
        Func=zeros(size(Population,1),2);        
        for jj=1:size(Population,1)            
            [Func(jj,1) ,Func(jj,2),Num(jj,1),C_Community{jj,1},NMI(jj,1)]=FinalFunc(Population(jj,:),Community,weitrix,expo,IndexMatrix,roughdata,degree,edges_num,vertex_num,Community_length,True_Community);            
        end
        
        % rank the population in terms of Qov for stage 2
        [NL NI]=sort(Func(:,1),'descend');
        Func=Func(NI,:);
        max(NMI)        
        Func(:,1)=1-Func(:,1);
        Func(:,2)=Func(:,2);    
               
        FunctionValue=Func;
        Population=Population(NI,:);
        
        New_Population=[];
        New_FunctionValue=[];

        
        
        %%  stage 2
        
        for llpo=1:10 % just top 10 solutions are considered (all no-dominated solutions are utilized in algorithm) ,
                      %optimize the more potential solutions with respect to Qov or other metric 
            
            %ignore unreasonable results
            if sum(Population(llpo,1:Community_length))<=1
                break;
            end
            
            % initialization for sub-population
            [NewPop,MaskCode,Bound]=LocalKmeans(Population(llpo,:),Community,weitrix,expo,IndexMatrix,roughdata,Community_length);
            
            Boundary(1,:)=Bound;
            TN=NewPop(:,Community_length+1:end);
            TN=TN.*MaskCode;
            NewPop(:,Community_length+1:end)=TN;
            
            Func=[];
            for lloo=1:size(NewPop,1)
                [Func(lloo,1), Func(lloo,2)]=FunValue1(NewPop(lloo,:),Community,weitrix,expo,IndexMatrix,roughdata,genmodel,degree,edges_num,vertex_num,Community_length);
            end
            
            % transform to the minimization problem
            Func(:,1)=1-Func(:,1);
            Func(:,2)=-Func(:,2);
            
            
            FunctionValue=Func;            
            N=size(NewPop,1);
            subsize=N;
            Num=llpo;
            Generations=100;
            % optimization process for thresholds
            [New_Population((llpo-1)*subsize+1:llpo*subsize,:),New_FunctionValue((llpo-1)*subsize+1:llpo*subsize,:)]=NSGA2(NewPop,FunctionValue,Generations,N,Community_length,Boundary,...
                Community,weitrix,expo,IndexMatrix,roughdata,genmodel,degree,edges_num,vertex_num,Num,MaskCode);
            
        end
               
        NonDominated       =    P_sort(New_FunctionValue,'first')==1;%%寻找非支配解
        PopulationNon    =    New_Population(NonDominated,:);        
        FunctionValueNon =  New_FunctionValue(NonDominated,:);        
        
        
        FunctionValueNon(:,1)=1-FunctionValueNon(:,1);
        FunctionValueNon(:,2)=-FunctionValueNon(:,2);        
                
        for li=1:size(New_Population,1)
            [Q(li,1), Q(li,2),Vertex_Num(li,1),CC{li,1},NMIlast(li,1)]=FinalFunc(New_Population(li,:),...
                Community,weitrix,expo,IndexMatrix,roughdata,degree,edges_num,vertex_num,Community_length,True_Community);            
        end
        

        %% improve communities by adjusting unreasonable nodes or overlapping nodes
        %% the unreasonable communities are brought by the less accurate similarity matrix 
        
        temp  = C_Community(NI(1:10)); % 
        last={temp{:} CC{:}}; % select potential solutions for adjusting
        
        M=edges_num;
        preoverlap=[]; % overlapping nodes by Pre-processing
        for llk=1:length(last)
            [Out_Community{llk,1},over_community{llk,1}]=adjust(last{llk},weitrix,preoverlap,M);
        end
        
        
        %% compute Qov NMI 
        Last_com={C_Community{:} ,CC{:},Out_Community{:}, over_community{:}};
        
        for llo=1:length(Last_com)
            [w1,w2]=Calculate_EQ(Last_com{llo},weitrix,degree,edges_num,vertex_num);
            fitness(llo,1)=w1+w2;
            NMI(llo,1)=Calculate_NMI( Last_com{llo},True_Community );
        end
        
        EQA= [EQA max(fitness(1:length(C_Community)))];        
        EQB=[EQB max(fitness(length(C_Community):length(C_Community)+length(CC)))];   
        EQC=[EQC max(fitness(201:200+length(last)))];
        EQE=[EQE max(fitness)];
        
        NMIA=[NMIA max(NMI(1:length(C_Community)))];
        NMIB=[NMIB max(NMI(length(C_Community):length(C_Community)+length(CC)))];
        NMIE=[NMIE max(NMI)];        
        
        %% saving
        root1=sprintf('./result/Community/%s',networkfile1{iii});
        if ~isdir(root1) %判断路径是否存在
            mkdir(root1);
        end
        save([root1,'/community_',num2str(tril),'.mat'],'Last_com');        
        clear Last_com;
        
        
    end
    
    f1=[EQA sum(EQA)/length(EQA)];
    f2=[NMIA sum(NMIA)/length(NMIA)];
    
    f3=[EQB sum(EQB)/length(EQB)];
    f4=[NMIB sum(NMIB)/length(NMIB)];
    
    f5=[EQE sum(EQE)/length(EQE)];
    f6=[NMIE sum(NMIE)/length(NMIE)];
    
    S_F_name=sprintf('results/%s.txt',networkfile1{iii});
    
    savedata1(S_F_name,[f1;f2;f3;f4;f5;f6]);
end

end
