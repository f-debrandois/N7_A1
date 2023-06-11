package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

/**
 * Classe de test de la stratégie Rapide.
 * @author	Félix Foucher de Brandois
 */
public class TestStratRapide {

	// Les types de situations du jeu
	Jeu jeu5, jeu3, jeu2, jeu1;

	// Le joueur avec la stratégie rapide
	Joueur joueurRapide;

	@Before public void setUp() {
		// Jeu avec 5 allumettes restantes
		jeu5 = new JeuAllumette(5);
		// Jeu avec 3 allumettes restantes
		jeu3 = new JeuAllumette(3);
		// Jeu avec 2 allumettes restantes
		jeu2 = new JeuAllumette(2);
		// Jeu avec 1 allumettes restantes
		jeu1 = new JeuAllumette(1);

		joueurRapide = new Joueur("testeur", new StratRapide());

	}

	@Test public void testerRapide5() {
		assertEquals("5 : Prise incorrecte", 3, joueurRapide.getPrise(jeu5));
	}

	@Test public void testerRapide3() {
		assertEquals("3 : Prise incorrecte", 3, joueurRapide.getPrise(jeu3));
	}

	@Test public void testerRapide2() {
		assertEquals("2 : Prise incorrecte", 2, joueurRapide.getPrise(jeu2));
	}

	@Test public void testerRapide1() {
		assertEquals("1 : Prise incorrecte", 1, joueurRapide.getPrise(jeu1));
	}

}
