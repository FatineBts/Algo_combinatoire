function x,y,z=Benders(X0,fobjyz,A,b,Aeq,beq,YZ0,P,N,D)

X = X0; 
A_z = []; 
b_z = []; 
YZ = YZ0; 

%initialisation
k = 1; 
LB = -inf; 
UB = +inf; 
K = []; 
k = 0; 
stop = false; 
L = N*(N-2) + (N-2)*(N-2); 

while(stop==false)
    
    %Sous-probl�me : on cherche x 
    fobjX=@(X)objectiveyz(YZ,X,P,N,D);

    x = patternsearch(fobjX,X,[],[]); 

    %On met � jour UB
    UB = min(UB,fobjX(x)); 
    ligne = zeros(1,1+L);
    ligne(1) = -1; 
    A_z = [A_z; ligne]; 
    b_z = [b_z; -fobjX(x)]; 

    %Sous-probl�me : on cherche z
    fobjZ= zeros(L+1,1);
    fobjZ(1) = 1; 
    intcon = 2:L+1; %elles sont toutes enti�res sauf la premi�re
    lb = zeros(L+1,1);
    ub = ones(L+1,1);
    ub(1) = +Inf; 
    
    XZ = intlinprog(fobjZ,intcon,A_z,b_z,[], [], lb, ub); %on a Z puis YZ
    LB = XZ; 

    k = k + 1;

    if(LB >=UB) 
        stop = true;       
    else 
        YZ = XZ(2:end); 
    end 
end 

end 