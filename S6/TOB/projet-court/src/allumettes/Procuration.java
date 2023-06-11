package allumettes;

/** Proxy qui protège l'action retirer().
 * @author	Félix Foucher de Brandois
 */
public class Procuration implements Jeu {

	/** Jeu en cours. */
    private Jeu jeu;

	/** Construire un proxy sur le jeu en cours.
	 * @param jeu Jeu en cours
	 */
    public Procuration(Jeu jeu) {
    	this.jeu = jeu;
    }

    @Override
    public int getNombreAllumettes() {
        return this.jeu.getNombreAllumettes();
    }

    @Override
    public void retirer(int nbPrises) throws OperationInterditeException {
    	throw new OperationInterditeException("Triche !");
    }

}
