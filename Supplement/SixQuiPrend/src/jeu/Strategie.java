package jeu;

public interface Strategie {

	/** Renvoie la carte tirée par le joueur.
	 */
	int getCarte(Jeu jeu, Joueur joueur);

}
