Passionner de IT (Devops) le gout du chalenge toujours apprendre plus !!
**Note** : Il s'agit d'un projet d'apprentissage et de démonstration basé sur l'application de démonstration de microservices de Google.
# Simulation d'un Environnement DevOps sur Google Cloud Platform

## Vue D'ensemble

Ce projet simule un environnement DevOps de niveau production sur Google Cloud Platform (GCP) en utilisant l'application de démonstration **Online Boutique**, composée de 11 microservices. 
L'application est clonée depuis le dépôt officiel [Google microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo.git).

Les objectifs principaux sont de :
- Maîtriser les services et l'architecture de Google Cloud Platform
- Implémenter les pratiques DevOps modernes
- Couvrir l'ensemble de la chaîne CI/CD
- Déployer et gérer une application basée sur des microservices à grande échelle

## Technologies & Services GCP utilisés

### Infrastructure & Orchestration
- **Terraform** - Infrastructure as Code (IaC)
- **Google Kubernetes Engine (GKE)** - Cluster Kubernetes managé régional 6 noeuds 
- **Docker** - contenerisation
- **Helm** - Gestionnaire de paquets Kubernetes

### Pipeline CI/CD
- **Cloud Build** - Intégration continue
- **ArgoCD** - Déploiement continu GitOps
- **Artifact Registry** - Stockage des images de conteneurs

### Sécurité & Qualité
- **Trivy** - Analyse de vulnérabilités des conteneurs

### Réseau & Stockage
- **VPC** - Trois sous-réseaux pour le cluster
- **Cloud Load Balancer** - Distribution du trafic
- **PostgreSQL** - Base de données relationnelle

### Monitoring & Observabilité
- **ELK Stack** (Elasticsearch, Logstash, Kibana) - Gestion et analyse des logs
- **Prometheus** - Collecte de métriques
- **Grafana** - Visualisation et tableaux de bord

## Architecture

Le projet implémente une architecture complète de microservices avec :
- 11 microservices interconnectés de l'application Online Boutique
- Pipelines CI/CD automatisés
- Monitoring et logging complets
- Analyse de sécurité et gestion des vulnérabilités
- Workflow de déploiement basé sur GitOps

## Instructions d'installation et de configuration

[Ajoutez vos instructions d'installation et de configuration ici]

## Documentation

A venir

