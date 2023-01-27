// Online C compiler to run C program online
#include <stdio.h>

float xe[4] = {0.0,0.0,0.0,0.0};    /* equilibrium state                     */
float ue    = 0.0;                  /* command at equilibrium                */
float x[4];                         /* state                                 */
float y[2];                         /* observations                          */
float u;                            /* command of the controller (V)         */
float setpoint;                     /* target value for theta variable       */
float K[4] = {0.67, 19.9053, 1.0747, 1.9614};
float K0[4] = {0.1, 17.0, 1.0, 1.5}; /* pour avancer le robot (trouver à taton) */
float x0[4] = {1.0, 1.0, 0.0, 0.0}; /* pour avancer le robot (trouver à taton) */
float dt;

/*** Estimateur ***/
void estimateur(float y[2], float* x[4], float dt) {
  *x[1] = *x[1] + dt * y[1];
  *x[2] = (y[0] + *x[1] - *x[0]) / dt;
  *x[3] = y[1];
  *x[0] = y[0] + *x[1];
} 

/*** Controleur ***/
 void controleur(float x[4], float* u) {
  *u = ue + K[0] * (x[0] - xe[0]) + K[1] * (x[1] - xe[1]) + K[2] * (x[2] - xe[2]) + K[3] * (x[3] - xe[3]);
}


int main() {
    estimateur(y, &x, dt);
    controleur(x, &u);
    return 0;
}
