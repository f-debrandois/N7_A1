
import afficheur.Ecran;
import java.awt.Color;

/**Exemple d'utilisation de la classe Ecran.*/
class ExempleEcran {

	public static void main(String[] args) {
		// Construire un écran
		Ecran ecran = new Ecran("ExempleEcran", 400, 250, 15);
		ecran.dessinerAxes();

		// Dessiner un point vert de coordonnées (1, 2)
		ecran.dessinerPoint(1, 2, Color.green);
		
		// Dessiner une ligne entre les points (6, 2) et (11, 9) de couleur rouge
		ecran.dessinerLigne(6, 2, 11, 9, Color.red);

		// Dessiner un cercle jaune de centre (4, 4) et rayon 2.5
		ecran.dessinerCercle(4, 4, 2.5, Color.yellow);

		// Dessiner le texte "Premier dessin" en bleu à la position (1, -2)
		ecran.dessinerTexte(1, -2, "premier dessin", Color.blue);
	}

}
