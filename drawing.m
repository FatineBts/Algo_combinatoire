function []=drawing(X,P,YZ,N)
% PLOT
for p=1:N
   for q=1:N-2
        ind=(p-1)*(N-2)+q;
        if(YZ(ind)==1) %liens y
            p1=P(p,:);
            p2=X(q,:);
            l=[P(p,:);X(q,:)];
            %X(q,:)drawline(p1,p2)
            plot3(l(:,1),l(:,2),l(:,3),'-m','MarkerSize',20)
            hold on
        end
        if (p<=N-2)
            ind=N*(N-2) + (p-1)*(N-2)+q;
            if(YZ(ind)==1)%liens Z
                l=[X(p,:);X(q,:)];
                plot3(l(:,1),l(:,2),l(:,3),'-m','MarkerSize',20)
                hold on
            end
        end        
        end
end
plot3(P(:,1),P(:,2),P(:,3),'sr')
hold on
plot3(X(:,1),X(:,2),X(:,3),'ob')
grid on
end