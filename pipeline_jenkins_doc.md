
## ✨ Fonctionnalités

1. ✅ **Récupération du code** depuis `https://github.com/wahid007/cv_devops.git`
2. ✅ **Scrutation automatique** toutes les 5 minutes (`pollSCM('H/5 * * * *')`)
3. ✅ **Build de l'image Docker** avec tags `latest` et numéro de build
4. ✅ **Push sur Docker Hub** vers `wahidh007/cv-devops`
5. ✅ **Notifications Slack** pour chaque résultat (succès, échec, instable)

## 📋 Configuration requise

### 1️⃣ Installer les plugins Jenkins
```
- Docker Pipeline
- Docker Commons Plugin
- Git Plugin
- Slack Notification Plugin
```

### 2️⃣ Configurer Docker Hub Credentials
```
Manage Jenkins > Credentials > Add Credentials
- Type: Username with password
- ID: dockerhub-credentials
- Username: wahidh007
- Password: [Votre token Docker Hub]
```

**Comment créer un token Docker Hub :**
- Allez sur https://hub.docker.com
- Account Settings > Security > New Access Token
- Copiez le token généré

### 3️⃣ Configurer Slack
```
Manage Jenkins > Manage Plugins > Installer "Slack Notification"
Manage Jenkins > Configure System > Slack
- Workspace: [Votre workspace]
- Credentials: Ajouter votre token Slack
```

**Comment créer un token Slack :**
- Allez sur https://api.slack.com/apps
- Créez une nouvelle app
- OAuth & Permissions > Bot Token Scopes > Ajoutez `chat:write`
- Installez l'app et copiez le token

### 4️⃣ Créer le Job Jenkins
```
1. New Item > Nom: "CV-DevOps-Pipeline" > Pipeline
2. Build Triggers > Poll SCM (déjà dans le Jenkinsfile)
3. Pipeline:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: https://github.com/wahid007/cv_devops.git
   - Branch: */main
   - Script Path: Jenkinsfile
4. Save
```

## 🎯 Variables à personnaliser

Dans le Jenkinsfile, modifiez si nécessaire :
- `SLACK_CHANNEL` : Canal Slack pour les notifications
- Branche Git (actuellement `main`)

Le pipeline créera des images avec deux tags :
- `wahidh007/cv-devops:BUILD_NUMBER`
- `wahidh007/cv-devops:latest`