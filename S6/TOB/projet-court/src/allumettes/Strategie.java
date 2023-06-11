package allumettes;

public interface Strategie {

	/** Renvoie le nombre d'allumettes à prendre.
	 * @param jeu Le jeu en cours
	 * @return Le nombre d'allumettes à prendre
	 */
	int getPrise(Jeu jeu);

}
