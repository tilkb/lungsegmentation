%%DTW segítségével egy megadott idõsort illeszt egy másikra, az
%%adatbázisból kiválasztja a legjobban illeszkedõt
%bestcost: legjobb egyezéses találatnál a különbség
%bestderived: legjobbnak, minden pontra vett deriváltja
function [bestcost,bestderived]=DTWPatternRecogniser(idosor, adatbazis)
bestcost=Inf;
bestderived=zeros(1,length(idosor));
for i=1:length(adatbazis)
    %dinamikus 
  DTW=zeros(length(idosor),length(adatbazis{i}));
  reference=adatbazis{i};
  %az idõsor várható értékét azonosra be kell állítani
  reference=reference*(mean(idosor)/mean(reference));
  %értékek beállítása
  for j=1:length(idosor)
     DTW(j,1)=Inf; 
  end
  for j=1:length(reference)
     DTW(1,j)=Inf; 
  end
  DTW(1,1)=0;
  %táblázatkitöltés 
  for j=2:length(idosor)
      for k=2:length(reference)
        cost=abs(idosor(j)-reference(k));
        DTW(j,k)=cost+min([DTW(j-1,k),DTW(j,k-1),DTW(j-1,k-1)]);
      end
  end
  if (bestcost>DTW(length(idosor),length(reference)))
      bestcost=DTW(length(idosor),length(reference));
      %ha ez a legjobb akkor a legjobb útvonlat ki kell keresni
      holx=length(idosor);
      holy=length(reference);
      while(holx>1 || holy>1)
          minimum=min([DTW(holx-1,holy),DTW(holx,holy-1),DTW(holx-1,holy-1)]);
          if (minimum==DTW(holx-1,holy))
              holx=holx-1;
              bestderived(holx)=reference(holy)-idosor(holx);
          elseif (minimum==DTW(holx,holy-1))
              holy=holy-1;
          else
              holx=holx-1;
              holy=holy-1;
              bestderived(holx)=reference(holy)-idosor(holx);
          end
      end
  end
end
    
end