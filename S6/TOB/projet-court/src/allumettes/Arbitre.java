package allumettes;

/** Donne l'avancement de la partie et vérifie son bon déroulement.
 * @author	Félix Foucher de Brandois
 */
public class Arbitre {

	/** Liste des joueurs de la partie. */
	private Joueur[] joueurs = new Joueur[Jouer.NB_JOUEURS];


	/** Construire un arbitre à partir de deux joueurs.
	 * @param j1 Joueur 1
	 * @param j2 Joueur 2
	 */
	public Arbitre(Joueur j1, Joueur j2) {
		this.joueurs[0] = j1;
		this.joueurs[1] = j2;
	}

	/** Renvoie la liste des joueurs de la partie.
	 * @return la liste des joueurs de la partie
	 */
	public Joueur[] getJoueurs() {
		return this.joueurs;
	}

	/** Déterminer le joueur qui doit jouer,
	 * et afficher les allumettes restantes et le coup du joueur.
	 * @param jeu Jeu en cours
	 */
	public void arbitrer(Jeu jeu) {

		int indiceJoueur = 0; // Numéro du joueur courant

		int nbJoueurs = Jouer.NB_JOUEURS;

		try {
			while (jeu.getNombreAllumettes() > 0) {
				Joueur joueurCourant = this.joueurs[indiceJoueur];
				System.out.println("Allumettes restantes : " + jeu.getNombreAllumettes());

				// Détermination du nombre d'allumettes prises par le joueur
		        int prise;
		        if (!Jouer.getConfiant()) {
		        	Jeu jeuProcuration = new Procuration(jeu);
		        	prise = joueurCourant.getPrise(jeuProcuration);
		        } else {
		        	prise = joueurCourant.getPrise(jeu);
		        }

		        // Affichage du nombre d'allumettes prises par le joueur
		        System.out.print(joueurCourant.getNom()
		        		+ " prend " + prise);
		        if (Math.abs(prise) <= 1) {
		        	System.out.println(" allumette.");
		        } else {
		        	System.out.println(" allumettes.");
		        }

		        // On retire les allumettes de la partie, si la prise est valide
	        	try {
	        		jeu.retirer(prise);
					indiceJoueur = (indiceJoueur + 1) % nbJoueurs;
	        	} catch (CoupInvalideException e) {
	    			System.out.println("Impossible ! Nombre invalide : "
	    			+ e.getCoup() + e.getProbleme());
		        	}
	        	System.out.println();
			}

			// Affichage du perdant et du gagnant
			int indicePerdant = ((indiceJoueur - 1) % nbJoueurs + nbJoueurs) %  nbJoueurs;
			System.out.println(joueurs[indicePerdant].getNom() + " perd !");
			for (int i = 0; i < this.joueurs.length; i++) {
				if (i != indicePerdant) {
					System.out.println(this.joueurs[i].getNom() + " gagne !");
				}
			}

		// Fin du jeu si triche
		} catch (OperationInterditeException e) {
			System.out.println("Abandon de la partie car "
					+ this.joueurs[indiceJoueur].getNom() + " triche !");
		}
	}

}
