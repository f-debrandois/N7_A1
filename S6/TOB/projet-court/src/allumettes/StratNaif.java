package allumettes;

public class StratNaif implements Strategie {

	@Override
	public int getPrise(Jeu jeu) {
		int nbAlumettes = jeu.getNombreAllumettes();
		int prise = 1;

		java.util.Random random = new java.util.Random();
		if (nbAlumettes >= Jeu.PRISE_MAX) {
			prise = (int) (random.nextInt(Jeu.PRISE_MAX) + 1);
		} else if (nbAlumettes == 1) {
			prise = 1;
		} else {
			prise = (int) (random.nextInt(nbAlumettes) + 1);
		}
		return prise;
	}

}
