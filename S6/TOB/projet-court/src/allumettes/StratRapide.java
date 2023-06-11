package allumettes;

public class StratRapide implements Strategie {

	@Override
	public int getPrise(Jeu jeu) {
		int nbAlumettes = jeu.getNombreAllumettes();
		int prise = 1;

		if (nbAlumettes >= Jeu.PRISE_MAX) {
			prise = Jeu.PRISE_MAX;
		} else {
			prise = nbAlumettes;
		}
		return prise;
	}

}
