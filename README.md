# sup-rette

Supérette moderne pour ESX avec interface NUI stylisée, catégories de produits et intégration **ox_target** pour l'ensemble des points 24/7.

## Fonctionnalités
- Interface HTML moderne avec filtres par catégorie et visuels néon.
- Points de vente déjà configurés pour tous les supérettes de Los Santos.
- Intégration **ox_target** : interaction en 3D pour ouvrir la caisse.
- Achat sécurisé côté serveur (ESX) avec notifications et limite de quantité configurable.
- Système de catégories configurable avec visuels personnalisés.

## Installation
1. Placer le dossier `sup-rette` dans votre répertoire `resources/`.
2. Ajouter la dépendance `ox_lib`, `ox_target`, `oxmysql` et `es_extended` à votre serveur.
3. Assurez-vous que vos items ESX existent (ex. `bread`, `water`, `bandage`, etc.).
4. Ajouter à votre `server.cfg` :
   ```
   ensure sup-rette
   ```

## Configuration
- Les points de vente, catégories et prix se trouvent dans `config.lua`.
- Modifiez `Config.MaxPurchase` pour ajuster la quantité maximale achetable par action.
- Les zones cibles peuvent être rechargées en jeu avec la commande `/forcesuperette` (touche par défaut : `END`).

## Crédits
Créé pour démontrer une supérette ESX avec NUI moderne et ox_target.
