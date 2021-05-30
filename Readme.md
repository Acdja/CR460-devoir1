# Devoir 1
## Énoncé

À partir de GitHub, vous copierez le [repository](https://github.com/matbilodeau/CR460-devoir1)
et y appliquerez les modifications nécessaires afin de déployer l'infrastructure
demandée sur GCP via Terraform.  
Vous fournirez 3 captures d'écran: output terraform + site web avec IP + dashboard instances GCP.
Vous sauvegarderez vos modifications (commit) et publierez le code sur votre propre version du repo.
Votre code devra être accessible de manière privée, ajoutez Riad (RiadMan) et Moi seulement.


### L'infrastructure à déployer

Via Terraform :

#### Instances
* une instance nommée "chien"
de type "f1-micro"
debian-10
dans le sous-réseau "prod-dmz"
avec un serveur apache2 à jour
  * _le serveur doit être accessible publiquement_
  * _Un Health-Check HTTP complet vérifiera le serveur aux 4 secondes, une instance deviendra healthy après 5 succès et unhealthy après 3 échecs_

* une instance nommée "chat"
de type "f1-micro"
CoreOs 2514.1.0
cible "interne"
dans le sous-réseau "prod-interne"
  * _cette instance doit pouvoir accepter publiquement les connexions par ssh_
  * cette instance doit pouvoir recevoir du  trafic TCP sur les ports "4444", "5126", seulement en provenance du sous-réseau "prod-traitement"

* instances "hamster"
de type "f1-micro"
CoreOs 2514.1.0
cible "traitement"
dans le sous-réseau "prod-traitement"
  * ces instances doivent pouvoir s'éteindre automatiquement jusqu'à un minimum d'une instance
  **ET**
  * ces instances doivent pouvoir se mettre en fonction automatiquement jusqu'à un maximum de cinq instances
  **SELON**
  * une évaluation de la charge du CPU à +/- 53% après un délai de démarrage de 3 minutes      

* une instance nommée "perroquet"
de type "f1-micro"
Ubuntu 16.04
cible "cage"
dans le réseau par défaut de votre projet

#### Réseau
* Le réseau principal nommé "devoir1"
* un sous-réseau "prod-interne" "172.16.20.0/24"
* un sous-réseau "prod-dmz" "192.168.65.0/24"
* un sous-réseau "prod-traitement" "10.0.128.0/24"

* Une règle de pare-feu pour autoriser le trafic web sur les instances ciblées "public-web"
* Une règle de pare-feu pour autoriser le trafic  vers les instances ciblées "traitement" sur les ports TCP "4444", "5126" , seulement à partir des instances sur le sous-réseau "prod-interne"
* Une règle de pare-feu pour autoriser la connexion ssh de l'internet vers les instances ciblées "interne"

#### Compte de service
Un compte de service nommé "maison" sera créé avec un rôle de lecture sur les ressources du projet.
Une clé d'accès sera générée et sauvegardée localement dans un fichier nommé "maison_svc_act.json"


### Remise
La remise du devoir se fera en 2 parties soit une sur moodle et l'autre sur GitHub.  
*Aucune autre forme ou format ne seront acceptés.*

#### Moodle
Sur Moodle, vous remettrez un fichier *PDF* nommé "matricule-Nom_Prénom-devoir1.PDF"
Le fichier contiendra:

* un lien vers votre repository Github (Collaborateurs ?)
* les captures d'écran demandées.


# A prendre a consideration dans mon travail:
- courant notre travail, nous avons constate que CoreOs 2514.1.0 etait en fin de vie et c est la
  raison pour laquelle nous l avons remplace pour installer ubuntu-os-cloud/ubuntu-2004-lts

  * provider.tf
  * regroupe les informations du fournisseur cloud
* compute.tf
  * regroupe les informations d'instance
* network.tf  
  * regroupe les informations du reseau, sous reseau et Pare-feu
* data.tf
  * sources externes
  * https://www.terraform.io/docs/configuration/data-sources.html
* variables.tf
  * Déclaration de variables internes
  * https://www.terraform.io/docs/configuration/variables.html
* output.tf
  * présente une information suite à la création de l'infrastructure
