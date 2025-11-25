pipeline {
    agent any
    
    // Scruter le dépôt toutes les 5 minutes
    triggers {
        pollSCM('H/5 * * * *')
    }
    
    environment {
        // Variables Docker Hub
        DOCKER_HUB_REPO = 'wahidh007/cv-devops'
        DOCKER_HUB_CREDENTIALS = 'dockerhub-credentials' // ID des credentials dans Jenkins
        
        // Variables Slack
        SLACK_CHANNEL = '#jenkins-report' // Modifier selon votre canal
        SLACK_CREDENTIALS = 'slack_token' // ID du token Slack dans Jenkins
        
        // Variables de build
        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKER_HUB_REPO}:${IMAGE_TAG}"
        IMAGE_LATEST = "${DOCKER_HUB_REPO}:latest"
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "🔍 Récupération du code depuis GitHub..."
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[
                            url: 'https://github.com/wahid007/cv_devops.git'
                        ]]
                    ])
                    echo "✅ Code récupéré avec succès"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Construction de l'image Docker..."
                    docker.build("${IMAGE_NAME}")
                    docker.build("${IMAGE_LATEST}")
                    echo "✅ Image Docker construite : ${IMAGE_NAME}"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "📤 Envoi de l'image vers Docker Hub..."
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB_CREDENTIALS}") {
                        docker.image("${IMAGE_NAME}").push()
                        docker.image("${IMAGE_NAME}").push("latest")
                    }
                    echo "✅ Image poussée sur Docker Hub : ${IMAGE_NAME}"
                }
            }
        }
        
        stage('Clean Up') {
            steps {
                script {
                    echo "🧹 Nettoyage des images locales..."
                    sh """
                        docker rmi ${IMAGE_NAME} || true
                        docker rmi ${IMAGE_LATEST} || true
                    """
                    echo "✅ Nettoyage terminé"
                }
            }
        }

        stages {
            stage('Notify Slack') {
                steps {
                    sh '''
                    curl -X POST -H 'Content-type: application/json' \
                    --data '{"text":"Build completed successfully!"}' \
                    https://hooks.slack.com/services/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
                    '''
                }
            }
        }

    }
    
    post {
        success {
            script {
                echo "✅ Pipeline exécuté avec succès !"
                slackSend(
                    channel: "${SLACK_CHANNEL}",
                    color: 'good',
                    message: """
                        ✅ *Build SUCCESS* - CV DevOps Pipeline
                        *Job:* ${env.JOB_NAME}
                        *Build:* #${env.BUILD_NUMBER}
                        *Image:* ${IMAGE_NAME}
                        *Docker Hub:* https://hub.docker.com/r/${DOCKER_HUB_REPO}
                        *Durée:* ${currentBuild.durationString.replace(' and counting', '')}
                        *Détails:* ${env.BUILD_URL}
                    """.stripIndent(),
                    tokenCredentialId: "${SLACK_CREDENTIALS}"
                )
            }
        }
        
        failure {
            script {
                echo "❌ Pipeline échoué !"
                slackSend(
                    channel: "${SLACK_CHANNEL}",
                    color: 'danger',
                    message: """
                        ❌ *Build FAILED* - CV DevOps Pipeline
                        *Job:* ${env.JOB_NAME}
                        *Build:* #${env.BUILD_NUMBER}
                        *Erreur:* Échec lors de l'exécution du pipeline
                        *Durée:* ${currentBuild.durationString.replace(' and counting', '')}
                        *Détails:* ${env.BUILD_URL}console
                    """.stripIndent(),
                    tokenCredentialId: "${SLACK_CREDENTIALS}"
                )
            }
        }
        
        unstable {
            script {
                echo "⚠️ Pipeline instable !"
                slackSend(
                    channel: "${SLACK_CHANNEL}",
                    color: 'warning',
                    message: """
                        ⚠️ *Build UNSTABLE* - CV DevOps Pipeline
                        *Job:* ${env.JOB_NAME}
                        *Build:* #${env.BUILD_NUMBER}
                        *Image:* ${IMAGE_NAME}
                        *Durée:* ${currentBuild.durationString.replace(' and counting', '')}
                        *Détails:* ${env.BUILD_URL}
                    """.stripIndent(),
                    tokenCredentialId: "${SLACK_CREDENTIALS}"
                )
            }
        }
        
        always {
            script {
                echo "🏁 Pipeline terminé"
                cleanWs() // Nettoie le workspace
            }
        }
    }
}

/* 
 * INSTRUCTIONS DE CONFIGURATION JENKINS :
 * 
 * 1. CREDENTIALS DOCKER HUB :
 *    - Aller dans : Jenkins > Manage Jenkins > Credentials
 *    - Ajouter des credentials de type "Username with password"
 *    - ID : dockerhub-credentials
 *    - Username : wahidh007
 *    - Password : [Votre token Docker Hub]
 * 
 * 2. CREDENTIALS SLACK :
 *    - Installer le plugin "Slack Notification"
 *    - Aller dans : Jenkins > Manage Jenkins > Configure System > Slack
 *    - Workspace : [Votre workspace Slack]
 *    - Créer un token Slack : https://api.slack.com/apps
 *    - Ajouter des credentials de type "Secret text"
 *    - ID : slack-token
 *    - Secret : [Votre token Slack]
 * 
 * 3. PLUGINS REQUIS :
 *    - Docker Pipeline
 *    - Docker Commons Plugin
 *    - Git Plugin
 *    - Slack Notification Plugin
 *    - Pipeline
 * 
 * 4. CRÉER LE JOB JENKINS :
 *    - New Item > Pipeline
 *    - Pipeline > Definition : Pipeline script from SCM
 *    - SCM : Git
 *    - Repository URL : https://github.com/wahid007/cv_devops.git
 *    - Script Path : Jenkinsfile
 * 
 * 5. DOCKER HUB TOKEN :
 *    - Se connecter sur https://hub.docker.com
 *    - Account Settings > Security > New Access Token
 *    - Utiliser ce token au lieu du mot de passe
 */