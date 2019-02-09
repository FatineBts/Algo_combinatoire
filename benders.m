function [X,YZ,Longueur]=benders(X0,YZ0,P,N,D,A,b,Aeq,beq)

X = X0; 
A_z = [zeros(size(A,1),1),A]; 
b_z = b;
A_eqz = [zeros(size(Aeq,1),1),Aeq]; 
b_eqz = beq;
YZ = YZ0; 

%initialisation
k = 1; 
LB = -inf; 
UB = +inf; 
K = []; 
k = 0; 
stop = false; 
COL = N*(N-2) + (N-2)*(N-2); 

while(stop==false && k < 1000)
    
    %Sous-probl�me : on cherche x 
    fobjX=@(X)objectiveyz(YZ,X,P,N,D)
    X = patternsearch(fobjX,X,[],[]); 

    %On met � jour UB
    UB = min(UB,fobjX(X)); 
    ligne = zeros(1,1+COL);
    ligne(1) = -1; 
    A_z = [A_z; ligne]; 
    b_z = [b_z; -fobjX(X)]; 
    
    %Sous-probl�me : on cherche z
    fobjZ= zeros(COL+1,1);
    fobjZ(1) = 1; 
    intcon = 2:COL+1; %elles sont toutes enti�res sauf la premi�re
    lb = zeros(COL+1,1);
    ub = ones(COL+1,1);
    ub(1) = +Inf; 
    
    XZ = intlinprog(fobjZ,intcon,A_z,b_z,A_eqz,b_eqz, lb, ub); %on a Z puis YZ
    LB = XZ; 

    k = k + 1

    if(LB >=UB) 
        stop = true;       
    else 
        YZ = XZ(2:end); 
    end
        
end

%Pour le plot
Longueur = YZ(1); 

end 