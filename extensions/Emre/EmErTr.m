         
  %  A=zeros(1940);       
     for n=1:1940;
         i=floor((n-1)/64)+1;
        if i>10;
             i=mod(i,10);
        end
        if i==0;
            i=10;
        end
       
         An(n)=i;
        
     end
     %end
    
    