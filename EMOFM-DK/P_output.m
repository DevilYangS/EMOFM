
function P_output (Population,time,Algorithm,Problem,M,Run,Indicator1,Indicator2)
% 算法结果的格式化输出, 包括计算评价指标值,绘制图形,保存结果等
% 输入: Population, 算法的结果(决策空间)
%       time,       算法的耗时
%       Algorithm,  算法名称
%       Problem,    测试问题名称
%       M,          测试问题维数
%       Run,        运行次数编号

    if nargin < 7
        flag = 0;
    elseif nargin == 7
        flag    = 1;
        IGD_Pop = Indicator1;
    elseif nargin == 8
        flag    = 2;
        IGD_Pop = Indicator1;
        con     = Indicator2;
    end
    FunctionValue = P_objective('value',Problem,M,Population);
    NonDominated  = P_sort(FunctionValue,'first')==1;
    Population    = Population(NonDominated,:);
    FunctionValue = FunctionValue(NonDominated,:);
    TruePoint     = P_objective('true',Problem,M,500);
    IGD           = P_evaluate('IGD',FunctionValue,TruePoint)
    HV            = 0;

    %if M < 4
        %figure;
        %P_draw(FunctionValue);
        %title([Algorithm,' on ',Problem,' with ',num2str(M),' objectives']);
        %Range(1:2:2*M) = min(TruePoint,[],1);
        %Range(2:2:2*M) = max(TruePoint,[],1)*1.02;
        %axis(Range);
        %set(gcf,'Name',[num2str(size(FunctionValue,1)),' points  IGD=',num2str(IGD,5),'  HV=',num2str(HV,5),'  Runtime=',num2str(time,5),'s']);
        %pause(0.1);
    %end
    %if M >= 4
        %figure;
        %P_draw(FunctionValue);
        %title([Algorithm,' on ',Problem,' with ',num2str(M),' objectives']);
        %set(gcf,'Name',[num2str(size(FunctionValue,1)),' points  IGD=',num2str(IGD,5),'  HV=',num2str(HV,5),'  Runtime=',num2str(time,5),'s']);
        %pause(0.1);
    %end
    if flag ~= 0
        savePath = ['Data/', Algorithm,'/'];
        if ~isdir(savePath)
            mkdir(savePath);
        end
        if flag == 2
            eval(['save ',savePath,Algorithm,'_',Problem,'_',num2str(M),'_',num2str(Run),' IGD_Pop con ']);
        end
        if flag == 1
            eval(['save ',savePath,Algorithm,'_',Problem,'_',num2str(M),'_',num2str(Run),' IGD_Pop']);
        end
    end
end

