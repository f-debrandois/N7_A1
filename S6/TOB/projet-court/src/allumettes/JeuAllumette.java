package allumettes;

public class JeuAllumette implements Jeu {

	/** Nombre d'allumettes en jeu. */
	private int nbAllumette;

	/** Construire un jeu à partir d'un nombre donné d'allumettes de départ.
	 * @param nbAllumette Nombre d'allumettes de départ
	 */
    public JeuAllumette(int nbAllumette) {
    	this.nbAllumette = nbAllumette;
    }

	/** Obtenir le nombre d'allumettes encore en jeu.
	 * @return nombre d'allumettes encore en jeu
	 */
	@Override
	public int getNombreAllumettes() {
		return nbAllumette;
	}

	/** Retirer des allumettes.  Le nombre d'allumettes doit être compris
	 * entre 1 et PRISE_MAX, dans la limite du nombre d'allumettes encore
	 * en jeu.
	 * @param nbPrises nombre d'allumettes prises.
	 * @throws CoupInvalideException tentative de prendre un nombre invalide d'allumettes
	 */
	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		if (nbPrises > this.nbAllumette) {
			throw new CoupInvalideException(nbPrises,  " (> " + this.nbAllumette + ")");
		} else if (nbPrises > Jeu.PRISE_MAX) {
			throw new CoupInvalideException(nbPrises,  " (> " + Jeu.PRISE_MAX + ")");
		} else if (nbPrises < 1) {
			throw new CoupInvalideException(nbPrises,  " (< 1)");
		}
		this.nbAllumette -= nbPrises;
	}

}
