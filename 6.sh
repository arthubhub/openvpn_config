#!/bin/bash

read -p "Nom d'utilisateur VPN à supprimer : " USERNAME

echo "📛 Révocation du certificat utilisateur : $USERNAME"

# Lancer la commande de révocation (demande le mot de passe CA si protégé)
docker run -v "$(pwd)/openvpn-data:/etc/openvpn" --rm -it kylemanna/openvpn \
  easyrsa revoke "$USERNAME"

# Vérifie si la révocation a réussi
if [ $? -ne 0 ]; then
  echo "❌ Erreur : échec de la révocation de $USERNAME"
  exit 1
fi

# Regénère la CRL (certificat de révocation)
docker run -v "$(pwd)/openvpn-data:/etc/openvpn" --rm -it kylemanna/openvpn \
  easyrsa gen-crl

# Supprime les fichiers associés
echo "🧹 Suppression des fichiers du client : $USERNAME"
docker run -v "$(pwd)/openvpn-data:/etc/openvpn" --rm kylemanna/openvpn \
  bash -c "rm -f \
    /etc/openvpn/pki/reqs/${USERNAME}.req \
    /etc/openvpn/pki/private/${USERNAME}.key \
    /etc/openvpn/pki/issued/${USERNAME}.crt"

# Affiche confirmation
echo "✅ L'utilisateur $USERNAME a été révoqué et ses fichiers ont été supprimés."

# Optionnel : supprimer le fichier .ovpn local si tu l'avais généré
if [ -f "users/${USERNAME}.ovpn" ]; then
  rm -i "users/${USERNAME}.ovpn"
fi

