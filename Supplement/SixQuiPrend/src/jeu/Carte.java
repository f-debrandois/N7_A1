package jeu;

public class Carte {

	/** Valeur de la carte. */
	private int valeur;

	/** Nombre d'étoiles sur la carte. */
	private int nbEtoile;

	public Carte(int valeur) {
		assert valeur > 0 && valeur < 105;
		this.valeur = valeur;
		this.nbEtoile = 1;
		if (valeur % 5 == 0) {
			this.nbEtoile += 1;
		}
		if (valeur % 10 == 0) {
			this.nbEtoile += 1;
		}
		if (valeur % 11 == 0) {
			this.nbEtoile += 4;
		}
		if (valeur % 55 == 0) {
			this.nbEtoile += 1;
		}
	}

	/** Obtenir la valeur de la carte. */
	public int getValeur() {
		return this.valeur;
	}

	/** Obtenir le nombre d'étoiles de la carte. */
	public int getEtoile() {
		return this.nbEtoile;
	}

	public String toString() {
		return " |" + String.format("%3d", this.valeur) + "| "
				+ "\n |*" + Integer.toString(this.nbEtoile) + "*| ";
	}

	/** Afficher la carte. */
	public void afficher() {
		System.out.println(this);
	}

}
