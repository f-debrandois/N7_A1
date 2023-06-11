import java.awt.Color;
import org.junit.*;
import static org.junit.Assert.*;

/**
 * Classe de test (complements) de la classe Cercle.
 * @author	Félix Foucher de Brandois
 * @version	$Revision$
 */
public class ComplementsCercleTest {

	// précision pour les comparaisons réelle
	public static final double EPSILON = 0.001;

	// Les points du sujet
	private Point A, B;

	// Les cercles du sujet
	private Cercle C1, C2, C3;

	/** Construction des objets de test. */
	@Before public void setUp() {
		// Construire les points
		A = new Point(1, 2);
		B = new Point(4, 6);

		// Construire les cercles
		C1 = new Cercle(A, B);
		C2 = new Cercle(A, B, Color.green);
		C3 = Cercle.creerCercle(A, B);
	}

	/** Test de E1 au niveau du rayon. */
	@Test public void testerE1() {
		C1.translater(10, 20);
		assertEquals("E12 : Rayon de C1 incorrect",
				2.5, C1.getRayon(), EPSILON);
		C2.translater(3, -1);
		assertEquals("E13 : Rayon de C2 incorrect",
				2.5, C2.getRayon(), EPSILON);
		C2.translater(0, -4);
		assertEquals("E14 : Rayon de C3 incorrect",
				5, C3.getRayon(), EPSILON);
	}

}
