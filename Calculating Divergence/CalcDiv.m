% CalcDiv.m
% 1/29/16
% Callie J Miller
%
% The purpose of this program is to read in data from already completed
% sims for the filaments and then calculate the divergence of the
% filaments.
clear all
close all

oldFolder=cd;
folder_name = uigetdir;
cd(folder_name);

L=1; %can change based on the sim
spacing=L/8; %how dividing the domain
R=2; % radius of the domain
N=1000;
ep=0.001; % epsilon for scaling plots

% filename=uigetfile;

fid=fopen('fil1000.txt');
A=fscanf(fid,'%g',[3,inf]);
fclose(fid);
for i=1:N
    Z(1,i)=A(1,i);
    Z(2,i)=A(2,i);
    Z(3,i)=A(3,i);
end
cd(oldFolder);
Div=filamentDivergenceSum2ndOrder(Z(1,:),Z(2,:),Z(3,:),spacing,R);
endMin=min(min(Div));
endMax=max(max(Div));
clear A Z Div
cd(folder_name);
fid=fopen('fil1.txt');
A=fscanf(fid,'%g',[3,inf]);
fclose(fid);
for i=1:N
    Z(1,i)=A(1,i);
    Z(2,i)=A(2,i);
    Z(3,i)=A(3,i);
end
cd(oldFolder);
Div=filamentDivergenceSum2ndOrder(Z(1,:),Z(2,:),Z(3,:),spacing,R);
startMin=min(min(Div));
startMax=max(max(Div));
clims=[min(endMin,startMin)-ep max(endMax,startMax)+ep];
clear A Z Div
cd(folder_name);

for t=1:1000    
%     fid=fopen(filename);
    fid=fopen(sprintf('fil%d.txt',t));
    A=fscanf(fid,'%g',[3,inf]);
    fclose(fid);

    % Read in fil data for plus end X and Y and angle, theta
    for i=1:N
        Z(1,i)=A(1,i);
        Z(2,i)=A(2,i);
        Z(3,i)=A(3,i);
    end

    % figure()
    % for i=1:N
    %     plot([Z(1,i),Z(1,i)-L*cos(Z(3,i))],[Z(2,i),Z(2,i)-L*sin(Z(3,i))],'k');
    %     hold on
    %     plot(Z(1,i),Z(2,i),'k.');
    % end
    cd(oldFolder);
    Div=filamentDivergenceSum2ndOrder(Z(1,:),Z(2,:),Z(3,:),spacing,R);
    cd(folder_name);
    figure()
    set(gcf,'visible','off')
    imagesc(Div,clims)
    colormap(hot)
    colorbar
    figname=sprintf('Div%d.tif',t);
    saveas(gcf,figname);
    clear A fid Z Div
end