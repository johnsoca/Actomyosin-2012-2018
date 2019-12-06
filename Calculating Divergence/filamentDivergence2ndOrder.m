function [Div]=filamentDivergence2ndOrder(X,Y,Z,d,Domain)
% 01/28/16
% Callie J Miller
%
% The purpose of this function is to calculate the divergence for a set of
% filaments/vectors given X, Y, and orientation, Z. Using the 2nd order
% method for calculating the divergence.

% d- the length to break up the entire domain into boxes.
% Domain- the entire domain size.

numBoxes=Domain/d+2;

% Define boxes as polygons so can use logicals later
for n=1:numBoxes
    xv(n,:)=[(n-2)*d (n-1)*d (n-1)*d (n-2)*d (n-2)*d];
    yv(n,:)=[(n-2)*d (n-2)*d (n-1)*d (n-1)*d (n-2)*d];
end

% %Check the boxes defined with a figure plot
% figure()
% for n1=1:numBoxes
%     for n2=1:numBoxes
%         plot(xv(n2,:),yv(n1,:))
%         hold on
%     end
% end

% Logicals to test if filament's are inside each box, if they are, then
% store the filament vector value and determine the mean vector for each
% box
meanX=zeros(numBoxes,numBoxes);
meanY=zeros(numBoxes,numBoxes);
for n1=1:numBoxes
    for n2=1:numBoxes
        count=1;
        V(count,:)=[0,0];
        for i=1:max(size(X))
            if inpolygon(X(i),Y(i),xv(n2,:),yv(n1,:))
                V(count,:)=[X(i)-cos(Z(i)),Y(i)-sin(Z(i))];
                count=count+1;
            end
        end
        meanX(n1,n2)=mean(V(:,1));
        meanY(n1,n2)=mean(V(:,2));
        clear V
    end
end

for n1=1:numBoxes
    for n2=1:numBoxes
        if n1==1 || n1==numBoxes || n2==1 || n2==numBoxes
            divX(n1,n2)=0;
            divY(n1,n2)=0;
        else
            divX(n1,n2)=(meanX(n1,n2+1)-meanX(n1,n2-1))/2*d;
            divY(n1,n2)=(meanY(n1+1,n2)-meanY(n1-1,n2))/2*d;
        end
    end
end

for n1=2:numBoxes-1
    for n2=2:numBoxes-1
        Div(n1-1,n2-1)=divX(n1,n2)+divY(n1,n2);
    end
end
figure()
imagesc(Div)
colormap(hot)
colorbar