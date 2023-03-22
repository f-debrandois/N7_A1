package jeu;

public class Test {

	public static void main(String[] args) {
		for (int k = 1; k < 105; k++) {
			Carte carte = new Carte(k);
			carte.afficher();
			System.out.println();
		}

	}

}
