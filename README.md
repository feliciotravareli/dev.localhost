# Configurar HTTPS para Localhost

## 1. Registrar o domínio no dns: [setup-dnsmasq.sh](https://gist.github.com/archan937/d35deef3b1f2b5522dd4b8f397038d27)
### 1.1. no arquivo `setup-dnsmasq.sh` configurar o "domínio" desejado (default: .localhost)
### 1.2. executar o comando "./setup-dnsmasq.sh"
---
## 2. [Nginx Proxy Manager](https://nginxproxymanager.com/) e o [Portainer](https://www.portainer.io/)
### 2.1. executar `docker compose up -d` para iniciar os containers do docker
### 2.2. entrar no nginx proxy manager pelo endereço [localhost:81](localhost:81)
```
Email:    admin@example.com
Password: changeme
```
---
## 3. Gerador de certificados [MKcert](https://github.com/FiloSottile/mkcert):
### 3.1 Baixar o aplicativo MKCERT:
```
cd certs
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64
mv mkcert-v1.4.4-linux-amd64 mkcert
chmod +x mkcert
./mkcert --install
```
### 3.1. Gerar um certificado (por exemplo: portainer):
```
cd certs
./mkcert portainer.localhost
```
### 3.2. adicionar certificado no nginx proxy manager:
```
SSL Certificates > Add SSL Certificate > Custom
```
### 3.2.1. Selecionar um nome, e indicar os arquivos do certificado gerado no passo anterior (key e certificate)
```
key: certs/portainer.localhost-key.pem
cetificate: certs/portainer.localhost.pem
```
### 3.4. Adicionar um novo proxy:
```
Hosts > Proxy Hosts > Add Proxy Host
```
### 3.4.1 Definir um domínio (portainer.localhost)
 - Domain names: *portainer.localhost*
 - Scheme: "https"
 - Forward Hostname/IP: localhost
 - Forward Port: 9443
### 3.4.2. Na aba "SSL" selecionar o certificado criado no passo _3.2_ e salvar
### 3.4.3. O endereço [https://portainer.localhost](https://portainer.localhost) deve estar acessível e sendo servido por https
