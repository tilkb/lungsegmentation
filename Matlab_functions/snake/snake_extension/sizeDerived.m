function derived = sizeDerived(Boundary,expected,x,y)
%sizeDerived: Egy "deriválttal" tér vissza attól függõen, hogy mennyire tér el a tüdõ mérete a várttól
%Boundary: a jelenlegi körvonal
%expected: várt méret
%x,y: a kép méretei(teljes kép)

%%méret kiszámítása
mask= poly2mask(Boundary(:,1),Boundary(:,2),x,y);
ratio=sum(sum(mask))/(x*y/2);
derived=expected-ratio;
end

