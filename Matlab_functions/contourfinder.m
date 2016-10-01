function [result] = contourfinder(img,options)
%contourfinder: Polárkoordinátás képen megkeresi a 
%legerõsebbnek vélt körvonalat Summary of this function goes here
%img:a kép polárkoordinátába transzformálva
%options: esetleges beállítások átvétele
%         -w_int:belsõ energia
%         -w_ext:külsõ energia(pont távolság)
%         -w_smooth: simaság
%         -w_maxpix:maximális pixelugrás nagysága
%result: vektor amely minden oszlopra megadja az ideális pont helyét
%% dinamius keresés beállításai
%pixel erõssége(belsõ energia)
w_int=1;
%külsõ energia, milyen távol van egymástól a 2 pont
w_ext=0.1;
%a recéségnek a büntetése
w_smooth=0;
%maxiális pixeltávolság
maxpix=6;%8

%ha megadják a beállításokat, akkor azokat használjuk
if exist('options','var') == 1
      w_int=options.w_int;
      w_ext=options.w_ext;
      w_smooth=options.w_smooth;
      maxpix=options.maxpix;
end
%% eljárás
[x,y]=size(img);
c=zeros(x,y);
start=zeros(x,y);
F=zeros(x,y);
for i=1:x
    c(i,1)=-img(i,1)*w_int;
    start(i,1)=i;
end
for i=2:y%oszlop
    for j=1:x%sor
     E_int=-img(j,i);    
     min=1000000;
     hol=1;
     E_smooth=0;
     for t=-maxpix:maxpix
         if (j+t>0 && j+t<=x)
             if (i>2) &&((j<j+t && F(j+t,i-1)<j+t) || (j>j+t && F(j+t,i-1)>j+t))
               E_smooth=(abs(t)+abs((F(j+t,i-1)-(j+t))))/(2*j+t);
             end
           E_ext=abs(t)/(2*j+t);
           if min>(c(j+t,i-1)+E_ext*0.1+E_smooth*w_smooth)
               min=c(j+t,i-1);
               hol=j+t;             
           end
         end
     end
     E_ext=abs(hol-j)/(hol+j);
     if (i>2 && (j<hol && F(hol,i-1)<hol) || (j>hol && F(hol,i-1)>hol))
        E_smooth=abs(hol-j)+abs((F(hol,i-1)-(hol)));
     end
     E=w_int*E_int+w_ext*E_ext+E_smooth*w_smooth;
     c(j,i)=min+E;
     start(j,i)=start(hol,i-1);
     F(j,i)=hol;  
    end   
end
%megkeresni a tömbben a legjobbat
 min=100000;
 hol=1;
for i=1:x
   if (min>c(i,y) && abs(start(i,y)-i)<maxpix)
     min=c(i,y);
     hol=i;
   end  
end 
result=zeros(y);
result(y)=hol;
result(1)=start(hol,y);
for i=y-1:-1:2
    hol=F(hol,i);
    result(i)=hol;
end  
end

