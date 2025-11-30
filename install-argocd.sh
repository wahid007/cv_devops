#!/bin/bash
# Script d'installation ArgoCD sur K3s avec NodePort

set -e

echo "=== Installation ArgoCD sur K3s ==="

# 1. Créer le namespace argocd
echo "Création du namespace argocd..."
kubectl create namespace argocd

# 2. Installer ArgoCD
echo "Installation d'ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Attendre que les pods soient prêts
echo "Attente du démarrage des pods ArgoCD..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# 4. Patcher le service argocd-server pour utiliser NodePort
echo "Configuration du service NodePort..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# Optionnel : Définir un NodePort spécifique (30100)
kubectl patch svc argocd-server -n argocd --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30100}]'

# 5. Récupérer le mot de passe initial admin
echo ""
echo "=== Récupération du mot de passe admin ==="
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# 6. Obtenir l'IP du nœud
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[0].nodePort}')

# 7. Afficher les informations de connexion
echo ""
echo "=========================================="
echo "ArgoCD installé avec succès !"
echo "=========================================="
echo "URL d'accès: http://$NODE_IP:$NODE_PORT"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"
echo "=========================================="
echo ""
echo "Pour installer ArgoCD CLI:"
echo "curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
echo "chmod +x /usr/local/bin/argocd"
echo ""
echo "Pour se connecter via CLI:"
echo "argocd login $NODE_IP:$NODE_PORT --username admin --password $ARGOCD_PASSWORD --insecure"
echo ""

# 8. Afficher le statut des pods
echo "Statut des pods ArgoCD:"
kubectl get pods -n argocd

# 9. Afficher les services
echo ""
echo "Services ArgoCD:"
kubectl get svc -n argocd