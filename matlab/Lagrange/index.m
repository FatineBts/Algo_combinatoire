function ind=index(i,p,q,N,D)
%coord S=1, liens Y=2, liens Z=3, val RP=4,val RS=5
saut=[0 (N-2)*D (N-2)*(N+D) (N-2)*(2*N-2+D)  (N-2)*(3*N-4 +D)];
col=0;
p=p-1;
if (i==1)
    col=D;
    ind = saut(1) + p*D + q;
elseif (i==2)
    col=N-2;
    ind=saut(2) + p*col +q;
elseif (i==3)
    col=N-2;
    ind=saut(3) + p*col +q;
elseif (i==4)
    col=N-2;
    ind=saut(4) + p*col +q;
elseif (i==5)
    col=N-2
    ind=saut(5)+ p*col + q;
else
    ind=0;  
end

    
end

