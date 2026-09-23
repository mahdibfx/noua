# Retours backend — app Noua (manager)

Dernier test : 23/09/2026 sur `https://demo.smartvision-dz.com` (admin).

## ✅ Corrigé / vérifié

- Token : plus de `exp == iat`, les endpoints authentifiés répondent.
- Statut liste vs détail : 0 écart sur les 31 DA et les 17 BC.
- Encodage : `billed` renvoie bien « facturé ».
- `commandes_en_attente_validation` : 4 (avant 15) — cohérent avec En cours + Partielle.
- Champs des détails (produits, opérations, totaux) : lus par l'app, tests OK.

## Règles appliquées côté app (Yanis, 22/09/2026)

- **Demandes d'achat** : Valider / Refuser uniquement si statut 1 (En cours).
  L'API accepte n'importe quel statut, mais l'app ne propose pas l'action
  ailleurs (décision produit).
- **Bons de commande** : Valider uniquement si « Partielle » (4),
  Refuser uniquement si « En cours » (1).

## Reste à faire / à répondre

1. **`status_code` de « Satisfait » (bons de commande) ?** Yanis indique que
   l'annulation est possible sur « En cours » et « Satisfait », mais ce statut
   n'apparaît ni dans la doc ni dans les données de démo. L'app n'autorise
   donc l'annulation que sur « En cours » pour l'instant.

2. **Le token n'expire toujours jamais.** Le JWT n'a pas de claim `exp` et
   `expires_at` vaut `null`. Merci de remettre une vraie durée (ex. 30 jours).

3. **`achats_en_attente_validation` ne correspond pas à la liste.**
   Sur 01 → 23/09 le dashboard renvoie 3, alors que
   `GET /api/purchase-orders?status=en_cours` ne renvoie qu'une seule DA
   (DA00022/2026). Le compteur devrait compter les demandes d'achat au statut
   1 (En cours) sur la période — c'est ce que le bouton ouvre dans l'app.

4. **Filtre par dates sur les listes.** Pouvez-vous ajouter `date_from` /
   `date_to` à `/api/purchase-orders` et `/api/command-orders` ? Le bouton du
   dashboard ouvrirait alors exactement les documents comptés.

5. **`cancel_reason`** est-il obligatoire pour annuler un bon de commande ?
   L'app envoie `action: cancel` + `restore_related_demands: true`, sans motif.

6. **Documents de test** : une DA « En cours » et un BC « Partielle » qu'on
   peut valider/annuler sur la démo sans gêner ?

7. **Soldes négatifs** : `solde_total_clients` et `solde_total_fournisseurs`
   sont négatifs. C'est normal ? L'app les affiche tels quels.

8. **`operations` (demandes de paiement)** : objet avec chaînes `<br>` dans la
   liste, tableau d'objets dans le détail. L'app n'utilise que le détail.
