import java.awt.Color;
import afficheur.AfficheurSVG;
import afficheur.Ecran;

/** Construire le schéma proposé dans le sujet de TP avec des points,
  * et des segments.
  *
  * @author	Xavier Crégut
  * @version	$Revision: 1.7 $
  */
public class ExempleSchema1 {

	/** Construire le schéma et le manipuler.
	  * Le schéma est affiché.
	  * @param args les arguments de la ligne de commande
	  */
	public static void main(String[] args)
	{
		Ecran ecran = new Ecran("ExempleSchema1", 600, 400, 20);
		ecran.dessinerAxes();
		
		// Créer les trois segments
		Point p1 = new Point(3, 2);		
		Point p2 = new Point(6, 9);
		Point p3 = new Point(11, 4);
		ecran.dessinerPoint(p1.getX(), p1.getY(), Color.green);
		ecran.dessinerPoint(p2.getX(), p2.getY(), Color.green);
		ecran.dessinerPoint(p3.getX(), p3.getY(), Color.green);
		
		Segment s12 = new Segment(p1, p2);
		Segment s23 = new Segment(p2, p3);
		Segment s31 = new Segment(p3, p1);
		ecran.dessinerLigne(p1.getX(), p1.getY(), p2.getX(), p2.getY(), Color.blue);
		ecran.dessinerLigne(p2.getX(), p2.getY(), p3.getX(), p3.getY(), Color.blue);
		ecran.dessinerLigne(p3.getX(), p3.getY(), p1.getX(), p1.getY(), Color.blue);
		
		// Créer le barycentre
		double sx = p1.getX() + p2.getX() + p3.getX();
		double sy = p1.getY() + p2.getY() + p3.getY();
		Point barycentre = new Point(sx / 3, sy / 3);
		ecran.dessinerPoint(barycentre.getX(), barycentre.getY(), Color.red);

		// Afficher le schéma
		System.out.println("Le schéma est composé de : ");
		s12.afficher();		System.out.println();
		s23.afficher();		System.out.println();
		s31.afficher();		System.out.println();
		barycentre.afficher();	System.out.println();
		
		// Exercice 3 : Translater le schéma
		p1.translater(4, -3);
		p2.translater(4, -3);
		p3.translater(4, -3);
		barycentre.translater(4, -3);
		
		// Afficher et dessiner de nouveau
		System.out.println("Le schéma est composé de : ");
		s12.afficher();		System.out.println();
		s23.afficher();		System.out.println();
		s31.afficher();		System.out.println();
		barycentre.afficher();	System.out.println();
		
		ecran.dessinerPoint(p1.getX(), p1.getY(), Color.green);
		ecran.dessinerPoint(p2.getX(), p2.getY(), Color.green);
		ecran.dessinerPoint(p3.getX(), p3.getY(), Color.green);
		ecran.dessinerLigne(p1.getX(), p1.getY(), p2.getX(), p2.getY(), Color.blue);
		ecran.dessinerLigne(p2.getX(), p2.getY(), p3.getX(), p3.getY(), Color.blue);
		ecran.dessinerLigne(p3.getX(), p3.getY(), p1.getX(), p1.getY(), Color.blue);
		ecran.dessinerPoint(barycentre.getX(), barycentre.getY(), Color.red);

		// Exercice 4 : Afficher le schéma en SVG
		AfficheurSVG afficheSVG = new AfficheurSVG();
		afficheSVG.dessinerPoint(p1.getX(), p1.getY(), Color.green);
		afficheSVG.dessinerPoint(p2.getX(), p2.getY(), Color.green);
		afficheSVG.dessinerPoint(p3.getX(), p3.getY(), Color.green);
		afficheSVG.dessinerLigne(p1.getX(), p1.getY(), p2.getX(), p2.getY(), Color.blue);
		afficheSVG.dessinerLigne(p2.getX(), p2.getY(), p3.getX(), p3.getY(), Color.blue);
		afficheSVG.dessinerLigne(p3.getX(), p3.getY(), p1.getX(), p1.getY(), Color.blue);
		afficheSVG.dessinerPoint(barycentre.getX(), barycentre.getY(), Color.red);
		
		// Exercice 5 : Afficher le schéma sous forme d’un texte explicite
		AfficheurTexte affiche = new AfficheurTexte();
		affiche.dessinerPoint(p1.getX(), p1.getY(), Color.green);
		affiche.dessinerPoint(p2.getX(), p2.getY(), Color.green);
		affiche.dessinerPoint(p3.getX(), p3.getY(), Color.green);
		affiche.dessinerLigne(p1.getX(), p1.getY(), p2.getX(), p2.getY(), Color.blue);
		affiche.dessinerLigne(p2.getX(), p2.getY(), p3.getX(), p3.getY(), Color.blue);
		affiche.dessinerLigne(p3.getX(), p3.getY(), p1.getX(), p1.getY(), Color.blue);
		affiche.dessinerPoint(barycentre.getX(), barycentre.getY(), Color.red);
	}

}
