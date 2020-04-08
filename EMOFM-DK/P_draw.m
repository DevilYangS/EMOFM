function Handle = P_draw(FigureData,FigureFormat)
% ���Ƴ�ָ�����ݵ�ͼ��
% ����: FigureData,   �����Ƶ����ݾ���(��������꼯��)
%       FigureFormat, ͼ�εĸ�ʽ, ��ʡ��
% ���: Handle, ͼ�εľ��
    Mode = 1;
    switch size(FigureData,2)
        case 2
            hold on;box on
            set(gca, 'Fontname', 'Times New Roman', 'Fontsize', 13)
            if nargin < 2 || ~ischar(FigureFormat)
                Handle = plot(FigureData(:,1),FigureData(:,2),'ok','MarkerSize',6,'Marker','o','Markerfacecolor',[0 0 0]+0.7,'Markeredgecolor',[0 0 0]+0.4);
            else
                Handle = plot(FigureData(:,1),FigureData(:,2),FigureFormat);
            end
            axis tight
            xlabel('f_1')
            ylabel('f_2')
        case 3
            hold on;box on
            set(gca, 'Fontname', 'Times New Roman', 'Fontsize', 13)
            if nargin < 2 || ~ischar(FigureFormat)
                Handle = plot3(FigureData(:,1),FigureData(:,2),FigureData(:,3),'ok','MarkerSize',8,'Marker','o','Markerfacecolor',[0 0 0]+0.7,'Markeredgecolor',[0 0 0]+0.4);
            else
                Handle = plot3(FigureData(:,1),FigureData(:,2),FigureData(:,3),FigureFormat);
            end
            axis tight
            xlabel('f_1')
            ylabel('f_2')
            zlabel('f_3')
            view(135,30)
        otherwise
            hold on;box on;
            if Mode == 1
                Num = size(FigureData,1);
                if nargin < 2 || ~ischar(FigureFormat)
                    FigureFormat = 'bo-';
                end
                for i = 1 : Num
                    plot(FigureData(i,:),FigureFormat);
                end
                Handle = NaN;
            elseif Mode == 2
                M = size(FigureData,2);
                SumM = sum([1:M-1]);
                RowValue = floor(sqrt(SumM));
                while mod(SumM,RowValue) ~= 0
                    RowValue = RowValue - 1;
                end
                LineValue = SumM / RowValue;
                Num = 1;
                for i = 1 : M
                    for j= i+1 : M
                        subplot(RowValue,LineValue,Num);
                        plot(FigureData(:,i),FigureData(:,j),'b*');
                        Num = Num + 1;
                    end
                end
                Handle = NaN;
            end
    end
end

