import java.awt.Color;

/**
 * Cercle modélise un cercle dans un plan équipé d'un repère cartésien.
 * @author Félix Foucher de Brandois
 * @version V1
 */
public class Cercle implements Mesurable2D {

	/** Centre du cercle. */
    private Point centre;

    /** Rayon du cercle. */
    private double rayon;

    /** Couleur du cercle (E8). */
    private Color couleur;

    /** Constante pi. */
    public static final double PI = Math.PI;

    // E1
    /** Translater le cercle.
	* @param dx déplacement suivant l'axe des X
	* @param dy déplacement suivant l'axe des Y
	*/
	public void translater(double dx, double dy) {
		this.centre.translater(dx, dy);
	}

	// E2
	/** Obtenir le centre d'un cercle.
	 * @return les coordonnées du centre
	 */
	public Point getCentre() {
		return new Point(this.centre.getX(), this.centre.getY());
	}

	// E3
	/** Obtenir le rayon d'un cercle.
	 * @return la longueur du rayon du cercle
	 */
	public double getRayon() {
		return this.rayon;
	}

	// E4
    /** Obtenir le diametre d'un cercle.
	 * @return la longueur du diamètre du cercle
	 */
	public double getDiametre() {
		return 2 * this.rayon;
	}

	// E5
    /** Dire si un point est a l'interieur d'un cercle.
     * @param p point  à determiner
	 * @return Vrai si le point est à l'intérieur du cercle
	 */
	public boolean contient(Point p) {
		assert p != null;
		return this.centre.distance(p) <= this.rayon;
	}

	// E6
    /** Donner le périmètre d'un cercle.
	 * @return le pérmiètre du cercle
	 */
	public double perimetre() {
		return 2 * PI * this.rayon;
	}

    /** Donner l'aire d'un cercle.
	 * @return l'aire du cercle
	 */
	public double aire() {
		return PI * this.rayon * this.rayon;
	}

	// E9
    /** Obtenir la couleur d'un cercle.
	 * @return la couleur du cercle
	 */
	public Color getCouleur() {
		return this.couleur;
	}

	// E10
    /** Changer la couleur d'un cercle.
	* @param couleur couleur voulue pour le cercle
	*/
	public void setCouleur(Color couleur) {
		assert couleur != null;
		this.couleur = couleur;
	}

	// E11
	/** Construire un cercle à partir de son centre (point) et de son rayon.
	 * @param c centre
	 * @param r rayon
	 */
	public Cercle(Point c, double r) {
		assert c != null;
		assert r > 0;
		this.centre = new Point(c.getX(), c.getY());
		this.rayon = r;
		this.couleur = Color.blue;
	}

	// E12
    /** Construire un cercle à partir de deux points opposés.
	 * @param p1 point 1
	 * @param p2 point 2
	 */
	public Cercle(Point p1, Point p2) {
		assert p1 != null;
		assert p2 != null;
		assert p1.getX() - p2.getX() != 0 || p1.getY() - p2.getY() != 0;
		this.centre = new Point((p1.getX() + p2.getX()) / 2, (p1.getY() + p2.getY()) / 2);
		this.rayon = p1.distance(p2) / 2;
		this.couleur = Color.blue;
	}

	// E13
    /** Construire un cercle à partir de deux points opposés et d'une couleur.
	 * @param p1 point 1
	 * @param p2 point 2
	 * @param couleur couleur du cercle
	 */
	public Cercle(Point p1, Point p2, Color couleur) {
		this(p1, p2);
		assert couleur != null;
		this.couleur = couleur;
	}

	// E14
    /** Construire un cercle à partir de deux points.
     * Le premier est le centre
     * Le deuxième est sur la circonférence du cercle
	 * @param p1 point 1
	 * @param p2 point 2
	 * @return le cercle qui correspond aux exigences
	 */
    public static Cercle creerCercle(Point p1, Point p2) {
    	assert p1 != null;
		assert p2 != null;
		assert p1.getX() - p2.getX() != 0 || p1.getY() - p2.getY() != 0;
    	return new Cercle(p1, p1.distance(p2));
    }

    // E15
	/** Afficher le cercle. */
	public void afficher() {
		System.out.print("C" + Double.toString(this.rayon)
			+ "@" + this.centre.toString());
	}

	/** Renvoyer le cercle en string.
	 * @return le cercle sous forme de chaine de caractère
	 */
	public String toString() {
		return "C" + Double.toString(this.rayon) + "@" + this.centre.toString();
	}

	// E16
    /** Changer le rayon d'un cercle.
	* @param r rayon voulu pour le cercle
	*/
	public void setRayon(double r) {
		assert r > 0;
		this.rayon = r;
	}

	// E17
    /** Changer le diamètre d'un cercle.
	* @param d diamètre voulu pour le cercle
	*/
	public void setDiametre(double d) {
		assert d > 0;
		this.rayon = d / 2;
	}

}
