# Journal de bord du projet HeroCtrl

## 1. Idée du projet

L'application officielle de GoPro est limitée en termes de fonctionnalités et de compatibilité avec les anciennes caméras, notamment ma GoPro Hero 3+.

Alors je me suis lancé le défi de créer une application mobile Flutter capable de contrôler à distance une GoPro Hero 3 via son API Wi-Fi.

## 2. Découverte et recherche de l'API GoPro

En cherchant je n'ai trouvé aucune documentation officielle disponible pour l'API GoPro Hero 3+.

Mais j'ai quand même trouvé des ressources non officielles et des projets open source qui m'ont permis de comprendre les commandes disponibles. Malheureusement toutes les fonctionnalités ne sont pas documentées, donc j'ai dû expérimenter pour découvrir certaines commandes.

## 3. Tests et expérimentation de l'API GoPro

Étant donné le manque de documentation, j'ai dû m'appuyer sur des tests et des expérimentations pour valider le bon fonctionnement des commandes.

J'ai utilisé un script Bash pour envoyer des requêtes HTTP à la caméra et observer les réponses. Cela m'a permis d'établir une théorie sur le fonctionnement de l'API. Plus d'infos dans la [documentation](/docs/API-docs.md).

Pour faire simple j'ai compris que l'API n'utilise que des requêtes HTTP `GET` pour interagir avec la caméra. Et que les commandes en minuscules sont utilisées pour récupérer des informations (`GET`), tandis que les commandes en majuscules sont utilisées pour modifier des paramètres (`POST`).

Explication rapide de l'exécution du script de test `scan.sh` :

- Le script envoie des requêtes HTTP à la caméra en utilisant différentes combinaisons de lettres pour les commandes.
- Il enregistre les réponses dans un fichier journal pour une analyse ultérieure, seulement si le premier octet de la réponse est différent de `0x01` (ce qui indique une réponse vide ou non valide) et que la réponse est d'une taille supérieure à 1 octet.

> [!NOTE]
> J'ai ajouté une fonctionnalité d'ignore list dans le script pour éviter de tester des combinaisons déjà connues ou des commandes pouvant causer des effets indésirables sur la caméra pendant les tests. (Genre éteindre la caméra. lol)

## 4. Documentation

Pendant la phase de test, j'ai documenté toutes les commandes découvertes dans un fichier Markdown séparé : [API-docs.md](/docs/API-docs.md). Cela m'a permis de garder une trace claire des fonctionnalités disponibles et de faciliter le développement de l'application après.

Si je ne me trompe pas, cette documentation est la plus complète disponible pour l'API GoPro Hero 3+ à ce jour. Et elle permet l'utilisation de la GoPro telle qu'avec ses boutons physiques ainsi que tous ses paramètres.

## 5. Développement de l'application Flutter

Avec une bonne compréhension de l'API, j'ai commencé le développement de l'application mobile en utilisant Flutter:

1. J'ai d'abord créé des constantes pour toutes les commandes de l'API, basées sur ma documentation.

2. Ensuite, j'ai implémenté des fonctions pour envoyer des requêtes HTTP à la caméra en utilisant le package `http` de Dart.

3. Pour gérer les flux vidéo j'ai cherché un package Flutter adapté et j'ai trouvé `better_player_plus`, qui offre une bonne prise en charge des flux HLS.

4. Pareil pour la recherche automatique de la caméra parmis les réseaux Wi-Fi disponibles, j'ai utilisé le package `wifi_iot`.

5. Ensuite il ne restait plus qu'à implémenter l'interface utilisateur pour permettre à l'utilisateur de contrôler la caméra et de visualiser le flux vidéo en direct.
