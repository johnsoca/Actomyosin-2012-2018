function [J,Z,X]=initialize()
% This function is designed to independently assign motor positions and
% filament positions (randomly) within the hexagon.
% 01/26/14
% Callie J Miller
% USES THE FOLLOWING FUNCTIONS: hexagon.m
global M N L cote x0 y0 xhex yhex

%Pre-Allocate
J=zeros(2,M);
Z=zeros(5,N);
X=zeros(4,M);
%set boundaries of the patch of cortex
cote=2; %radus of patch
x0=0; %x component of center
y0=0; %y component of center
[xhex,yhex]=hexagon(cote,x0,y0);

%Initialize filament positions
for i=1:N/2%ceil(0.05*N) % For 25% of the filaments, put them so the plus end is on the bar and the minus end is off.
    Z(1,i)=(-1.5)+3*rand();
    Z(2,i)=(-0.5)+rand();
    while Z(1,i)<-1.5 || Z(1,i)>1.5 || Z(2,i)<-0.5 || Z(2,i)>0.5
        Z(1,i)=(-1.5)+3*rand();
        Z(2,i)=(-0.5)+rand();
    end
    Z(3,i)=rand()*2*pi;
    Z(4,i)=Z(1,i)-L*cos(Z(3,i));
    Z(5,i)=Z(2,i)-L*sin(Z(3,i));
%     while Z(4,i)>-1.5 || Z(4,i)<1.5 || Z(5,i)>-0.5 || Z(5,i)<0.5
%         Z(3,i)=rand()*2*pi;
%         Z(4,i)=Z(1,i)-L*cos(Z(3,i));
%         Z(5,i)=Z(2,i)-L*sin(Z(3,i));
%     end
end
for i=N/2+1:N%ceil(0.05*N)+1:N % For 75% of the filaments, put then all on the bar (plus and minus ends).
    Z(1,i)=(-1.5)+3*rand();
    Z(2,i)=(-0.5)+rand();
    while Z(1,i)<-1.5 || Z(1,i)>1.5 || Z(2,i)<-0.5 || Z(2,i)>0.5
        Z(1,i)=(-1.5)+3*rand();
        Z(2,i)=(-0.5)+rand();
    end
    Z(3,i)=rand()*2*pi;
    Z(4,i)=Z(1,i)-L*cos(Z(3,i));
    Z(5,i)=Z(2,i)-L*sin(Z(3,i));
    while Z(4,i)<-1.5 || Z(4,i)>1.5 || Z(5,i)<-0.5 || Z(5,i)>0.5
        Z(3,i)=rand()*2*pi;
        Z(4,i)=Z(1,i)-L*cos(Z(3,i));
        Z(5,i)=Z(2,i)-L*sin(Z(3,i));
    end
end 


%Initialize motor positions to entire domain
for j = 1:M
  X(1,j) = (-2)+4*rand();
  X(2,j) = (-2)+4*rand();
  while X(1,j)<-2 || X(1,j)>2 || X(2,j)<-2 || X(2,j)>2
      X(1,j) = (-2)+4*rand();
      X(2,j) = (-2)+4*rand();
  end
end
X(3,:)=X(1,:); %Initially unattached
X(4,:)=X(2,:); %so same x and y position for L and R legs
