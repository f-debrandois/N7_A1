clear;
close all;
clc;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

figure('Name','ACP d''une image RVB',...
       'Position',[0.1*L,0.05*H,0.8*L,0.75*H]);

% Lecture d'une image RVB :
I = imread('autumn.tif');
% I = imread('image.png');

% Affichage de l'image RVB :
subplot(2,3,1);
imagesc(I);
axis image off;
title('Image RVB','FontSize',20);

% Decoupage de l'image en trois canaux et conversion en doubles :
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));

% Matrice des donnees :
X = [R(:) V(:) B(:)];		% Les trois canaux sont vectorises et concatenes

% Analyse en composantes principales de la matrice X des donnees :
C = ACP(X);
C1 = C(:,1);
C2 = C(:,2);
C3 = C(:,3);

% Affichage de la premiere composante principale :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,3,2);
imagesc(reshape(C1,size(R)));
axis image off;
title('1ere composante principale','FontSize',20);

% Affichage de la deuxieme composante principale :
subplot(2,3,4);
imagesc(reshape(C2,size(V)));
axis image off;
title('2eme composante principale','FontSize',20);

% Affichage de la troisieme composante principale :
subplot(2,3,5);
imagesc(reshape(C3,size(B)));
axis image off;
title('3eme composante principale','FontSize',20);

% Affichage du nuage de pixels dans le repere des composantes principales :
subplot(1,3,3);
plot3(C1,C2,C3,'.','MarkerSize',3,'Color',"#4DBEEE")
axis equal;
set(gca,'FontSize',10);
xlabel('C1','FontWeight','bold','FontSize',15)
ylabel('C2','FontWeight','bold','FontSize',15)
zlabel('C3','FontWeight','bold','FontSize',15)
view([105 30])
rotate3d;
grid on;
title({'Representation 3D des pixels dans' ...
       'l''espace des composantes principales'},'FontSize',20)

[correlation,contraste] = correlation_contraste(C);

% Affichage des resultats :
fprintf('Correlation entre C1 et C2 = %.3f\n',correlation(1));
fprintf('Correlation entre C1 et C3 = %.3f\n',correlation(2));
fprintf('Correlation entre C2 et C3 = %.3f\n',correlation(3));

fprintf('Proportion de contraste dans C1 = %.3f\n',contraste(1));
fprintf('Proportion de contraste dans C2 = %.3f\n',contraste(2));
fprintf('Proportion de contraste dans C3 = %.3f\n',contraste(3));
