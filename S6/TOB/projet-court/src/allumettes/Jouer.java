package allumettes;

import java.util.Scanner;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {

	/** Nombre de joueurs. */
	static final int NB_JOUEURS = 2;

	/** Nombre d'allumettes au départ. */
	static final int NB_DEPART = 13;

	/** Confiance. */
	private static boolean confiant;

	/** Clavier. */
	static final Scanner CLAVIER = new Scanner(System.in);

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		try {
			verifierNombreArguments(args);
			verifierConfiant(args);

			// Création d'une variable qui contient tous les joueurs
			Joueur[] tousJoueurs = new Joueur[NB_JOUEURS];

			for (int i = 0; i < NB_JOUEURS; i++) {
				String[] jString = args[args.length - NB_JOUEURS + i].split("@");

				if (jString.length != 2) {
					throw new ConfigurationException("Arguments incorrects : "
							+ args[args.length - NB_JOUEURS + i]);
				}

				// Création du joueur i
				tousJoueurs[i] = new Joueur(jString[0],
						verifierNomStrategie(jString[0], jString[1]));
			}

			// Mise en place je jeu
			Jeu jeu = new JeuAllumette(NB_DEPART);
			Arbitre arbitre = new Arbitre(tousJoueurs[0], tousJoueurs[1]);

			// Lancement du jeu
			arbitre.arbitrer(jeu);

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
	}

	private static void verifierNombreArguments(String[] args) {
		if (args.length < NB_JOUEURS) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > NB_JOUEURS + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

	/** Vérifier si l'argument de confiance est présent
	 * et si il est correctement écrit.
	 * @param args Arguments de la ligne de commande
	 */
	private static void verifierConfiant(String[] args) {
		if (args.length == NB_JOUEURS + 1) {
			if (args[0].equals("-confiant")) {
				Jouer.confiant = true;
			} else {
				throw new ConfigurationException("Arguments incorrects.");
			}
		}
	}

	/** Vérifier si la stratégie en argument est disponible.
	 * @param nomJoueur Nom du joueur en chaîne de caractère
	 * @param stratString Stratégie du joueur en chaîne de caractère
	 * @return strat La stratégie du joueur
	 */
	private static Strategie verifierNomStrategie(String nomJoueur, String stratString) {
		Strategie strat;
		switch (stratString) {
		case "humain":
			strat = new StratHumain(nomJoueur);
			break;
		case "rapide":
			strat = new StratRapide();
			break;
		case "naif":
			strat = new StratNaif();
			break;
		case "expert":
			strat = new StratExpert();
			break;
		case "tricheur":
			strat = new StratTricheur();
			break;
		default:
			throw new ConfigurationException("Nom de stratégie incorrect : "
					+ stratString);
		}
		return strat;
	}

	/** Renvoie le niveau de confiance accordé dans la partie.
	 * @return La valeur de confiance
	 */
	public static boolean getConfiant() {
		return Jouer.confiant;
	}

}
