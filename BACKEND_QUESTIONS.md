# Retours backend — app Noua (manager)

Testé le 21/09/2026 sur `https://demo.smartvision-dz.com` avec `admin`.

## ✅ Vérifié, OK

- Login, profil, dashboard, les 3 listes et les 3 détails répondent HTTP 200.
- Le bug du token (`exp` == `iat`) est corrigé.
- Les champs des détails (produits, opérations, totaux) sont lus correctement
  par l'app (tests automatiques sur les vraies réponses).

## À corriger / à répondre

0. **Statut différent entre la liste et le détail des demandes d'achat.**
   Sur 28 des 31 DA, `GET /api/purchase-orders` renvoie le statut effectif
   (7 En traitement, 8 Commandée, 0 Réceptionné) alors que
   `GET /api/purchase-orders/detail/{id}` renvoie `status_code: 1` (En cours).
   Exemple : DA00021/2026 → liste « En traitement », détail « En cours ».
   Les bons de commande et demandes de paiement n'ont pas ce problème.
   → Le détail doit renvoyer le même statut effectif que la liste.
   (En attendant, l'app garde le statut de la liste.)

1. **Le token n'expire plus jamais.** Le JWT n'a plus de claim `exp` et
   `expires_at` vaut `null`. Un token volé reste valable à vie. Merci de
   remettre `exp` avec une vraie durée (ex. 30 jours) et la même valeur dans
   `expires_at`.

2. **Statuts des demandes d'achat ≠ la doc.** La doc parle de 6 (En attente),
   1 (En cours), 2 (Validée), 3 (Annulée). Les vraies données contiennent aussi
   7 (En traitement, 23 DA), 8 (Commandée, 5 DA) et 0 (Réceptionné, 1 DA).
   `?status=en_attente` renvoie 0 résultat.
   → Quels statuts le manager peut-il **valider / refuser** ? L'app affiche
   aujourd'hui les boutons pour 6 et 1 seulement.

3. **Les compteurs du dashboard ne correspondent pas aux listes.**
   Sur 01/09 → 21/09 : `achats_en_attente_validation` = 1 mais la liste des
   demandes d'achat en attente = 0 ; `commandes_en_attente_validation` = 15
   mais la liste des bons de commande en attente = 6. D'après la doc, le
   premier compte des `purchase_operation` et le second inclut les commandes
   commerciales. Dans l'app, ces boutons ouvrent les listes Demandes d'achat
   et Bons de commande → le manager verra des chiffres différents.
   → Soit aligner les compteurs sur ces listes, soit nous dire à quoi ils
   correspondent.

4. ~~**Priorité des demandes d'achat.**~~ Libellés choisis côté app :
   1 Basse, 2 Normale, 3 Haute, 4 Urgente (cohérent avec la maquette).

5. **Encodage cassé** : dans `/api/payment-requests`, `billed` vaut
   `"facturÃ©"` au lieu de `"facturé"` (UTF-8 encodé deux fois).

6. **`operations` n'a pas le même format dans la liste et le détail** des
   demandes de paiement : objet avec des chaînes jointes par `<br>` dans la
   liste, tableau d'objets dans le détail. L'app n'utilise que le détail ;
   le format de la liste peut être aligné ou retiré.

7. **Valider / Refuser.** Côté mobile, « Refuser » envoie
   `{"action":"cancel"}` (statut 3 Annulée). Confirmez-vous ? Pour les bons de
   commande, `cancel_reason` est-il obligatoire ?
   Ces actions n'ont **pas** été testées pour ne pas modifier les données de
   la démo : pouvez-vous nous indiquer une DA et un BC de test qu'on peut
   valider/annuler ?

8. **Pagination** : l'app charge tout (31 DA, 17 BC, 11 DP sur la démo).
   Quel volume en production ?
