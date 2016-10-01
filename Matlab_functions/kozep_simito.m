function [result_fuggvenyek] = kozep_simito(tav_fuggvenyek)
%%nagyfrekvenciás változások kiszûrése
%%függvények legenerálása
%simitó konvolúció
A=[0.2 0.2 0.2 0.2 0.2];
%%simítás
%minden jelzõ pontra újraszámoljuk a pozícióját
result_fuggvenyek=tav_fuggvenyek;
for i=1:length(tav_fuggvenyek{1})
    %egy tüdõpozícióhoz tartozó pontok
    for j=1:length(tav_fuggvenyek)
      vec(j)=tav_fuggvenyek{j}(i);
    end
    %simítás
    smoothed=conv(vec,A,'valid');
    %visszaírás
    for j=1:length(smoothed)
      result_fuggvenyek{j+2}(i)=smoothed(j);
    end
    %szélének kiegészítése
    result_fuggvenyek{1}(i)=smoothed(1);
    result_fuggvenyek{2}(i)=smoothed(1);
    result_fuggvenyek{length(smoothed)+3}(i)=smoothed(length(smoothed));
    result_fuggvenyek{length(smoothed)+4}(i)=smoothed(length(smoothed));
    
end
end
