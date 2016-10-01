function [left,right ] = get_centers(mask)
%get_centers: a két tüdõ középpontját adja vissza
%   mask: felhasználandó bináris kép
%   left: bal oldali rész középpontja(left.x,left.y)
%   right:jobb oldali rész középpontja(right.x,right.y)
%%beállítások
%bal oldal középpontja mennyire legyen eltolva
left_rate.x=0.85;
left_rate.y=0.85;
%jobb oldal középpontja mennyire legyen eltolva
right_rate.x=0.85;
right_rate.y=1.08;
%%eljárás
[x,y]=size(mask);
sumx=0;
sumy=0;
count=0;
%bal oldal
for i=1:round(y*0.5)
    for j=1:x
        if mask(j,i)==1
            count=count+1;
            sumx=sumx+j*j;
            sumy=sumy+i*i;
        end
    end
end
if count>0
  left.x=round(sqrt(sumx/count)*left_rate.x);
  left.y=round(sqrt(sumy/count)*left_rate.y);
else
    left.x=round(x/2);
    left.y=round(y/4);
end
%jobb oldal
sumx=0;
sumy=0;
count=0;
for i=round(y*0.5):y
    for j=1:x
        if mask(j,i)==1
            count=count+1;
            sumx=sumx+j*j;
            sumy=sumy+i*i;
        end
    end
end
if count>0
  right.x=round(sqrt(sumx/count)*right_rate.x);
  right.y=round(sqrt(sumy/count)*right_rate.y);
else
    right.x=round(x/2);
    right.y=round(y*0.75);
end

end

