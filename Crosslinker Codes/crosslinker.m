function [CL]=crosslinker(Z,CL,dist)
% The purpose of this function is to determine which filament pair a
% crosslinker will attach to and what location the cross linker will attach
% to.
% 6/16/14
% Callie J Miller
global N

% Rules:
% 1) Filaments must be close to each other, i.e. one location that's a
% minimum distance of 0.04um (from alpha actinin data)
% 2) Filaments must be co-aligned within an angle of pi/8
% 3) Filaments must be within a designated search radius of 0.1 um
% (arbitrarily set) from the crosslinker's location

rad=0.1;
ad=pi/8; %angle difference/co-alignment
count=zeros(1,N);

%Start with rule #3:
% for i=1:N
%     count(i)=findfil2D(Z(1,i),Z(2,i),Z(4,i),Z(5,i),CL(3),CL(4),rad);
%     %Count is an array of 1's and 0's, 1's meaning filament i is within
%     %range of crosslinker, and 0's to say it is not.
% end
[count]=findfil2Dv2(Z,CL(3),CL(4),rad);

j=1;
% If there is only one filament or no filaments near CL, then end execution
% of the function, cross linker doesn't attach
if sum(count)<=1
    CL(1)=0;
    CL(2)=0;
    CL(3)=CL(3);
    CL(4)=CL(4);
    CL(5)=CL(3);
    CL(6)=CL(4);
    return
else %there is more than one filament for crosslinker to possibly bind to if they meet the rest of the criteria
    %Rule #2:
    for ii=1:N
        if count(ii)==1
            ang(j)=Z(3,ii);
            j=j+1;
        end
    end
    Values=angleDiff(ang,ad); % Values is an array of angle pairs that are within ad radians of each other
    % So now we know the angles of possible filament crosslink pairs, we
    % need to create a pairwise array of possible pairs for crosslinkers
    p=size(Values); %Number of possible pairs
    if Values(1,1)==0 %then no possible pair for crosslinker attaching
        CL(1)=0;
        CL(2)=0;
        CL(3)=CL(3);
        CL(4)=CL(4);
        CL(5)=CL(3);
        CL(6)=CL(4);
        return
    else
        % Rule #1:
        % Need to make analogous array for xp,yp,xm,ym for filament pairs
        % as vector Values
        for k=1:p(1)
            a1=find(Z(3,:)==Values(k,1));
            a2=find(Z(3,:)==Values(k,2));
            if a1~=a2
                [d(k),P1(k,:),P2(k,:)]=DistBetween2Segment([Z(1,a1),Z(2,a1),0],[Z(4,a1),Z(5,a1),0],[Z(1,a2),Z(2,a2),0],[Z(4,a2),Z(5,a2),0]);
            else
                d(k)=100;
            end
        end
        clear a1 a2
        Pos=zeros(6,p(1));
        m=1;
        % Find if d(k)<=dist
        for k=1:p(1)
            if d(k)<=dist
                a1=find(Z(3,:)==Values(k,1));
                a2=find(Z(3,:)==Values(k,2));
                Pos(1,m)=a1;%CL(1)
                Pos(2,m)=a2;%CL(2)
                Pos(3,m)=P1(k,1);%CL(3)
                Pos(4,m)=P1(k,2);%CL(4)
                Pos(5,m)=P2(k,1);%CL(5)
                Pos(6,m)=P2(k,2);%CL(6)
                m=m+1;
            end
        end
        
        if m==1 %then no possibilities
            CL(1)=0;
            CL(2)=0;
            CL(3)=CL(3);
            CL(4)=CL(4);
            CL(5)=CL(3);
            CL(6)=CL(4);
        else
            %Finally, select the pair to bind to
            ind=ceil(rand()*(m-1));
            CL(1)=Pos(1,ind);
            CL(2)=Pos(2,ind);
            CL(3)=Pos(3,ind);
            CL(4)=Pos(4,ind);
            CL(5)=Pos(5,ind);
            CL(6)=Pos(6,ind);
        end
    end
end
                
        
                