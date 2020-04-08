function [U_new IndexMatrix]=Myfunction_similarity(Community,f,IndexMatrix,roughdata)

A=roughdata(~f,f);
U_new=(A./repmat(sum(A,2),1,sum(f)))';
IndexMatrix=IndexMatrix(~f);
end