% CalcDivSimulation.m
% 10/23/17
% Callie J Miller
%
% The purpose of this program is to read in data from already completed
% sims for the filaments and then calculate the divergence of the
% filaments for an entire time course
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

% Set boundaries for the colorbar
fid=fopen('fil1.txt');
A=fscanf(fid,'%g',[3,inf]);
fclose(fid);
cd(oldFolder);
OrigDiv=filamentDivergenceSum2ndOrder(A(1,:),A(2,:),A(3,:),spacing,R);
SNR=mean(mean(OrigDiv))/std(std(OrigDiv));
[xdim, ydim]=size(OrigDiv);
NoNoiseDiv=zeros(xdim,ydim);
for i=1:xdim
    for j=1:ydim
        if abs(OrigDiv(i,j))>SNR
            NoNoiseDiv(i,j)=OrigDiv(i,j);
        end
    end
end
maxStart=max(max(conv2(NoNoiseDiv,gaussian2d(10,2),'same')));
minStart=min(min(conv2(NoNoiseDiv,gaussian2d(10,2),'same')));
clear fid A OrigDiv SNR NoNoiseDiv
cd(folder_name);
fid=fopen('fil1000.txt');
A=fscanf(fid,'%g',[3,inf]);
fclose(fid);
cd(oldFolder);
OrigDiv=filamentDivergenceSum2ndOrder(A(1,:),A(2,:),A(3,:),spacing,R);
SNR=mean(mean(OrigDiv))/std(std(OrigDiv));
[xdim, ydim]=size(OrigDiv);
NoNoiseDiv=zeros(xdim,ydim);
for i=1:xdim
    for j=1:ydim
        if abs(OrigDiv(i,j))>SNR
            NoNoiseDiv(i,j)=OrigDiv(i,j);
        end
    end
end
maxEnd=max(max(conv2(NoNoiseDiv,gaussian2d(10,2),'same')));
minEnd=min(min(conv2(NoNoiseDiv,gaussian2d(10,2),'same')));
clims=[min(minEnd,minStart)-ep max(maxEnd,maxStart)+ep];
clear fid A OrigDiv SNR NoNoiseDiv

cd(folder_name);

%Now create plots over time
for t=276:1000
    close all
    fid=fopen(sprintf('fil%d.txt',t));
    A=fscanf(fid,'%g',[3,inf]);
    fclose(fid);

    % Read in fil data for plus end X and Y and angle, theta
    for i=1:N
        Z(1,i)=A(1,i);
        Z(2,i)=A(2,i);
        Z(3,i)=A(3,i);
    end

    cd(oldFolder);
    OrigDiv=filamentDivergenceSum2ndOrder(Z(1,:),Z(2,:),Z(3,:),spacing,R);

    SNR=mean(mean(OrigDiv))/std(std(OrigDiv));

    [xdim, ydim]=size(OrigDiv);
    NoNoiseDiv=zeros(xdim,ydim);
    for i=1:xdim
        for j=1:ydim
            if abs(OrigDiv(i,j))>SNR
                NoNoiseDiv(i,j)=OrigDiv(i,j);
            end
        end
    end

    figure()
    fig2=imagesc(conv2(NoNoiseDiv,gaussian2d(10,2),'same'),clims); %set the same boundary for the bar?
    colormap(hot)
    colorbar
    cd(folder_name);
    
    figname=sprintf('Div%d.tif',t);
    saveas(fig2,figname);
%     save('data.mat');
    clear A Z fid
end
