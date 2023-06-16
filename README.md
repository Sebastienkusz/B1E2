# B1E2-Nabila-Arnaud-Sebastien

## Déploiement d'une infrastructure avec script


* 1 - Network
* 2 - SQL
* 3 - VM
* 4 - Monitoring

## Variables à changer dans les fichiers :
    
    00_deploy.sh
    
_puis dans le dossier user_data :_
        
    adduser.sh
    configBastion.sh
    configNextcloudVM.sh
    configSQL.sh

_Clés SSH_

Penser à copier les clés publiques dans le dossier ssh_keys



_Pour lancer le déploiement_

    00_deploy.sh


Une fois le déploiement fait, se connecter à l'application avec le navigateur web

    (les informations de connexion seront résumées en fin de déploiement)

Le dossier ssh_keys contient les clés publique 



La page de Nextcloud doit apparaître et vous devez préciser :

| Paramètre | Valeur | Valeurs par défaut |
| :--- | :--- | :--- |
| Nom d'utilisateur | Le nom que vous voulez | |
| Mot de passe | Celui que vous voulez | |
| | | |
| Répoertoire de données | **/data** | |
| | |
| Utilisateur de la base de données | le paramètre **User** défini dans le fichier configSQL.sh | nabila |
| Mot de passe de la base de données | le paramètre **Password** défini dans le fichier configSQL.sh | password0606! |
| Nom de la base de données | le paramètre **BddName** défini dans le fichier configSQL.sh | nextcloud |
| Localhost | le paramètre **BDDName** défini dans le fichier 00_deploy.sh | preproduction-bdd-sql.mysql.database.azure.com |
| | | |

Puis faites

    Terminer l'installation