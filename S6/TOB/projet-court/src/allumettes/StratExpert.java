package allumettes;

public class StratExpert implements Strategie {

	@Override
	public int getPrise(Jeu jeu) {
		int nbAlumettes = jeu.getNombreAllumettes();

		int prise = (nbAlumettes + Jeu.PRISE_MAX) % (Jeu.PRISE_MAX + 1);
		if (prise == 0) {
			prise = 1;
		}
		return prise;
	}

}
