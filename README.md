# BabyLog 👶

> _Moins de doutes, plus de clarté._ — Votre compagnon parentalité intelligent.

[![Live demo](https://img.shields.io/badge/Live_demo-babylog.space-2E7D32?logo=safari&logoColor=white)](https://www.babylog.space)
[![YouTube demo](https://img.shields.io/badge/Demo_vidéo-YouTube-FF0000?logo=youtube&logoColor=white)](https://youtu.be/GDcfvlVaDjs)
[![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-8.0-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![Anthropic Claude](https://img.shields.io/badge/Claude_API-D97757?logo=anthropic&logoColor=white)](https://www.anthropic.com/)

🌐 **Démo en ligne** : https://www.babylog.space  
🎬 **Présentation vidéo (Le Wagon Demo Day, Batch #2208)** : https://youtu.be/GDcfvlVaDjs

---

## Le projet

BabyLog est une application web **mobile-first** pensée pour les jeunes parents d'enfants entre 0 et 4 ans. Elle combine un suivi personnalisé du profil de chaque enfant avec un assistant IA capable de répondre aux inquiétudes du quotidien — fièvre, sommeil, alimentation, développement — et de générer des plans d'action structurés.

L'objectif : **rassurer, guider, accompagner**, sans remplacer un avis médical.

Le projet a été mené en équipe de quatre développeurs en sprint d'une semaine, dans le cadre du parcours **AI Software** du bootcamp Le Wagon (Batch #2208 Marseille, mars 2026).

## Fonctionnalités principales

### 👶 Profils enfants multi-bébés
- Création, modification, suppression de profils détaillés (date de naissance, prénom, particularités).
- Carrousel d'enfants en page d'accueil, avec sélection rapide.
- Stockage des avatars via Active Storage.

### 💬 Chatbot IA contextualisé (Claude Sonnet)
- Page de chat dédiée à chaque enfant : l'historique et le profil sont injectés dans le contexte.
- Claude répond en langage naturel et produit, quand c'est pertinent, un **plan d'action structuré en 3-4 étapes**.
- Historique des conversations consultable et reprise possible.

### 💉 Suivi vaccinal français
- Calendrier vaccinal officiel intégré.
- Visualisation des vaccins faits, à venir, en retard.

### 🚨 Sécurité & urgences
- Page « Les gestes qui sauvent » — fiches premiers secours pédiatriques.
- Liste des numéros d'urgence accessibles en un tap.

### 🔐 Authentification
- Devise (database_authenticatable, registerable, recoverable, rememberable, validatable).
- Cloisonnement strict des données par compte parent.

## Stack technique

| Couche | Choix |
|---|---|
| **Framework** | Ruby on Rails 8 |
| **Base de données** | PostgreSQL |
| **Authentification** | Devise |
| **IA conversationnelle** | RubyLLM + API Anthropic Claude (Sonnet) |
| **Front** | Hotwire (Turbo + Stimulus), Bootstrap 5, Importmap |
| **Stockage de fichiers** | Active Storage (avatars enfants) |
| **PWA** | Mobile-web-app-capable, apple-touch-icon, manifest |
| **Design** | Figma (maquettes haute fidélité + prototype interactif) |
| **Déploiement** | Scalingo (production sur https://www.babylog.space) |
| **Collaboration** | Git, GitHub, méthode agile |

## Mon rôle dans l'équipe

Projet collectif à 4 développeurs (Kaliaa77, [Sarah-ABILA](https://github.com/Sarah-ABILA), mariecantau, aliamzil) — j'ai contribué **28 commits** sur l'historique du repo (deuxième contributrice).

J'ai pris en charge **l'ensemble du design produit et du front-end** :

### 🎨 Design (Figma)
- **Maquettes haute fidélité** de tous les écrans : page d'accueil, carrousel enfants, fiche enfant, page de chat, suivi vaccinal, gestes qui sauvent, numéros d'urgence, login/signup.
- **Prototype interactif** navigable dans Figma : transitions et parcours utilisateur complet, validés par l'équipe avant développement.
- Choix de la palette, de la typographie et de l'identité visuelle (logo, tagline _« Moins de doutes, plus de clarté »_).

### 💻 Front-end (intégralité)
- **Toutes les vues ERB** et les layouts Bootstrap mobile-first.
- **Contrôleurs Stimulus** : carrousel des enfants, déclenchement du coaching IA, mise à jour live du suivi vaccinal.
- **Navigation** Hotwire/Turbo entre les sections, barre de navigation bas d'écran (4 onglets).
- **Habillage PWA** : manifest, apple-touch-icon, mobile-web-app-capable.

### 🔐 Authentification & stockage
- Intégration de **Devise** côté backend + design des pages login / sign up / forgot password.
- Mise en place d'**Active Storage** pour les avatars enfants (upload, validation, affichage).

### 👥 Travail d'équipe
- Code reviews croisées avec les trois autres développeurs sur les pull requests back-end.
- Résolution des conflits de merge front/back sur une équipe de 4.

> Le repo collaboratif d'origine est [mariecantau/BabyLog](https://github.com/mariecantau/BabyLog). Cette version est mon fork personnel pour la mise en avant portfolio. L'historique Git d'origine — y compris mes 28 commits — est conservé.

## Lancer le projet localement

Prérequis : **Ruby 3.2+**, **PostgreSQL 14+**, **Node** (pour Importmap), **clé API Anthropic**.

```bash
git clone https://github.com/Sarah-ABILA/BabyLog.git
cd BabyLog

bundle install
yarn install

# Variables d'environnement
cp .env.example .env
# Renseigner ANTHROPIC_API_KEY=sk-ant-...

# Préparer la base
rails db:create db:migrate db:seed

# Démarrer
bin/dev
```

L'application est disponible sur `http://localhost:3000`.

## Ce que j'ai appris en construisant BabyLog

- **Concevoir une UX dans Figma** puis l'implémenter intégralement en HTML/CSS/Stimulus, en restant fidèle aux maquettes.
- **Travailler en sprint Agile court** (1 semaine) avec une équipe de 4 développeurs sur un produit livrable.
- **Penser mobile-first** dès la conception, en s'inspirant des standards PWA.
- **Déployer en production avec un domaine custom** (Scalingo + DNS).
- **Coordonner Git en équipe** : feature branches, pull requests, code reviews et résolution de conflits front ↔ back.

## Crédits

Conçu et développé par **Kaliaa77, [Sarah-ABILA](https://github.com/Sarah-ABILA), mariecantau et aliamzil** — bootcamp Le Wagon, parcours AI Software, Batch #2208 (mars 2026).

⚠️ **Avis médical** : BabyLog est un outil d'orientation et de réassurance. Il ne remplace en aucun cas l'avis d'un professionnel de santé. En cas d'urgence, contactez le 15, le 112 ou le SAMU pédiatrique.

---

_Sarah Abila — Hyères (83) — [LinkedIn](https://linkedin.com/in/sarah-abila-278041378) — [GitHub](https://github.com/Sarah-ABILA)_
