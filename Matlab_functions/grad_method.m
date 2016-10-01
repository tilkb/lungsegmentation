function [masks,leftcenters,rightcenters] = grad_method(grads,imgs,options)
%grad Gradiens alapon gener�l maszkokat
%   grads:gradiens k�pek t�mbje
%   masks:visszadott bin�ris maszk
%% be�ll�t�sok
felezo=0.5;
%feldolgoz�shoz sz�ks�ges f�gg�leges �sszenyom�s m�rt�ke
f_osszenyom=0.5;
%gradiens k�pek �sszemos�sn�l haszn�latos sz�r�s �rt�k(0 eset�n nincs
%�sszemos�s)
grad_szigma=2;
%gradiens k�pek �sszemos�s�n�l h�ny szomsz�dos k�pet haszn�ljon fel.
% 0 eset�n nincs �sszemos�s 
gradgauss_count=2;
%megb�zhat� k�pek sim�t�sa, szoras...0 eset�n nincs sim�t�s
high_szigma=2;
%nem megb�zhat� k�pekn�l alkalmazott pol�ris k�pek vertik�lis simit�s�nak
%sz�r�sa befel� ir�nyban(�rdemes nagyobbat megadni, mert akkor befel�
%hajlamosabb mozdulni
low_inside_szigma1=10;
%nem megb�zhat� k�pekn�l alkalmazott pol�ris k�pek vertik�lis simit�s�nak
%sz�r�sa kifel� ir�nyban
low_outside_szigma1=3;
%nem megb�zhat� k�pekn�l k�pek k�z�tti sz�r�s(szomsz�dokhoz k�pest)
low_szigma2=10;
%nem megb�zhat� k�pekn�l h�ny szomsz�d k�pet haszn�ljon(0 eset�n nem
%haszn�l)
low_count=2;
%% megb�zhat� szeletek alapj�n k�z�ppont keres�se
left.x=0;
left.y=0;
right.x=0;
right.y=0;
for file=options.start_high:options.end_high
    %centrum meghat�roz�sa
    cm=colormask(imgs{file});
    
    [ax,ay]=size(grads{file});
    [bx,by]=size(imgs{file});
    [leftcenter,rightcenter]=get_centers(cm);
    %�sszenyom�sos koordin�t�kba �tsz�mol�s;
    left.x=left.x+round((leftcenter.x+(ax-bx)/2)*f_osszenyom);
    left.y=left.y+round(leftcenter.y+(ay-by)/2);
    right.x=right.x+round((rightcenter.x+(ax-bx)/2)*f_osszenyom);
    right.y=right.y+round(rightcenter.y+(ay-by)/2);
end
%k�z�ppontok �tlagol�sa
left.x=round(left.x/(options.end_high-options.start_high+1));
left.y=round(left.y/(options.end_high-options.start_high+1));
right.x=round(right.x/(options.end_high-options.start_high+1));
right.y=round(right.y/(options.end_high-options.start_high+1));
%%�ltal�nos dolgok kisz�mol�sa
for file=1:length(grads)
    %k�z�ppontok hozz�rendel�se
    leftcenters{file}.x=round(left.x*(1/f_osszenyom));
    leftcenters{file}.y=left.y;
    rightcenters{file}.x=round(right.x*(1/f_osszenyom));
    rightcenters{file}.y=right.y;
    for i=1:gradgauss_count*2+1
        %figyelni kell, nehogy t�lindexel�s legyen      
        bemenet{i}=grads{min(max(file-gradgauss_count+i-1,1),length(grads))};
    end
    if grad_szigma~=0
      filtered=gauss_pixel(bemenet,grad_szigma);
    else
        filtered=grads{file};
    end
    [a,b]=size(filtered);
    f_image=imresize(filtered,[round(a*f_osszenyom) b]);
    [a,b]=size(f_image);
    polar_grad_left{file}=imgpolarcoord(split(f_image,'right'),a,360,left.x,left.y);
    polar_grad_right{file}=imgpolarcoord(split(f_image,'left'),a,360,right.x,right.y);
    %debug
    if options.fulldebug==true
        cm=colormask(imgs{file});
        imwrite(cm,strcat(options.prefix,'_colormask_',num2str(file),'.png'));
        imwrite(f_image,strcat(options.prefix,'_gradiens_',num2str(file),'.png'));
    end
end
%%megb�zat� szeletek feldolgoz�sa
for file=options.start_high:options.end_high
    c_left{file}=contourfinder(polar_grad_left{file});
    c_right{file}=contourfinder(polar_grad_right{file});
end
%k�pek k�z�tti sim�t�s
c_left=kozep_simito(c_left);
c_right=kozep_simito(c_right);

N=2*(options.end_high-options.start_high)+1;
alpha=(N-1)/(2*high_szigma);
window = gausswin(N,alpha);
for file=options.start_high:options.end_high 
    if high_szigma~=0
      for i=1:length(c_left{file})
          contour_left{file}(i)=0;
          contour_right{file}(i)=0;
          sum=0;
        for j=options.start_high:options.end_high
            sum=sum+window(options.end_high-options.start_high+1+j-file);
            contour_left{file}(i)=contour_left{file}(i)+window(options.end_high-options.start_high+1+j-file)*c_left{file}(i);
            contour_right{file}(i)=contour_right{file}(i)+window(options.end_high-options.start_high+1+j-file)*c_right{file}(i);
        end 
        %normaliz�l�s
        contour_left{file}(i)=round(contour_left{file}(i)*(1/sum));
        contour_right{file}(i)=round(contour_right{file}(i)*(1/sum));
      end
    else
        contour_left{file}=c_left{file};
        contour_right{file}=c_right{file};
    end
end
%%nem megb�zhat� szeletek feldolgoz�sa
%a front�lis szeletek feldolgoz�sa
for file=options.start_high-1:-1:1
    %szomsz�dos vektorok el��ll�t�sa
    for i=1:low_count
        temp_left{i}=contour_left{min(file+i,options.end_high)};
        temp_right{i}=contour_right{min(file+i,options.end_high)};
    end
    %gauss sim�t�s
    if low_count~=0
      polar_grad_left{file}=gauss_simitas(polar_grad_left{file},low_inside_szigma1,temp_left,low_szigma2,low_outside_szigma1);
      polar_grad_right{file}=gauss_simitas(polar_grad_right{file},low_inside_szigma1,temp_right,low_szigma2,low_outside_szigma1);
    end 
    contour_left{file}=contourfinder(polar_grad_left{file});
    contour_right{file}=contourfinder(polar_grad_right{file});
end

%h�ts� szeletek feldolgoz�sa
for file=options.end_high+1:length(grads)
   %szomsz�dos vektorok el��ll�t�sa
    for i=1:low_count
        temp_left{i}=contour_left{max(file-i,options.start_high)};
        temp_right{i}=contour_right{max(file-i,options.start_high)};
    end
    %gauss sim�t�s
    if low_count~=0
      polar_grad_left{file}=gauss_simitas(polar_grad_left{file},low_inside_szigma1,temp_left,low_szigma2);
      polar_grad_right{file}=gauss_simitas(polar_grad_right{file},low_inside_szigma1,temp_right,low_szigma2);
    end 
    contour_left{file}=contourfinder(polar_grad_left{file});
    contour_right{file}=contourfinder(polar_grad_right{file});  
end
%%maszkok el��ll�t�sa
for file=1:length(grads)
    [ax,ay]=size(grads{file});
    [bx,by]=size(imgs{file});
    %bal
    for i=length(contour_left{file}):-1:1
      hol=contour_left{file}(i);
      %fegyelembe v�ve, hogy mekkorra a sz�gfelbont�s
      [a,b]=pol2cart((i)*pi/round(length(contour_left{file})/2),hol);
      %�sszenyom�s, konvol�ci� eltol�d�s�nak intert�l�sa
      result_x(i)=round((bx-ax)/2+(b+left.x)*(1/f_osszenyom));
      result_y(i)=round((by-ay)/2+a+left.y);
    end  
    [x,y]=size(imgs{file});
    left_mask=poly2mask(result_y,result_x,x,y);
    %jobb
    for i=length(contour_right{file}):-1:1
       hol=contour_right{file}(i);
      [a,b]=pol2cart((i)*pi/round(length(contour_left{file})/2),hol);
      result_x(i)=round((bx-ax)/2+(b+right.x)*(1/f_osszenyom));
      result_y(i)=round((by-ay)/2+a+right.y);
    end  
    right_mask=poly2mask(result_y,result_x,x,y);  
    mask(:,1:round(felezo*y))=left_mask(:,1:round(felezo*y));
    mask(:,round(felezo*y):y)=right_mask(:,round(felezo*y):y);
    masks{file}=mask;
    %debug cuccok ki�r�sa
    if options.fulldebug==true
        imwrite(mask,strcat(options.prefix,'_grad_mask_',num2str(file),'.png'));
       
         %bal oldali polar k�p
        debug_image=polar_grad_left{file};
        for i=1:length(contour_left{file})
            debug_image(contour_left{file}(i),i)=1;
        end
         imwrite(debug_image,strcat(options.prefix,'_polar_left_',num2str(file),'.png'));
         %jobb oldali polar k�p
         debug_image=polar_grad_right{file};
        for i=1:length(contour_right{file})
            debug_image(contour_right{file}(i),i)=1;
        end
         imwrite(debug_image,strcat(options.prefix,'_polar_right_',num2str(file),'.png'));
    end   
end
end

