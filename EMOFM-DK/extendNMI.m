    function Hab=extendNMI(A,B)
%NMI Normalized mutual information
% http://en.wikipedia.org/wiki/Mutual_information
% http://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-clustering-1.html
% Author: http://www.cnblogs.com/ziqiao/   [2011/12/15] 
% A=[1 2 3 4;2 4 5 6];%矩阵每一行表示一个社团中包含的节点编号，A划分有2个团
% B=[1 2 3 4;3 4 5 6];%B划分有2个团，B为真实的划分！
numA=size(A,1);
numB=size(B,1);
total1=max(max(B));
total2=max(max(A));
total=max(total1,total2);%当算法不能覆盖所有节点时候，特殊处理！否则报错！
%用一个矩阵idAOccur存储A划分，即行数表示社团个数，列数表示节点数目;B同样
idAOccur=zeros(numA,total);
for i=1:numA
    temp=find(A(i,:)~=0);
    a=A(i,temp);
    idAOccur(i,a)=1;
end
idBOccur=zeros(numB,total);
for i=1:numB
    temp=find(B(i,:)~=0);
    b=B(i,temp);
    idBOccur(i,b)=1;
end
Com11 = idAOccur * idBOccur';%记录两种划分中 两两社团共有的节点数目，是一个numA*numB矩阵
sizeA=sum(idAOccur')';%记录A划分中每种划分社团的大小，是一个numA*1的向量
sizeB=sum(idBOccur');%是一个1*numB的向量

Com10=repmat(sizeA,1,numB)-Com11;
Com01=repmat(sizeB,numA,1)-Com11;
Com00=ones(size(Com11))*total-Com11-Com10-Com01;
Px = sum(idAOccur') / total;
Py = sum(idBOccur') / total;
P11=Com11/total;
P10=Com10/total;
P01=Com01/total;
P00=Com00/total;
min_A=[];%存储A中每个社团与B中相应社团相异度
for k=1:numA
    min_k=1000;
    Hk_l=0;
    for l=1:numB
        Hkl=0;h11=0;h10=0;h01=0;h00=0;
        if P11(k,l)~=0
            h11=-P11(k,l)*log2(P11(k,l)+eps);
            Hkl=Hkl+h11;
        end
        if P10(k,l)~=0
            h10=-P10(k,l)*log2(P10(k,l)+eps);
            Hkl=Hkl+h10;
        end
        if P01(k,l)~=0
            h01=-P01(k,l)*log2(P01(k,l)+eps);
            Hkl=Hkl+h01;
        end
        if P00(k,l)~=0
            h00=-P00(k,l)*log2(P00(k,l)+eps);
            Hkl=Hkl+h00;
        end       
        Py1=P11(k,l)+P01(k,l);
        Py0=P10(k,l)+P00(k,l);
        Hl=-Py1*log2(Py1+eps)+(-Py0*log2(Py0+eps));
        Hk_l=Hkl-Hl;
        if Hk_l<=min_k &&(h00+h11>h01+h10)
            min_k=Hk_l;
            templ=l;
        end
    end
    if min_k==1000  %限制条件不满足
        min_k=1;
    else
        Px1=P11(k,templ)+P10(k,templ);%%%%？、？？？？？
        Px0=P01(k,templ)+P00(k,templ);
        Hk=-Px1*log2(Px1+eps)+(-Px0*log2(Px0+eps));
        min_k=min_k/Hk;
    end
    min_A=[min_A min_k];
end
Hab=sum(min_A)/numA;
end

