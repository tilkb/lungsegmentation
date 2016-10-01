function [result_fuggvenyek] = kozep_simito(tav_fuggvenyek)
%%nagyfrekvenci�s v�ltoz�sok kisz�r�se
%%f�ggv�nyek legener�l�sa
%simit� konvol�ci�
A=[0.2 0.2 0.2 0.2 0.2];
%%sim�t�s
%minden jelz� pontra �jrasz�moljuk a poz�ci�j�t
result_fuggvenyek=tav_fuggvenyek;
for i=1:length(tav_fuggvenyek{1})
    %egy t�d�poz�ci�hoz tartoz� pontok
    for j=1:length(tav_fuggvenyek)
      vec(j)=tav_fuggvenyek{j}(i);
    end
    %sim�t�s
    smoothed=conv(vec,A,'valid');
    %vissza�r�s
    for j=1:length(smoothed)
      result_fuggvenyek{j+2}(i)=smoothed(j);
    end
    %sz�l�nek kieg�sz�t�se
    result_fuggvenyek{1}(i)=smoothed(1);
    result_fuggvenyek{2}(i)=smoothed(1);
    result_fuggvenyek{length(smoothed)+3}(i)=smoothed(length(smoothed));
    result_fuggvenyek{length(smoothed)+4}(i)=smoothed(length(smoothed));
    
end
end
