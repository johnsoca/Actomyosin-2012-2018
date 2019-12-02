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
for i=1:N
    Z(1,i)=(xhex(1)+(xhex(4)-xhex(1))*rand);
    Z(2,i)=(yhex(2)+(yhex(5)-yhex(2))*rand);
    inPlus=inpolygon(Z(1,i),Z(2,i),xhex,yhex);
    while inPlus==0
        Z(1,i)=(xhex(1)+(xhex(4)-xhex(1))*rand);
        Z(2,i)=(yhex(2)+(yhex(5)-yhex(2))*rand);
        inPlus=inpolygon(Z(1,i),Z(2,i),xhex,yhex);
    end
    Z(3,i)=rand()*2*pi;
    Z(4,i)=Z(1,i)-L*cos(Z(3,i));
    Z(5,i)=Z(2,i)-L*sin(Z(3,i));
    inMinus=inpolygon(Z(4,i),Z(5,i),xhex,yhex);
    while inMinus==0 % if minus ends aren't in hexagon, but the first while 
        % has already proven that the plus ends are inside the hexagon, 
        % define a new angle of orientation for the filaments, and then redefine a new minus end.
        Z(3,i) = rand()*2*pi;
        Z(4,i) = Z(1,i)-L*cos(Z(3,i));
        Z(5,i) = Z(2,i)-L*sin(Z(3,i));
        inMinus = inpolygon(Z(4,i),Z(5,i),xhex,yhex);
    end
end

%Initialize motor positions
for j = 1:M
  X(1,j) = xhex(1) + (xhex(4)-xhex(1))*rand();
  X(2,j) = yhex(2) + (yhex(5)-yhex(2))*rand();
  inMotor = inpolygon(X(1,j),X(2,j),xhex,yhex);
  while inMotor==0
      X(1,j) = xhex(1) + (xhex(4)-xhex(1))*rand();
      X(2,j) = yhex(2) + (yhex(5)-yhex(2))*rand();
      inMotor = inpolygon(X(1,j),X(2,j),xhex,yhex);
  end
end
X(3,:)=X(1,:); %Initially unattached
X(4,:)=X(2,:); %so same x and y position for L and R legs
