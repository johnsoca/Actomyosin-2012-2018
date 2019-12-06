% Getting Statistics for Sims
% 4/26/14
% Callie J Miller
% The purpose of this code is to read in the data files for various sims
% previously done and output the statistics.

TimePrompt = 'How long was the sim?';
Time = input(TimePrompt);
NPrompt = 'How many filaments?';
N = input(NPrompt);
MPrompt = 'How many motors?';
M = input(MPrompt);

k=3;

avgforce=zeros(1,Time);
maxforce=zeros(1,Time);
variance=zeros(1,Time);

for t=1:Time
    fid=fopen(sprintf('fil%d.txt',t));
    A=fscanf(fid,'%g',[3,inf]);
    fclose(fid);

    % Read in fil data for plus end X and Y and angle, theta
    for i=1:N
        Z(1,i)=A(1,i);
        Z(2,i)=A(2,i);
        Z(3,i)=A(3,i);
    end
    
    meanX(t)=mean(Z(1,:));
    meanY(t)=mean(Z(2,:));
    
    for i=1:N
        Variable(i)=(Z(1,i)-meanX(t))^2+(Z(2,i)-meanY(t))^2;
    end
    variance(t)=mean(Variable);
    

    % Read in force data for each fil
    fileID=fopen(sprintf('mot%d.txt',t),'r');
    formatSpec='%f  %f  %f  %f  %f  %f\n';
    sizeX=[6 M];
    X=fscanf(fileID,formatSpec,sizeX);
    fclose(fileID);
    count=1;
    for j=1:M
        if X(5,j)~=0 && X(6,j)~=0 && X(5,j)~=X(6,j)% if motor index for left and right legs aren't 0, then motor is attached to filament
            force(count)=k*sqrt((X(1,j)-X(3,j))^2+(X(2,j)-X(4,j))^2);
            count=count+1;
        end
    end
    if count==1
        force=0;
    end
    maxforce(t)=max(force);
%     minforce(t)=min(force);
    avgforce(t)=mean(force);
%     fprintf(fid,'%f  %f  %f  %f\n',[t, avgforce,maxforce,minforce]);
%     plot(t,avgforce,'b.');
%     plot(t,maxforce,'r.');
%     plot(t,minforce,'g.');
%     TIME(t)=t;
    
    
end
fidStats=fopen('Stats.txt','w');
for t=1:Time
    fprintf(fid,'%f  %f  %f  %f\n',[t,avgforce(t),variance(t),maxforce(t)]);
end
fclose(fidStats);
% fidStats=fopen('Stats.txt','w');
% for t=1:Time
%     fprintf(fidStats,'%f  %f  %f  %f  %f  %f\n',[TIME(t),meanF(t),meanX(t),meanY(t),variance(t),Angle(t)]);
% end
% fclose(fidStats);
% figure()
% plot(TIME,meanX);
% figure()
% plot(TIME,meanY);
% figure()
% plot(TIME,variance);
% figure()
% plot(TIME,Angle);
% figure()
% plot(TIME,meanF);


