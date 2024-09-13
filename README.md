# SAE51
**03/09/24**

### Participants

***Valentin DAVID
Corentin CHRETIEN***

## Objectif

Vous êtes employé dans la DSI d’une entreprise type PME. Cette société renouvelle son infrastructure IT, notre objectif est de créer un script permettant de créer des machines de manière rapide et automatisé. Elle devra respecter le cahier des charges suivant :

#### Cahier des charges
- Format : Script en .bat (genmv.bat)
- Un document rédigé en Markdown
-  Sous Virtual Box : 4096 Mb, etc etc
    

## Versions

Nous avons créé un script bat sur Windows permettant à un administrateur de créer des machines virtuelles automatiquement, de pouvoir choisir leur nom et leurs caractéristiques. Le script est également capable de les supprimer, de les démarrer, de les lister et de les arrêter.

#### Version 1

La version initiale du script permet la création de machines virtuelles, mais ne propose pas de flexibilité dans la configuration. Attention : toute machine portant le même nom sera écrasée.

#### Version 2

Cette version étend les capacités du script en permettant à l'utilisateur de choisir parmi cinq actions :
- '[L]' Lister l'ensemble des machines virtuelles
- '[N]' Créer une nouvelle machine en spécifiant des arguments tels que le nom, la RAM et la taille du disque
- '[S]' Supprimer une machine en utilisant son nom
- '[D]' Démarrer une machine 
- '[A]' Arrêter une machine

#### Version 3
Cette version introduit la gestion des métadonnées. Les informations supplémentaires ajoutées aux machines peuvent être visualisées lors du listage. Nous avons rencontré quelques difficultés pour scripter ces métadonnées de manière claire.

### Les limites

Les limitations actuelles du script sont : la création d'une seule machine par exécution et un niveau d'automatisation qui ne réduit pas significativement le temps de travail de l'administrateur.

## Conclusion

L'automatisation de la création de nos machines virtuelles avec un fichier batch nous offre une flexibilité accrue et une meilleure gestion de notre infrastructure. En définissant nos ressources dans des fichiers de configuration, nous pouvons facilement reproduire et modifier notre environnement, tout en réduisant les risques d'erreurs manuelles.
Ce script nous permet de déployer de nouvelles machines virtuelles en quelques minutes.
