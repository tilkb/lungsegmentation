function [Positions] =CalculateDerivatedPosition(OriginalPositions,Series )
%%Positions: a deriv�ltak �j poz�ci�ja
%%Series: id�sor ami m�dos�tja a poz�ci�kat
%%OriginalPositions: a k�rvonal pontjai amiket m�dos�tani kell
Positions=zeros(length(Series),2);
%keresni kell egy k�z�ppontot, legyen a k�rvonal m�rtani k�zepe
center.x=sum(OriginalPositions(:,1))/length(OriginalPositions(:,1));
center.y=sum(OriginalPositions(:,2))/length(OriginalPositions(:,2));
for i=1:length(OriginalPositions(:,1))
    %ir�ny kisz�m�t�sa
    dir(1)=OriginalPositions(i,1)-center.x;
    dir(2)=OriginalPositions(i,2)-center.y;
    dir=dir/norm(dir);
    Positions(i,1)=dir(1)*Series(i);
    Positions(i,2)=dir(2)*Series(i);
end


end

