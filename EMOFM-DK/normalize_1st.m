function vv=normalize_1st(vv)
% function vv=normalize_1st(vv)
% normalized the vector vv along the first dimension. i.e. 
% vv returns has unit norm ROWS. 
% (Note: If the row is zero it is untouched and NO error msg is
% printed )   
  n=size(vv,1); 
  ss = sqrt( sum( vv.^2, 2 ));   % normalize
  for i=1:n
	if ss(i)==0 
	  vv(i,:)=0;
	else
	  vv(i,:)=vv(i,:)/ss(i);
	end
  end

  
