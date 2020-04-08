%%�ļ���ʽLFR���ɵ�������ʽ ��һ��Ϊ����ţ����漸��Ϊ��������
% % 1	3 
% % 2	4 
% % 3	1  2
% % 4	2  4
function [community,LFR_community,overlapping] = LFR_community2community(LFR_communityFile)
% LFR_community2community('D:\����\MODPSO_edge\overlapping\128_16_16_0.1_2_1_32_32_10_2\community_128_16_16_0.1_2_1_32_32_10_2.dat')
fid = fopen(LFR_communityFile);
tline = fgetl(fid);
community = {};
LFR_community = {};
overlapping = {};
while ischar(tline)
%     strCell = regexp(tline, '\s+', 'split');
    c = str2num(tline);
    if length(c) >2
        overlapping{length(overlapping)+1} = c;%%�����ص���
    end
    LFR_community{length(LFR_community)+1} = c;
    for j = 2:length(c)
%       c = [c,str2num(strCell{j})];
      if length(c(j))>0
          if length(community)<c(j)
              community{c(j)} = c(1);
          else
              community{c(j)} = [community{c(j)},c(1)];
          end
      end
    end
    tline = fgetl(fid);
end
fclose(fid);
end