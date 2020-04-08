function savedata1(filename,data)
fid=fopen(filename,'wt');
[m n]=size(data);
for i=1:m
    for j=1:n
        if j==n
            fprintf(fid,'%g\n',data(i,j));
        else
            fprintf(fid,'%g ',data(i,j));
        end
    end
end
fclose(fid);
end

