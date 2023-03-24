# Configurar HTTPS para Localhost

## Dns Masq - Linux
### 1. Registrar o domínio no dns: [setup-dnsmasq.sh](https://gist.github.com/archan937/d35deef3b1f2b5522dd4b8f397038d27)
#### 1.1. no arquivo `setup-dnsmasq.sh` configurar o "domínio" desejado (default: .docker.localhost)
#### 1.2. executar o comando "./setup-dnsmasq.sh"
---
### 2. Certificados HTTPS [MKcert](https://github.com/FiloSottile/mkcert):
#### 2.1 Baixar o aplicativo MKCERT no Linux (ou Windows WSL):
#####
```shell
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64

mv mkcert-v1.4.4-linux-amd64 mkcert

chmod +x mkcert

./mkcert --install
```
#### 2.2 Gerar o certificado com os domínios desejados (*.docker.localhost, *.dev.localhost, localhost, *.localhost):
```
./mkcert -cert-file=./certs/local-cert.pem -key-file=./certs/local-key.pem "*.docker.localhost" "docker.localhost" "dev.localhost" "*.dev.localhost" "localhost" "*.localhost"
```

On WSL2, running `mkcert -install` will not install the rootCA in the Windows certificate store. Users of WSL2 should extract the certificate (location given by `mkcert -CAROOT`) and use the Windows binary mkcert to install the rootCA.
#### 2.3 copiar o endereco da pasta dos certificados CAROOT para o Windows (caso esteja usando o WSL2)
```shell
mkcert -CAROOT
```
##### 2.4 Baixar o executável
    -   [MKcert.exe](https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-windows-arm64.exe)
##### 2.5 Configurar o CAROOT nos navegadores do Windows
No cmd.exe do Windows (rodando como Administrador), executar o comando, substituindo o "UsernameWindows" pelo nome do usuário do Windows e o caminho pelo caminho do CAROOT (2.3) gerado no WSL2:

```cmd
C:\Users\UsernameWindows\Desktop> set CAROOT=\\wsl.localhost\Ubuntu\home\UsernameLinux\.local\share\mkcert
C:\Users\UsernameWindows\Desktop> set CAROOT=\\wsl.localhost\Ubuntu\home\UsernameLinux\.local\share\mkcert
C:\Users\UsernameWindows\Desktop> mkcert.exe -CAROOT
C:\Users\UsernameWindows\Desktop> mkcert.exe -install
Using the local CA at "\\wsl.localhost\Ubuntu\home\UsernameLinux\.local\share\mkcert" ✨
The local CA is now installed in the system trust store! ⚡️
Note: Firefox support is not available on your platform. ℹ️
```
