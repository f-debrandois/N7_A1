import java.awt.Color;

/** 
 *
 * @author  Felix Foucher de Brandois
 */
public class Cercle {

    private Point centre;       // centre
	private double rayon;		// rayon
	private Color couleur;	    // couleur du cercle

    public static final double PI = Math.PI;


	/** Construire un cercle à partir de son centre (point) et de son rayon.
	 * @param c centre
	 * @param r rayon
	 */
	public Cercle(Point c, double r) {
		this.centre = c;
		this.rayon = r;
		this.couleur = Color.blue;
	}

    /** Construire un cercle à partir de deux points opposés
	 * @param p1 point 1
	 * @param p2 point 2
	 */
	public Cercle(Point p1, Point p2) {
		this.centre = c;
		this.rayon = r;
		this.couleur = Color.blue;
	}

    /** Construire un cercle à partir de deux points : 
     * le premier est le centre
     * le deuxième est sur la circonférence du cercle
	 * @param p1 point 1
	 * @param p2 point 2
	 */
    public static Cercle creerCercle(Point p1, Point p2) {
        this.centre = c;
		this.rayon = r;
		this.couleur = Color.blue;
    }

    /** Translater le cercle.
	* @param dx déplacement suivant l'axe des X
	* @param dy déplacement suivant l'axe des Y
	*/
	public void translater(double dx, double dy) {
		this.centre.translater(dx, dy);
	}

	/** Obtenir le centre d'un cercle.
	 * @return les coordonnées du centre
	 */
	public double getCentre() {
		return this.centre;
	}

	/** Obtenir le rayon d'un cercle.
	 * @return la longueur du rayon du cercle
	 */
	public double getRayon() {
		return this.rayon;
	}

    /** Obtenir le diametre d'un cercle.
	 * @return la longueur du diamètre du cercle
	 */
	public double getDiametre() {
		return 2*this.rayon;
	}

    /** Dire si un point est a l'interieur d'un cercle.
     * @param p point  à determiner
	 * @return Vrai si le point est à l'intérieur du cercle
	 */
	public boolean Est_Interieur(Point p) {
		return this.centre.distance(p) <= this.rayon;
	}

    /** Renvoie le périmètre d'un cercle.
	 * @return le pérmiètre du cercle
	 */
	public double perimetre() {
		return 2*PI*this.rayon;
	} 

    /** Renvoie l'aire d'un cercle.
	 * @return l'aire du cercle
	 */
	public double aire() {
		return PI*this.rayon*this.rayon;
	} 

    /** Changer la couleur d'un cercle.
	* @param couleur couleur voulue pour le cercle
	*/
	public void setCouleur(Color couleur) {
		this.x += dx;
		this.y += dy;
	}

	/** Afficher le cercle. */
	public void afficher() {
		System.out.print(this);
	}

    /** Changer le rayon d'un cercle.
	* @param r rayon voulu pour le cercle
	*/
	public void setRayon(Color couleur) {
		this.x += dx;
		this.y += dy;
	}

    /** Changer le diamètre d'un cercle.
	* @param d diamètre voulu pour le cercle
	*/
	public void setDiametre(Color couleur) {
		this.x += dx;
		this.y += dy;
	}
}