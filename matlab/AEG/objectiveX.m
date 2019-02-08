function res = objectiveX(YZ,X,P,N,D)
X=reshape(X,[D,N])';
resy=0;
resz=0;
col=N-2;
ind=N*(N-2);
for p=1:N
    for q=1:N-2
        resy=resy+YZ(p*col+q)*norm(X(q,:) -P(p,:));
        
        if (p<q)
            resz=resz + YZ(ind+ p*col+q)*norm(X(q,:)-X(p,:));
        end
    end
end
res=resy+resz;
end 