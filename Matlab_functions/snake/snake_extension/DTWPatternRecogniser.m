%%DTW seg�ts�g�vel egy megadott id�sort illeszt egy m�sikra, az
%%adatb�zisb�l kiv�lasztja a legjobban illeszked�t
%bestcost: legjobb egyez�ses tal�latn�l a k�l�nbs�g
%bestderived: legjobbnak, minden pontra vett deriv�ltja
function [bestcost,bestderived]=DTWPatternRecogniser(idosor, adatbazis)
bestcost=Inf;
bestderived=zeros(1,length(idosor));
for i=1:length(adatbazis)
    %dinamikus 
  DTW=zeros(length(idosor),length(adatbazis{i}));
  reference=adatbazis{i};
  %az id�sor v�rhat� �rt�k�t azonosra be kell �ll�tani
  reference=reference*(mean(idosor)/mean(reference));
  %�rt�kek be�ll�t�sa
  for j=1:length(idosor)
     DTW(j,1)=Inf; 
  end
  for j=1:length(reference)
     DTW(1,j)=Inf; 
  end
  DTW(1,1)=0;
  %t�bl�zatkit�lt�s 
  for j=2:length(idosor)
      for k=2:length(reference)
        cost=abs(idosor(j)-reference(k));
        DTW(j,k)=cost+min([DTW(j-1,k),DTW(j,k-1),DTW(j-1,k-1)]);
      end
  end
  if (bestcost>DTW(length(idosor),length(reference)))
      bestcost=DTW(length(idosor),length(reference));
      %ha ez a legjobb akkor a legjobb �tvonlat ki kell keresni
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