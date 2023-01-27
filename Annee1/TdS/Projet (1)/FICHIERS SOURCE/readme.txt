--Liste des codes fournis--

modulateur.m :
- Role : Fonction qui génère le signal modulé à partir d'une suite de bits 
- Utilisation : Fonction à appeler dans un script avec matlab

signal_module_bruit.m :
- Role : Script qui traite les parties 2 et 3 du projet (Modem de fréquence et Canla de transmission à bruit additif blanc et gaussien)
- Utilisation : Lancer le script avec matlab

demodulateur_filtre.m :
- Role : Fonction qui retrouve par filtrage une suite de bits à partir d'un signal modulé
- Utilisation : Fonction à appeler dans un script avec matlab

modem_filtre.m :
- Role : Script qui traite la partie 4 du projet (démodulation par filtrage)
- Utilisation : Lancer le script avec matlab

demudulateur_V21_synchrone.m :
- Role : Fonction qui retrouve par démodulation synchrone une suite de bits à partir d'un signal modulé
- Utilisation : Fonction à appeler dans un script avec matlab

demudulateur_V21_phase.m :
- Role : Fonction qui retrouve par démodulation asynchrone une suite de bits à partir d'un signal modulé
- Utilisation : Fonction à appeler dans un script avec matlab

modemV21.m :
- Role : Script qui traite la partie 5 du projet (démodulation de fréquence adapté à la norme V21)
- Utilisation : Lancer le script avec matlab

traiter_fichiers.m
- Role : Script qui retrouve l'image modulée dans les fichiers .mat fournis
- Utilisation : Lancer le script avec matlab
