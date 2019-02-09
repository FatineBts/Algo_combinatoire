function [X,YZ,Longueur]=benders(X0,YZ0,P,N,D)

disp('marche')

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

disp('marche2')

while(stop==false)
disp('marche3')
    
    %Sous-probl�me : on cherche x 
    fobjX=@(X)objectiveyz(YZ,X,P,N,D)
    X = patternsearch(fobjX,X,[],[]); 
    disp('ok')
    %On met � jour UB
    UB = min(UB,fobjX(X)); 
    ligne = zeros(1,1+L);
    ligne(1) = -1; 
    A_z = [A_z; ligne]; 
    b_z = [b_z; -fobjX(X)]; 

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
    
disp('marche4')
    
end

disp('marche5')

%Pour le plot
Longueur = YZ(1); 

end 