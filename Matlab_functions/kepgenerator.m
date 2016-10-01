function [im,grad] = kepgenerator(img)
%kepgenerator néhány szûrést végez és a létrehozott képeket visszaadja
%   im:szûrt kép
%   grad:a visszaadott gradiens kép
%   img: eredeti kép(~512*512-re optimalizálva) 
%% beállítások
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
%% eljárás
im=conv2(img,szuro,'valid');
dx=conv2(im,Matrix,'valid');
dy=conv2(im,Matrix2,'valid');
gradtmp=abs(dx)+abs(dy);
%gradiens kép tetejének és aljának 
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

