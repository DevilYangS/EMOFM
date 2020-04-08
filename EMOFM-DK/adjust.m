function [Out_Community ,over_community]=adjust(In_community,weitrix,preoverlap,M)


A=tabulate([In_community{:}]);
overlap_vertex=find(A(:,2)>1);
overlap_vertex=[overlap_vertex;preoverlap];

[m,n]=size(weitrix);
Index=1:m;
Matrix=zeros(1,m);
for li=1:length(In_community)
    Matrix(1,In_community{li})=li;
end

neighbor=cell(m,1);

improvement=1;

while improvement>0.05
improvement=0;
for i=1:m
    neighbor{i}=Index(logical(weitrix(i,:)));
    node_i=i;
    node_i_label=Matrix(i);
    node_i_community=Index(find(Matrix==node_i_label));
    
    temp=[];
    DytQ=-1.*ones(length(neighbor{i}),1);
    for j=1:length(neighbor{i})
        
        node_j=neighbor{i}(j);
       node_j_label= Matrix(node_j);
        if sum(ismember(temp,node_j)) || node_j_label==node_i_label        
        
            
        else
            
            node_j_community=Index(find(Matrix==node_j_label));
            temp=[temp node_j_community];
            
            DytQ(j)=DQ(weitrix,node_i,num2cell(node_j_community),num2cell(node_i_community),M);
        end
        
    end
    node_i_neighbor=neighbor{i};
    [A B]=max(DytQ);
    if A>=0        
    improvement=improvement+A;
    lastmove_neighbor_index=node_i_neighbor(B);
    Matrix(i)=Matrix(lastmove_neighbor_index);% Íê³ÉÒÆ¶¯
            
    end
end


end

Community_label=unique(Matrix);
Community=cell(1,length(Community_label));


    
for jji=1:length(Community_label)
   Community{jji}=Index( find(Matrix==Community_label(jji)));
end

Out_Community=Community;

for io=1:length(overlap_vertex)
    neighborlabel=unique(Matrix(1,neighbor{overlap_vertex(io)}));
    if length(neighborlabel)>1
    reallabel=setdiff(neighborlabel,Matrix(1,overlap_vertex(io)));
    for o=1:length(reallabel)
        label_index=find(Community_label==reallabel(o));
    Community{label_index}=[Community{label_index} overlap_vertex(io)];
    end
    end
end
over_community=Community;
end
