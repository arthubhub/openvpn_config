#!/bin/bash

read -p "Nom d'utilisateur VPN : " USERNAME

echo "Création du certificat pour l'utilisateur : $USERNAME"
docker run -v "$(pwd)/openvpn-data:/etc/openvpn" --rm -it kylemanna/openvpn \
  easyrsa build-client-full "$USERNAME"

# Vérifie si la commande précédente a réussi
if [ $? -eq 0 ]; then
  echo "✅ Certificat généré avec succès. Génération du fichier .ovpn..."
  
  docker run -v "$(pwd)/openvpn-data:/etc/openvpn" --rm kylemanna/openvpn \
    ovpn_getclient "$USERNAME" > "users/$USERNAME.ovpn"
  
  echo "🎉 Fichier $USERNAME.ovpn généré avec succès."
else
  echo "❌ Erreur : échec de la création du certificat (mot de passe CA incorrect ou autre erreur)."
  echo "🛑 Abandon de la génération du fichier .ovpn."
fi

