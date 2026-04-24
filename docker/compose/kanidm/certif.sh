# 1. On s'assure que le dossier nous appartient pour pouvoir écrire dedans
sudo chown -R $USER:$USER data

# 2. On génère les certificats avec OpenSSL (en forçant si besoin)
openssl req -x509 -newkey rsa:4096 -keyout data/key.pem -out data/chain.pem -days 3650 -nodes -subj "/CN=idm.bitiso.net"

# 3. On donne les droits DEFINITIFS à l'utilisateur de Kanidm (1000)
sudo chown -R 1000:1000 data
