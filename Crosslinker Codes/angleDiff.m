function [Val]=angleDiff(A,t)
% The purpose of this function is to be given an array of angles, A, and
% determine which pairs of elements are within t radians from each other.
% 6/16/14
% Callie J Miller

N=max(size(A));

SA=sort(A); % sorts A into ascending order
j=1;
Val=[0,0];
% Consider all pairwise differences
for k=1:N-1
    for i=1:N-k
        dif=abs(SA(i)-SA(i+k));
        if dif<=t
            Val(j,:)=[SA(i),SA(i+k)]; %Array of the pairs
            j=j+1;
        end
    end
end