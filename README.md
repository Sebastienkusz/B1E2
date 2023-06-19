# B1E2-Nabila-Arnaud-Sebastien

## Déploiement d'une infrastructure avec script

Ce dépôt regroupe plusieurs fichiers qui permettent l'automatisation d'un déploiement de l'application Nextcloud.

Les fichiers utilisent les langages suivants :

-	Az CLI
-	Bash 
-	Json 

Les ressources déployées font appel à des fichiers de configuration qui se trouvent dans le dossier `user_data. \`

Pour exécuter ces scripts, il est nécessaire d'avoir un abonnement Microsoft Azure, un éditeur de code (type VSC), d'installer Azure CLI, ainsi que l'extension az cli monitor.

Les clés SSH publiques utilisées pour le déploiement sont stockées dans le dossier `ssh_keys`

Elles correspondent aux clées publiques, individuelles et nominatives, des trois administrateurs de l'infrastructure.

Les clés SSH privées, elles, sont stockées sur la machine de l'utilisateur.

Le chemin vers ce dossier varie en fonction du système d'exploitation utilisé par l'utilisateur.


## Déploiement sans modification des variables :


**Etape 1 : Récupérer le contenu du dépôt Github**

a) Installer Git sur sa machine (si ce n'est pas déjà fait)

Exemple pour Windows:

`https://git-scm.com/download/win`

b) Dans son terminal

`git clone git@github.com:Simplon-AdminCloud-Bordeaux-2023-2025/B1E2-Nabila-Arnaud-Sebastien.git`

Pour pouvoir le télécharger il faut une clé d'accès SSH (voir avec vos admins sys)

Cela a pour effet de récupérer la structure du repo Github sur la machine en local:



**Etape 2 : A partir du dossier local créé, rendre les fichiers exécutables s'ils ne le sont pas déjà**

`chmod +x *.sh`

**Etape 3 : Lancer le script**

Lancement du script sans option.

Dans son terminal, on lance:


`./00_deploy`

## Déploiement avec modification des variables :



Il est également possible de passer des paramètres lors de l'exécution, afin de personnaliser certains attributs du script.

Pour connaitre les options disponibles, utiliser la commande :


`./00_deploy -h`


Résultat :

Par défaut, les ressources sont créées dans le groupe de ressource Azure b1e2-gr1

L’application Nextcloud est accessible via le lien :

`https://esan-preproduction-nextcloud.westeurope.cloudapp.azure.com/`



Il faudra préciser les informations suivantes :


| Paramètre | Valeur | Valeurs par défaut |
| :--- | :--- | :--- |
| Nom d'utilisateur | Le nom que vous voulez | |
| Mot de passe | Celui que vous voulez | |
| | | |
| Répertoire de données | **/data** | |
| | |
| Utilisateur de la base de données | le paramètre **User** défini dans le fichier configSQL.sh | sqluser |
| Mot de passe de la base de données | le paramètre **Password** défini dans le fichier configSQL.sh | dauphinvert |
| Nom de la base de données | le paramètre **BddName** défini dans le fichier configSQL.sh | nextcloud |
| Localhost | le paramètre **BDDName** défini dans le fichier 00_deploy.sh | preproduction-bdd-sql.mysql.database.azure.com |
| | | |

Puis faites (a verifier)


	   Terminer l'installation


## Déploiement avec modifications des variables :

La quasi-totalité des variables peuvent être modifiées via le fichier `00_deploy.sh
`

Voici les variables pour lesquelles il faut être attentif :

- Modification des noms DNS
- Modification de l'adminSQL et/ou du passwordadmin SQL sur le fichier 02_bdd.sh
 il faut reporter les changements sur le fichier /user_data/configSQL.sh
- Modification du user par défaut : il faudra également mettre à jour les informations du fichier adduser.sh
- Modification du nom du Workspace ou du groupe de ressource: il faudra modifier la ligne .... du fichier dcr.json pour la faire correspondre avec le nouveau WorkspaceID :
(mettre une copie de la ligne en exemple)
