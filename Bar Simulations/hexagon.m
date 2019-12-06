function [xhex, yhex]=hexagon(cote,x0,y0)
   %cote= side size;,(x0,y0) hexagon center coordinates;
   xhex=cote*[-1 -0.5 0.5 1 0.5 -0.5 -1]+x0;
   yhex=cote*sqrt(3)*[0 -0.5 -0.5 0 0.5 0.5 0]+y0;
