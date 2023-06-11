import java.awt.Color;
import org.junit.*;
import static org.junit.Assert.*;

/**
 * Classe de test (exigences E12 E13 et E14) de la classe Cercle.
 * @author	Félix Foucher de Brandois
 * @version	$Revision$
 */
public class CercleTest {

	// précision pour les comparaisons réelle
	public static final double EPSILON = 0.001;

	// Les points du sujet
	private Point A, B, C;

	// Les cercles du sujet
	private Cercle C1, C2, C3;

	/** Construction des objets de test. */
	@Before public void setUp() {
		// Construire les points
		A = new Point(1, 2);
		B = new Point(4, 6);
		C = new Point(2.5, 4);

		// Construire les cercles
		C1 = new Cercle(A, B);
		C2 = new Cercle(A, B, Color.green);
		C3 = Cercle.creerCercle(A, B);
	}

	/** Vérifier si deux points ont mêmes coordonnées.
	 * @param message le message affiché en cas d'erreur
	 * @param p1 le premier point
	 * @param p2 le deuxième point
	 */
	static void memesCoordonnees(String message, Point p1, Point p2) {
		assertEquals(message + " (x)", p1.getX(), p2.getX(), EPSILON);
		assertEquals(message + " (y)", p1.getY(), p2.getY(), EPSILON);
	}

	/** Test de E12. */
	@Test public void testerE12() {
		memesCoordonnees("E12 : Centre de C1 incorrect", C, C1.getCentre());
		assertEquals("E12 : Rayon de C1 incorrect",
				2.5, C1.getRayon(), EPSILON);
		assertEquals(Color.blue, C1.getCouleur());
	}

	/** Test de E13. */
	@Test public void testerE13() {
		memesCoordonnees("E13 : Centre de C2 incorrect", C, C2.getCentre());
		assertEquals("E13 : Rayon de C2 incorrect",
				2.5, C2.getRayon(), EPSILON);
		assertEquals(Color.green, C2.getCouleur());
	}

	/** Test de E14. */
	@Test public void testerE14() {
		memesCoordonnees("E14 : Centre de C3 incorrect", A, C3.getCentre());
		assertEquals("E14 : Rayon de C3 incorrect",
				5, C3.getRayon(), EPSILON);
		assertEquals(Color.blue, C3.getCouleur());
	}

}
