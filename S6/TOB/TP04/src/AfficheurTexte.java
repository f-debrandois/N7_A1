import java.awt.Color;

import afficheur.Afficheur;

/** Permet d'afficher les points, lignes, cercles et textes sous forme écrite.
 * @author	Félix Foucher de Brandois
 */

public class AfficheurTexte implements Afficheur {

	public void dessinerPoint(double x, double y, Color c) {
		System.out.println("Point {");
		System.out.println("x = " + Double.toString(x));
		System.out.println("y = " + Double.toString(y));
		System.out.println("couleur = " + c);
		System.out.println("}");
	}
	
	public void dessinerLigne(double x1, double y1, double x2, double y2, Color c) {
		System.out.println("Ligne {");
		System.out.println("x1 = " + Double.toString(x1));
		System.out.println("y1 = " + Double.toString(y1));
		System.out.println("x2 = " + Double.toString(x2));
		System.out.println("y2 = " + Double.toString(y2));
		System.out.println("couleur = " + c);
		System.out.println("}");
	}
	
	public void dessinerCercle(double x, double y, double rayon, Color c) {
		System.out.println("Cercle {");
		System.out.println("centre_x = " + Double.toString(x));
		System.out.println("centre_y = " + Double.toString(y));
		System.out.println("rayon = " + Double.toString(rayon));
		System.out.println("couleur = " + c);
		System.out.println("}");
	}

	public void dessinerTexte(double x, double y, String texte, Color c) {
		System.out.println("Texte {");
		System.out.println("x = " + Double.toString(x));
		System.out.println("y = " + Double.toString(y));
		System.out.println("valeur = \"" + texte + "\"");
		System.out.println("couleur = " + c);
		System.out.println("}");
	}

}
