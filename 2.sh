echo 'version: "3"

services:
  openvpn:
    image: kylemanna/openvpn
    container_name: openvpn
    cap_add:
      - NET_ADMIN
    ports:
      - "1194:1194/udp"
    restart: always
    volumes:
      - ./openvpn-data:/etc/openvpn
' > docker-compose.yml 
