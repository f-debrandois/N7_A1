% Image à retrouver
%Felix Foucher
%Achraf Marzougui

clear all ; close all;

images = zeros(105, 100, 6);

for i = 1 : 6
    load(sprintf('fichier%d.mat', i))
    image(:, :, i) = reconstitution_image(demodulateur_V21_phase(signal));
end
