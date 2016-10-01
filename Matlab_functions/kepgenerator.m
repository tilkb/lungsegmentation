function [im,grad] = kepgenerator(img)
%kepgenerator n�h�ny sz�r�st v�gez �s a l�trehozott k�peket visszaadja
%   im:sz�rt k�p
%   grad:a visszaadott gradiens k�p
%   img: eredeti k�p(~512*512-re optimaliz�lva) 
%% be�ll�t�sok
 szuro=[1 1 1 1 1;
        1 1 1 1 1;
        1 1 2 1 1;
        1 1 1 1 1;
        1 1 1 1 1];
szuro=szuro*(1/26);
Matrix=[1 1 1 1 1 1 1 1 1 1 1;
        1 1 1 1 1 1 1 1 1 1 1;
        0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0;
        -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1;
        -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
 Matrix=Matrix*(1/22);
 Matrix2=[1 1 0 0 0 0 0 0 0 -1 -1;         
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1;
          1 1 0 0 0 0 0 0 0 -1 -1];
 Matrix2=Matrix2*(1/22);
%% elj�r�s
im=conv2(img,szuro,'valid');
dx=conv2(im,Matrix,'valid');
dy=conv2(im,Matrix2,'valid');
gradtmp=abs(dx)+abs(dy);
%gradiens k�p tetej�nek �s alj�nak 
[x,y]=size(gradtmp);
for i=1:57
    for j=1:y
        gradtmp(i,j)=0;
    end
end
for i=x-100:x
    for j=1:y
        gradtmp(i,j)=0;
    end
end
grad=gradtmp;
end

