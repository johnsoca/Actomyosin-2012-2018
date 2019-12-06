% Getting Statistics for Sims
% 4/26/14
% Callie J Miller
% The purpose of this code is to read in the data files for various sims
% previously done and output the statistics.

TimePrompt = 'How long was the sim?';
Time = input(TimePrompt);
NPrompt = 'How many filaments?';
N = input(NPrompt);

for t=1:Time
    fid=fopen(sprintf('fil%d.txt',t));
    A=fscanf(fid,'%g',[5,inf]);
    fclose(fid);

    % Read in fil data for plus end X and Y and angle, theta
    for i=1:6
        Z(1,i)=A(1,i);
        Z(2,i)=A(2,i);
        Z(3,i)=A(3,i);
    end

    fid=fopen(sprintf('fil%d.txt',t));
    AA=fscanf(fid,'%g',[3,inf]);
    fclose(fid);
    
    for i=7:max(size(AA))-4
        Z(1,i)=AA(1,i+4);
        Z(2,i)=AA(2,i+4);
        Z(3,i)=AA(3,i+4);
    end
    
    meanX(t)=mean(Z(1,:));
    meanY(t)=mean(Z(2,:));
    
    for i=1:N
        Variable(i)=(Z(1,i)-meanX(t))^2+(Z(2,i)-meanY(t))^2;
    end
    variance(t)=mean(Variable);
    
    clear i
    m=6;
    for j=1:N
        s(j)=exp(i*m*Z(3,j));
    end
    Angle(t)=(1/N)*abs(sum(s(:)));
    

    % Read in force data for each fil

    fidF=fopen(sprintf('Force%d.txt',t));
    F=fscanf(fidF,'%g',[1,inf]);
    fclose(fidF);
    
    meanF(t)=mean(F);
    TIME(t)=t;
    
    clear A F
%     fidStats=fopen('Stats.txt','w');
%     fprintf(fid,'%f  %f  %f  %f  %f  %f\n',[t,meanF(t),meanX(t),meanY(t),variance(t),Angle(t)]);
end
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
plot(TIME,meanF);


