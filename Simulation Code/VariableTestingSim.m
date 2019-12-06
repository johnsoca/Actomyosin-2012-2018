% VariableTestingSim.m
% 01/26/14
% Callie J Miller
% 
% The purpose of this code is to allow the user to quickly test various
% variables of the simulation of actomyosin in a hexagon.
% USES THE FOLLOWING FUNCTIONS: initialize.m, HexSimPoly.m (in the Simulation
% Codes folder)
% MODIFIED 03/02/14: Test if can get angular co-alignment by manipulating
% vertex filament spring stiffnesses or lengths.
%
% UPDATED 05/01/15: To account for incorrectness with force calculations

clear all
close all
global Time M N L p0 p1 p2 h r v k cote x0 y0 xhex yhex Zold

TimePrompt = 'How long do you want the simulation to run?';
Time = input(TimePrompt);

MPrompt='How many motors?';
M=input(MPrompt);

NPrompt='How many filaments?';
N=input(NPrompt);




%Variables already predeclared
%Time=200;
%M=100;
%N=50;

L=1; %length of filaments
p0=1; %Detachment rate
p1=10; %Attachment rate
p2=0.7; %Rate of polymerization 
h=0.01; %stepsize
r=0.3; %radius motor's will attach
% r=2/10; %radius of searching for motor to attach and maximum stretch of motor allowed (the hexagonal radius divided by 10)
v=1; %speed of motor
k=3; %spring stiffness of motor

tic
[J,Z,X]=initialize();
fid=fopen('fil0.txt','w');
    for i=1:N 
        fprintf(fid,'%f %f %f\n',[Z(1,i),Z(2,i),Z(3,i)]);
    end
    fclose(fid);
    clear fid
    
    fidMot=fopen('mot0.txt','w');
    for j=1:M
            fprintf(fidMot,'%f  %f  %f  %f  %f  %f\n',[X(1,j),X(2,j),X(3,j),X(4,j),J(1,j),J(2,j)]);
    end
    fclose(fidMot);
[X,J,Z,S]=HexSimPoly(X,J,Z);
toc
