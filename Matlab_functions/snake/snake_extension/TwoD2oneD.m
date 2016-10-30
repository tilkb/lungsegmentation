%2 dimenziós idõsor átalakítása 1 dimenzióssá
function [oneDimension,center]=TwoD2oneD(Boundary)
%keresni kell egy középpontot, legyen a körvonal mértani közepe
center.x=sum(Boundary(:,1))/length(Boundary(:,1));
center.y=sum(Boundary(:,2))/length(Boundary(:,2));
%távolságok kiszámítása
oneDimension=sqrt((Boundary(:,1)-center.x*ones(length(Boundary(:,1)),1)).*(Boundary(:,1)-center.x*ones(length(Boundary(:,1)),1))...
                 +(Boundary(:,2)-center.y*ones(length(Boundary(:,2)),1)).*(Boundary(:,2)-center.y*ones(length(Boundary(:,2)),1)));

end