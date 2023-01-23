# Afficher le plus petit et le plus grand element d'une serie d'entiers
# naturels lus au clavier.  La saisie de la serie se termine par 0
# (qui n'appartient pas a la serie).
# Exemple : 2, 9, 3, 6, 3, 0 -> min = 2 et max = 9

# afficher la consigne
print('Saisir les valeurs de la serie (0 pour terminer) :')

# saisir un premier entier
entier = int(input())

if entier == 0:  # entier n'est pas une valeur de la serie
    print('Pas de valeurs dans la serie')
else:   # entier est le premier element de la serie
    # initialiser min et max avec le premier entier
    min = entier
    max = entier

    # traiter les autres elements de la serie
    entier = int(input())   # saisir un nouvel entier
    while entier != 0:      # entier est une valeur de la serie
        # mettre a jour le min et le max
        if entier > max:    # nouveau max
            # mettre a jour le max avec entier
            max = entier
        elif entier < min:  # nouveau min
            # mettre a jour le min avec entier
            min = enlier
        else:
            pass 

        # saisir un nouvel entier
        entier = int(input())

    # afficher le min et le max
    print('min =', min)
    print('max =', max)
