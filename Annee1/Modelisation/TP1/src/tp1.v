(* Les règles de la déduction naturelle doivent être ajoutées à Coq. *) 
Require Import Naturelle. 

(* Ouverture d'une section *) 
Section LogiquePropositions. 

(* Déclaration de variables propositionnelles *) 
Variable A B C E Y R : Prop. 

Theorem Thm_0 : A /\ B -> B /\ A.
I_imp H.
I_et.
E_et_d A.
Hyp H.
E_et_g B.
Hyp H.
Qed.

Theorem Thm_1 : ((A \/ B) -> C) -> (B -> C).
I_imp H.
I_imp H1.
E_imp (A\/B).
Hyp H.
I_ou_d.
Hyp H1.
Qed.

Theorem Thm_2 : A -> ~~A.
(* A COMPLETER *)
I_imp HA.
I_non HnA.
I_antiT A.
Hyp HA.
Hyp HnA.
Qed.

Theorem Thm_3 : (A -> B) -> (~B -> ~A).
(* A COMPLETER *)
I_imp HAimpB.
I_imp HnB.
I_non HnA.
I_antiT B.
E_imp A.
Hyp HAimpB.
Hyp HnA.
Hyp HnB.
Qed.

Theorem Thm_4 : (~~A) -> A.
(* A COMPLETER *)
I_imp nnA.
absurde nA.
E_non (~A).
Hyp nA.
Hyp nnA.
Qed.

Theorem Thm_5 : (~B -> ~A) -> (A -> B).
(* A COMPLETER *)
I_imp nBimpnA.
I_imp HA.
absurde HnB.
I_antiT A.
Hyp HA.
E_imp (~B).
Hyp nBimpnA.
Hyp HnB.
Qed.

Theorem Thm_6 : ((E -> (Y \/ R)) /\ (Y -> R)) -> (~R -> ~E).
(* A COMPLETER *)
I_imp L.
I_imp HnR.
I_non HE.
I_antiT R.
E_ou Y R.
E_imp E.
E_et_g (Y-> R).
Hyp L.
Hyp HE.
E_et_d (E-> (Y\/R)).
Hyp L.
I_imp HR.
Hyp HR.
Hyp HnR.
Qed.

(* Version en Coq *)

Theorem Coq_Thm_0 : A /\ B -> B /\ A.
intro H.
destruct H as (HA,HB).  (* élimination conjonction *)
split.                  (* introduction conjonction *)
exact HB.               (* hypothèse *)
exact HA.               (* hypothèse *)
Qed.


Theorem Coq_E_imp : ((A -> B) /\ A) -> B.
(* A COMPLETER *)
intro L.
cut A.
destruct L as (H1, H2).
exact H1.
destruct L.
exact H0.
Qed.

Theorem Coq_E_et_g : (A /\ B) -> A.
(* A COMPLETER *)
intro.
destruct H.
exact H.
Qed.

Theorem Coq_E_ou : ((A \/ B) /\ (A -> C) /\ (B -> C)) -> C.
(* A COMPLETER *)
intro.
destruct H.
destruct H0.
destruct H.
cut A.
exact H0.
exact H.
cut B.
exact H1.
exact H.
Qed.

Theorem Coq_Thm_7 : ((E -> (Y \/ R)) /\ (Y -> R)) -> (~R -> ~E).
(* A COMPLETER *)
intros.
intro.
absurd R.
exact H0.
destruct H.
destruct H.
exact H1.
cut Y.
exact H2.
exact H.
exact H.
Qed.

End LogiquePropositions.

