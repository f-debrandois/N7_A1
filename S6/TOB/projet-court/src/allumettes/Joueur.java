package allumettes;


/** Définit toutes les actions possibles pour le joueur.
 * @author	Félix Foucher de Brandois
 */
public class Joueur {

	/** Nom du joueur. */
	private String nomJoueur;

	/** Stratégie du joueur. */
	private Strategie strategie;

	/** Construire un joueur à partir d'un nom et d'une stratégie.
	 * @param nom Nom du joueur
	 * @param strategie Stratégie du joueur
	 */
	public Joueur(String nom, Strategie strategie) {
		this.nomJoueur = nom;
		this.strategie = strategie;
	}

	/** Renvoie le nom du joueur.
	 * @return Le nom du joueur
	 */
	public String getNom() {
		return this.nomJoueur;
	}

	/** Renvoie la stratégie du joueur.
	 * @return La stratégie du joueur
	 */
	public Strategie getStrategie() {
		return this.strategie;
	}

	/** Changer la stratégie du joueur.
	 * @param strat La nouvelle stratégie du joueur
	 */
	public void setStrategie(Strategie strat) {
		this.strategie = strat;
	}

	/** Renvoie le nombre d'allumettes prises par le joueur.
	 * @return Le nombre d'allumettes prises par le joueur
	 * @param jeu Le jeu en cours
	 */
	public int getPrise(Jeu jeu) {
		return this.strategie.getPrise(jeu);
	}

}
