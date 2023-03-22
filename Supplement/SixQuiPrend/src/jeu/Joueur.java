package jeu;

/** Définit toutes les actions possibles pour le joueur.
 * @author Félix Foucher de Brandois
 */
public class Joueur {

	/** Nom du joueur. */
	private String nomJoueur;

	/** Cartes du joueur. */
	private Carte[] cartes;

	/** Stratégie du joueur. */
	Strategie strategie;

	/** Construire un joueur à partir d'un nom.
	 * @param nom Nom du joueur
	 */
	public Joueur(String nom, Carte[] cartes, Strategie strat) {
		this.nomJoueur = nom;
		this.cartes = cartes;
		this.strategie = strat;
	}

	/** Renvoie le nom du joueur.
	 * @return Le nom du joueur
	 */
	public String getNom() {
		return this.nomJoueur;
	}

	public Carte getCarte(Jeu jeu) {
		return new Carte(2);
	}


}
