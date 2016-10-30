function [Positions] =CalculateDerivatedPosition(OriginalPositions,Series )
%%Positions: a deriváltak új pozíciója
%%Series: idõsor ami módosítja a pozíciókat
%%OriginalPositions: a körvonal pontjai amiket módosítani kell
Positions=zeros(length(Series),2);
%keresni kell egy középpontot, legyen a körvonal mértani közepe
center.x=sum(OriginalPositions(:,1))/length(OriginalPositions(:,1));
center.y=sum(OriginalPositions(:,2))/length(OriginalPositions(:,2));
for i=1:length(OriginalPositions(:,1))
    %irány kiszámítása
    dir(1)=OriginalPositions(i,1)-center.x;
    dir(2)=OriginalPositions(i,2)-center.y;
    dir=dir/norm(dir);
    Positions(i,1)=dir(1)*Series(i);
    Positions(i,2)=dir(2)*Series(i);
end


end

