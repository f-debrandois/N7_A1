% Image à retrouver
%Felix Foucher
%Achraf Marzougui

clear all ; close all;

image = zeros(105, 100, 6);

for i = 1 : 6
    load(sprintf('fichier%d.mat', i))
    bits = demodulateur_V21_phase(signal);
    image(:, :, i) = reconstitution_image(bits);
    % imagesc(image(:, :, i), [0, 255])
end