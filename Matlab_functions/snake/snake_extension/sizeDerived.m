function derived = sizeDerived(Boundary,expected,x,y)
%sizeDerived: Egy "deriv�lttal" t�r vissza att�l f�gg�en, hogy mennyire t�r el a t�d� m�rete a v�rtt�l
%Boundary: a jelenlegi k�rvonal
%expected: v�rt m�ret
%x,y: a k�p m�retei(teljes k�p)

%%m�ret kisz�m�t�sa
mask= poly2mask(Boundary(:,1),Boundary(:,2),x,y);
ratio=sum(sum(mask))/(x*y/2);
derived=expected-ratio;
end

