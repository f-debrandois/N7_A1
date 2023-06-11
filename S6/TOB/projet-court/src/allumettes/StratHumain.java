package allumettes;

public class StratHumain implements Strategie {

	/** Nom du joueur. */
	private String nomJoueur;

	/** Créer le joueur associé à la stratégie humain.
	 * @param nomJoueur Nom du joueur
	 */
	public StratHumain(String nomJoueur) {
		this.nomJoueur = nomJoueur;
	}

	@Override
	public int getPrise(Jeu jeu) {
		int nbAlumettes = jeu.getNombreAllumettes();
		int prise = 1;

		System.out.print(this.nomJoueur + ", combien d'allumettes ? ");
		try {
			prise = Jouer.CLAVIER.nextInt();
		} catch (java.util.InputMismatchException e) {
			String texte = Jouer.CLAVIER.nextLine();

			if (texte.equals("triche")) {
				System.out.println("[Une allumette en moins, plus que "
			+ (nbAlumettes - 1) + ". Chut !]");
				try {
					jeu.retirer(1);
				} catch (CoupInvalideException e1) {
					e1.printStackTrace();
				}
			} else {
				System.out.println("Vous devez donner un entier.");
			}
			prise = this.getPrise(jeu);
		}
		return prise;
	}

}
