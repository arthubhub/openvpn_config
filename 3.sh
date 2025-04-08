# Crée le volume Docker pour stocker la configuration
docker run -v $(pwd)/openvpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://veagle.fr

# Initialise l'autorité de certification et crée les clés serveur (entrer un mot de passe si demandé)
docker run -v $(pwd)/openvpn-data:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

