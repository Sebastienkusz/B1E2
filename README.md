# B1E2-Nabila-Arnaud-Sebastien

## Déploiement d'une infrastructure avec script

>
Ce dépôt regroupe plusieurs fichiers qui permettent l'automatisation d'un déploiement de l'application Nextcloud.
Les fichiers utilisent les langages suivants :
-	Az CLI
-	Bash 
-	Json 
>
Les ressources déployées font appel à des fichiers de configuration qui se trouvent dans le dossier user_data. \
Pour exécuter ces scripts, il est nécessaire d'avoir un abonnement Azure, un éditeur de code (type VSC), d'installer Azure CLI, ainsi que l'extension az cli monitor.

Les clés SSH publiques utilisées pour le déploiement sont stockées dans le dossier 'ssh_keys'. Elles correspondent aux clées publiques, individuelles et nominatives, des trois administrateurs de l'infrastructure.

## Déploiement sans modification des variables :
>
Etape 1 : Récupérer le contenu du dépôt
>
`git clone git@github.com:Simplon-AdminCloud-Bordeaux-2023-2025/B1E2-Nabila-Arnaud-Sebastien.git`
>
Etape 2 : A partir du dossier local créé, rendre les fichiers exécutables s'ils ne le sont pas déjà
>
`chmod +x *.sh`
>
Etape 3 : Lancer le script

Avant de lancer le script passez la commande `az login` pour être connecté à votre compte Microsoft Azure.
Le script peut être lancé sans option
>
`./00_deploy.sh`
>
Il est également possible de passer des paramètres lors de l'exécution, afin de personnaliser certains attributs du script. Pour connaitre les options disponibles, utiliser la commande :
>
`./00_deploy.sh -h`

**Résultat** :

Les ressources sont créées dans le groupe de ressource b1-e2-gr1

L’application Nextcloud est accessible via le lien : 

https://enas-preproduction-nextcloud.westeurope.cloudapp.azure.com/

Les champs du formulaire de création du compte d'administrateur sont normalement pré-remplis (il ne vous reste qu'à choisir un nom d'utilisateur admin et son mot de passe).

Si ce n'est pas le cas, il faudra préciser les informations suivantes :



| Paramètre | Valeur | Valeurs par défaut |
| :--- | :--- | :--- |
| Nom d'utilisateur | Le nom que vous voulez | |
| Mot de passe | Celui que vous voulez | |
| | | |
| Répertoire de données | **/nextclouddrive/nextcloud/data** | |
| | |
| Utilisateur de la base de données | le paramètre **User** défini dans le fichier configSQL.sh | sqluser ou adminsql |
| Mot de passe de la base de données | le paramètre **Password** défini dans le fichier configSQL.sh | dauphinvert ou dauphinrouge |
| Nom de la base de données | le paramètre **BddName** défini dans le fichier configSQL.sh | nextcloud |
| Localhost | le paramètre **BDDName** défini dans le fichier 00_deploy.sh | preproduction-bdd-sql.mysql.database.azure.com |
| | | |

Puis faites (a verifier)


	   Terminer l'installation


## Déploiement avec modifications des variables :

La quasi-totalité des variables peuvent être modifiées via le fichier `00_deploy.sh
`

Voici les variables pour lesquelles il faut être attentif :

- La modification des variables $PreName et $ClientName a un impact sur les noms DNS dans les fichiers `user_data/configNextcloudVm.sh` et `/user_data/configSQL.sh`. Il faut mettre à jour les lignes 17, 38 et 44 sur le premier fichier, puis la ligne 5 dans le second fichier.
- La modification des noms DNS dans le fichier `00_deploy.sh` (lignes 30 et 33) nécessite aussi la modification du fichier `user_data/configNextcloudVm.sh` (lignes 17, 38 et 44)
- La modification de l'adminSQL et/ou du passwordadmin SQL sur le fichier `02_bdd.sh`.Il faut également reporter les changements sur le fichier `/user_data/configSQL.sh`
- La modification du user par défaut et de sa clé publique associée dans le fichier `00_deploy.sh` (lignes 71 et 72). Il faut également mettre à jour les informations du fichier `user_data/adduser.sh` (ligne 5)
- La modification du nom du Workspace, du groupe de ressource ou du nom du client. Il faut également modifier la ligne 89, du fichier dcr.json, pour la faire correspondre avec le nouveau `workspaceName`, `resourceGroupName` et `subscriptionID`.

"workspaceResourceId":"/subscriptions/`subscriptionID`/resourceGroups/`resourceGroupName`/providers/Microsoft.OperationalInsights/workspaces/`workspaceName`" 
