#include <stdlib.h> 
#include <stdio.h>
#include <math.h>

#define pi 3.14

int main(){
    int rayon = 15;
    float peri = 2*pi*rayon;
    float aire = pi*pow(rayon, 2);
    printf("Le périmetre du cercle de rayon %d est de %f et son aire est de %f", rayon, peri, aire);
    return EXIT_SUCCESS;
}
