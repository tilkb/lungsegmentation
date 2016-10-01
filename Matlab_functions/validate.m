function [overlap,mad,szoras] = validate(segmented, original)
%validate: megadja két kép közötti hasonlóságot 
%   segmented: számítógép által megtalált kép bináris maszkja
%   original: orvos által kijelölt terület
%   overlap: a két maszk közötti átfedés[0..1]
%   mad:két mask közötti átlagátfedés
both=0;
first=0;
second=0;
[x,y]=size(segmented);
for i=1:x
    for j=1:y
        if (segmented(i,j)>0.9 && original(i,j)>0.9)
            both=both+1;
        end
        if (segmented(i,j)>0.9 && original(i,j)<0.1)
            first=first+1;
        end
        if (segmented(i,j)<0.1 && original(i,j)>0.9)
            second=second+1;
        end
    end
end
%eredeti képnek mekkorra részét fedi le a megtalált
overlap=both/(both+second+first);
%mad kiszámolása
[B1,~,N1,~] = bwboundaries(segmented);
[B2,~,N2,~] = bwboundaries(original);
count=0;
squaredsum=0;
sum=0;
for i1=1:N1
    boundary1 = B1{i1};
    for j1=1:length(boundary1)
        min=1000000;
        for i2=1:N2       
            boundary2 = B2{i2};
            for j2=1:length(boundary2)
                distance=sqrt((boundary1(j1,1)-boundary2(j2,1))*(boundary1(j1,1)-boundary2(j2,1))+(boundary1(j1,2)-boundary2(j2,2))*(boundary1(j1,2)-boundary2(j2,2)));
                if (distance<min)
                    min=distance;
                end
            end
        end
        count=count+1;
        sum=sum+min;
        squaredsum=squaredsum+min*min;
    end
end
if (count==0)
    mad=0;
    szoras=0;
else
   mad=sum/count;
   szoras=sqrt((squaredsum/count)-mad*mad);
end
end

