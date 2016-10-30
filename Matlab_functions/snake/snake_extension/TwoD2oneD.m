%2 dimenzi�s id�sor �talak�t�sa 1 dimenzi�ss�
function [oneDimension,center]=TwoD2oneD(Boundary)
%keresni kell egy k�z�ppontot, legyen a k�rvonal m�rtani k�zepe
center.x=sum(Boundary(:,1))/length(Boundary(:,1));
center.y=sum(Boundary(:,2))/length(Boundary(:,2));
%t�vols�gok kisz�m�t�sa
oneDimension=sqrt((Boundary(:,1)-center.x*ones(length(Boundary(:,1)),1)).*(Boundary(:,1)-center.x*ones(length(Boundary(:,1)),1))...
                 +(Boundary(:,2)-center.y*ones(length(Boundary(:,2)),1)).*(Boundary(:,2)-center.y*ones(length(Boundary(:,2)),1)));

end