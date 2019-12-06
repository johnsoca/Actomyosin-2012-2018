function f=gaussian2d(N,sigma)
% N is grid size
% http://stackoverflow.com/questions/13193248/how-to-make-a-gaussian-filter-in-matlab
% 4/21/2016

[x y]=meshgrid(round(-N/2):round(N/2), round(-N/2):round(N/2));
f=exp(-x.^2/(2*sigma^2)-y.^2/(2*sigma^2));
f=f./sum(f(:));