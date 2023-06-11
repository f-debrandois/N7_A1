package allumettes;

/** Exception qui indique que le joueur fait une tentative de triche.
 * @author	Félix Foucher de Brandois
 */
public class OperationInterditeException extends RuntimeException {

	/** Initaliser une OperationInterditeException avec le message précisé.
	  * @param message le message explicatif
	  */
	public OperationInterditeException(String message) {
		super(message);
	}

}
