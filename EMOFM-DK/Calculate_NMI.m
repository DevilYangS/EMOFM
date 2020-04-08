function NMI = Calculate_NMI( community,True_Community )
%%计算community的扩展NMI值，也就是重叠的NMI
%True_Community=file2community(filename);

a=[];
row=1;col=1;
for i=1:length(community)
    com=community{i};
    for j=1:length(com)
        a(row,col)=com(j);
        col=col+1;
    end;
    row=row+1;
    col=1;
end;

b=[];
row=1;col=1;
for i=1:length(True_Community)
    com=True_Community{i};
    for j=1:length(com)
        b(row,col)=com(j);
        col=col+1;
    end;
    row=row+1;
    col=1;
end;

t1=extendNMI(a,b);
t2=extendNMI(b,a);
NMI=1-(t1+t2)/2;

end

