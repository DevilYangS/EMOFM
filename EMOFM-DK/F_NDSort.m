function [FrontNO,MaxFNO] = F_NDSort(PopuObj,Operation)
%NDSort - Do non-dominated sorting on the population by ENS
%
%   FrontNO = NDSort(A,'all') does non-dominated sorting on A, where A is a
%   matrix which stores the objective values of all the individuals in the
%   population. FrontNO(i) means the NO. of front of the i-th individual.
%
%   FrontNO = NDSort(A,'half') just sorts only half of the population,
%   since there is no necessary to sort all the individuals for most MOEAs.
%   For any unsorted individual i, FrontNO(i) = inf.
%
%   FrontNO = NDSort(A,'first') just sorts the first front of the
%   population, which means only finding the non-dominated individuals.
%
%   [FrontNO,K] = NDSort(A,...) also returns the maximum NO. of fronts,
%   except for the value of inf.
%
%   Example:
%       [FrontNO,MaxFNO] = NDSort(PopuObj,'half')

%   Copyright 2015 Ye Tian

    [~,kind] = ismember(Operation,{'all','half','first'});
    [N,M]    = size(PopuObj);
    FrontNO  = inf(1,N);
    MaxFNO   = 0;
    [PopuObj,rank] = sortrows(PopuObj);
    while (kind<=1 && sum(FrontNO<inf)<N) || (kind==2 && sum(FrontNO<inf)<N/2) || (kind==3 && MaxFNO<1)
        MaxFNO = MaxFNO + 1;
        for i = 1 : N
            if FrontNO(i) == inf
                Dominated = false;
                for j = i-1 : -1 : 1
                    if FrontNO(j) == MaxFNO
                        m = 2;
                        while m <= M && PopuObj(i,m) >= PopuObj(j,m)
                            m = m + 1;
                        end
                        Dominated = m > M;
                        if Dominated || M == 2
                            break;
                        end
                    end
                end
                if ~Dominated
                    FrontNO(i) = MaxFNO;
                end
            end
        end
    end
    FrontNO(rank) = FrontNO;
end
