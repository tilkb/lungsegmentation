%%ezzel a programmal lehet axiális maszkokat átvetíten tomo maszkokra
functionname='tomo_vetites.m'; 
functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
%hozzá kell adni a függvénykönyvtárat
addpath([functiondir 'Matlab_functions']);
pngFiles = dir([functiondir 'temp\segmented\mask\*.png']);
%beolvasás kezete
test=zeros(length(pngFiles),512,512);
for file=1:length(pngFiles)
    im=imread([functiondir 'temp\segmented\mask\' pngFiles(file).name]);
    test(file,:,:)=im';
end
%transzformációs mátrix kiszámítása
load('Trafo.mat');
M_=inv(M);
%vetítés
[alfa,beta,gamma]=size(test);
for file=1:225
    tomoIMG=zeros(1529,1529);
    for i=1:1529
        for j=1:1529
            pont=M_*[i;j;file;1];
            if (pont(1)>=1 && pont(1)<=alfa && pont(2)>=1 && pont(2)<=beta && pont(3)>=1 && pont(3)<=gamma)              
                temp=test(round(pont(1)),round(pont(2)),round(pont(3)));
                if (temp~=0)
                    tomoIMG(i,j)=1;
                end
            end
        end
    end
    imwrite(tomoIMG,strcat([functiondir 'temp\segmented\mask_tomo\MASK'],num2str(file,'%3.3d'),'.png'));
end


%             pont=M_*[i;j;file;1];
%             if (pont(1)>=1 && pont(1)<=alfa && pont(2)>=1 && pont(2)<=beta && pont(3)>=1 && pont(3)<=gamma)              
%                 temp=test(round(pont(1)),round(pont(2)),round(pont(3)));