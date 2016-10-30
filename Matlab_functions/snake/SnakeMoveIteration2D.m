function P=SnakeMoveIteration2D(B,P,Fext,gamma,kappa,delta,shape,sizeweight,model,expectedSize)
% This function will calculate one iteration of contour Snake movement
%
% P=SnakeMoveIteration2D(S,P,Fext,gamma,kappa)
%
% inputs,
%   B : Internal force (smoothness) matrix
%   P : The contour points N x 2;
%   Fext : External vector field (from image)
%   gamma : Time step
%   kappa : External (image) field weight
%   delta : Balloon Force weight
%   shape: alak igazítási eggyütható
%   sizeweight:méretigazítási együttható
% outputs,
%   P : The (moved) contour points N x 2;
%
% Function is written by D.Kroon University of Twente (July 2010)

% Clamp contour to boundary
P(:,1)=min(max(P(:,1),1),size(Fext,1));
P(:,2)=min(max(P(:,2),1),size(Fext,2));

% Get image force on the contour points
Fext1(:,1)=kappa*interp2(Fext(:,:,1),P(:,2),P(:,1));
Fext1(:,2)=kappa*interp2(Fext(:,:,2),P(:,2),P(:,1));
% Interp2, can give nan's if contour close to border
Fext1(isnan(Fext1))=0;

% Calculate the baloonforce on the contour points
N=GetContourNormals2D(P);
Fext2=delta*N;

%kiszámolni az alakösszetevõt
%[oneD,~]=TwoD2oneD(P);
%[~,derivedshape]=DTWPatternRecogniser(oneD,model);
%Shape=CalculateDerivatedPosition(P,derivedshape);
%Fshape=Shape*shape;

%Méret módosítás kiszámítása
Fsize=N*sizeweight*sizeDerived(P,expectedSize,size(Fext,1),size(Fext,2));

% Update contour positions
ssx = gamma*P(:,1) + Fext1(:,1) + Fext2(:,1)+Fsize(:,1);%+Fshape(:,1);
ssy = gamma*P(:,2) + Fext1(:,2) + Fext2(:,2)+Fsize(:,2);%+Fshape(:,2);
P(:,1) = B * ssx;
P(:,2) = B * ssy;

% Clamp contour to boundary
P(:,1)=min(max(P(:,1),1),size(Fext,1));
P(:,2)=min(max(P(:,2),1),size(Fext,2));

    
