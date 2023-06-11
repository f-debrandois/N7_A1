package allumettes;

public class StratTricheur implements Strategie {

	@Override
	public int getPrise(Jeu jeu) {

		System.out.println("[Je triche...]");
		while (jeu.getNombreAllumettes() > 2) {
			try {
				jeu.retirer(1);
			} catch (CoupInvalideException e) {
			e.printStackTrace();
			}
		}
		System.out.println("[Allumettes restantes : 2]");
		return 1;
	}

}
