# Setup Ambiente de Desenvolvimento
o ambiente de desenvolvimento é composto por 3 repositórios:
    - [ambiente](https://git-codecommit.us-east-1.amazonaws.com/v1/repos/dev.localhost)
    - [api](https://git-codecommit.us-east-1.amazonaws.com/v1/repos/api)
    - [portal-professor](https://git-codecommit.us-east-1.amazonaws.com/v1/repos/portal-professor)

O ambiente é a base para os demais repositórios, contendo as configurações de ambiente, docker-compose e scripts de inicialização.

---
## 0. Instalando dependencias
- WSL (pelo powershell como admin executar)
```
wsl --install
```

- Docker Desktop
    - [Windows](https://docs.docker.com/docker-for-windows/install/)
    - [Mac](https://docs.docker.com/docker-for-mac/install/)
    - [Linux](https://docs.docker.com/engine/install/ubuntu/)


## 1. Preparando AMBIENTE inicial
### 1.1 clonar repositório dev.localhost

***AWS_USER_ID*** é o ID do usuário da AWS, que pode ser obtido no console da AWS, na aba IAM, na seção "Usuários", clicando no nome do usuário e copiando o ID do usuário.

Configurar o Git para usar a chave/user da AWS adicionando o trecho abaixo no arquivo __~/.ssh/config__:
```
Host git-codecommit.*.amazonaws.com
  User AWS_USER_ID
  IdentityFile ~/.ssh/id_rsa
```

Escolha um diretório, preferencialmente sem espacos no nome, evitando por exemplo "Área de Trabalho" e execute o comando abaixo:

```shell
    git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/dev.localhost
```
### 1.2 entrar no diretório clonado
```shell
    cd dev.localhost
```

A partir daqui, levar em consideração que o diretório atual é o *"dev.localhost"*

---
## 2. API
### 2.1 clonar repositorio da api
```shell
    git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/api
```
### 2.2 copiar os arquivos da pasta _"ambiente/envs"_ para dentro da pasta da _"api"_
```shell
    cp -r ./ambiente/envs/.* ./api/
```
### 2.3 adicionar as chaves (_secrets_) recebidas por email no do arquivo __.env__ de __DENTRO__ da pasta __api__
```shell
    nano ./api/.env
```
```dotenv
APP_KEY="base64:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
JWT_SECRET="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
GOOGLE_MAPS_API_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
### 2.4 instalar as dependencias do composer
```shell
    docker compose -f ./api/docker-compose.yml run --rm composer install
```

---
## 3. portal-professor
### 3.1 clonar repositorio do portal-professor
```shell
    git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/portal-professor
```
### 3.2 criar o arquivo __environments/environment.dev.ts__ ("TODO": colocar arquivo no repositorio para nao precisar desse passo)
```
echo "export const environment: any = {
    production: false,
};" > ./portal-professor/src/environments/environment.dev.ts
```

## 3. portal-aluno
### 3.1 clonar repositorio do portal-aluno
```shell
    git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/portal-aluno
```

---
## 5. Certificados HTTPS [MKcert](https://github.com/FiloSottile/mkcert):
### 5.1 Baixar o aplicativo MKCERT no Windows WSL:

```shell
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64

mv mkcert-v1.4.4-linux-amd64 ./ambiente/certs/mkcert

sudo chmod +x ./ambiente/certs/mkcert

./ambiente/certs/mkcert --install
```
### 5.2 Gerar o certificado com os domínios desejados:
```
./ambiente/certs/mkcert -cert-file ./ambiente/certs/local-cert.pem -key-file ./ambiente/certs/local-key.pem \
    "docker.localhost" "*.docker.localhost" \
    "dev.localhost" "*.dev.localhost" \
    "prod.localhost" "*.prod.localhost" \
    "ext.localhost" "*.ext.localhost" \
    "*.mairiporaeducasim.prod.localhost" "*.mairiporaeducasim.dev.localhost" "*.mairiporaeducasim.ext.localhost" \
    "*.educafrancodarocha.prod.localhost" "*.educafrancodarocha.dev.localhost" "*.educafrancodarocha.ext.localhost" \
    "*.educaita.prod.localhost" "*.educaita.dev.localhost" "*.educaita.ext.localhost" \
    "*.educailhabela.prod.localhost"  "*.educailhabela.dev.localhost" "*.educailhabela.ext.localhost" \
    "*.nilopoliseduca.prod.localhost" "*.nilopoliseduca.dev.localhost" "*.nilopoliseduca.ext.localhost" \
    "*.educaitapecerica.prod.localhost" "*.educaitapecerica.dev.localhost" "*.educaitapecerica.ext.localhost" \
    "*.segundotempoaruja.prod.localhost" "*.segundotempoaruja.dev.localhost" "*.segundotempoaruja.ext.localhost" \
    "*.escolaonlineguara.prod.localhost"  "*.escolaonlineguara.dev.localhost" "*.escolaonlineguara.ext.localhost" \
    "*.educapindamonhagaba.prod.localhost" "*.educapindamonhagaba.dev.localhost" "*.educapindamonhagaba.ext.localhost" \
    "*.educaaruja.prod.localhost" "*.educaaruja.dev.localhost" "*.educaaruja.ext.localhost"
```
### 5.3 Instalar o rootCA no Windows
Por padrão o mkcert não instala o _rootCA_ no Windows, para isso é necessário executar o mkcert.exe do Windows. Antes, vamos anotar o diretório do rootCA instlado no passo anterior:

```shell
./ambiente/certs/mkcert -CAROOT
```

Deve aparecer algo como:

```shell
/home/UsernameLinux/.local/share/mkcert
```
### 5.4 Baixar o executável
    - [MKcert.exe](https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-windows-amd64.exe)
    - renomear para "mkcert.exe"
```
ren "mkcert-v1.4.4-windows-amd64.exe" mkcert.exe
```
### 5.5 Configurar o CAROOT nos navegadores do Windows
No cmd.exe do Windows (rodando como Administrador), executar o comando, substituindo o "UsernameWindows" pelo nome do usuário do Windows e o caminho pelo caminho do CAROOT (4.3) gerado no WSL2:

```cmd
C:\Users\UsernameWindows\Desktop> set CAROOT=\\wsl.localhost\Ubuntu\home\UsernameLinux\.local\share\mkcert
C:\Users\UsernameWindows\Desktop> mkcert.exe -CAROOT
C:\Users\UsernameWindows\Desktop> mkcert.exe -install
Using the local CA at "\\wsl.localhost\Ubuntu\home\UsernameLinux\.local\share\mkcert" ✨
The local CA is now installed in the system trust store! ⚡️
Note: Firefox support is not available on your platform. ℹ️
```

---
## 6. Iniciando o ambiente
### 6.1 criar uma rede no docker para o proxy
```shell
docker network create proxy
```
### 6.2 subir todo o sistema
```shell
docker compose up -d
```

---
## 7. Ambientes disponíveis
### 7.1 Infraestrutura
    - [Traefik](https://traefik.docker.localhost)
    - [Portainer](https://portainer.docker.localhost)

### 7.2 Desenvolvimento - API
Endereços para acesso à API (backend) de cada municipio, utilizando a __API LOCAL__ e o __BANCO DE DADOS LOCAL__
    - [Franco da Rocha - API - DEV](https://api.educafrancodarocha.dev.localhost)
    - [Mairiporã - API - DEV](https://api.mairiporaeducasim.dev.localhost)
    - [Itanhaém - API - DEV](https://api.educaita.dev.localhost)
    - [Nilópolis - API - DEV](https://api.nilopoliseduca.dev.localhost)
    - [Ilhabela - API - DEV](https://api.educailhabela.dev.localhost)
    - [Guarátinguetá - API - DEV](https://api.escolaonlineguara.dev.localhost)
    - [Arujá - API - DEV](https://api.segundotempoaruja.dev.localhost)
    - [Arujá - API - DEV](https://api.educaaruja.dev.localhost)
    - [Itapecerica da Serra - API - DEV](https://api.educaitapecerica.dev.localhost)
    - [Pindamonhagaba - API - DEV](https://api.educapindamonhangaba.dev.localhost)
### 7.3 Desenvolvimento - Portal Professor
Endereços para acesso ao portal do professor de cada municipio, utilizando o __Portal do Professor LOCAL__ e a __API LOCAL__
    - [Franco da Rocha - Prof - DEV](https://professor.educafrancodarocha.dev.localhost)
    - [Mairiporã - Prof - DEV](https://professor.mairiporaeducasim.dev.localhost)
    - [Itanhaém - Prof - DEV](https://professor.educaita.dev.localhost)
    - [Nilópolis - Prof - DEV](https://professor.nilopoliseduca.dev.localhost)
    - [Ilhabela - Prof - DEV](https://professor.educailhabela.dev.localhost)
    - [Guarátinguetá - Prof - DEV](https://professor.escolaonlineguara.dev.localhost)
    - [Arujá - Prof - DEV](https://professor.segundotempoaruja.dev.localhost)
    - [Arujá - Prof - DEV](https://professor.educaaruja.dev.localhost)
    - [Itapecerica da Serra - Prof - DEV](https://professor.educaitapecerica.dev.localhost)
    - [Pindamonhagaba - Prof - DEV](https://professor.educapindamonhangaba.dev.localhost)
### 7.4 Produção - Portal Professor
Endereços para acesso ao portal do professor de cada municipio, utilizando o __Portal do Professor LOCAL__ e a  __API DE PRODUÇÃO__
    - [Franco da Rocha - Prof - PROD](https://professor.educafrancodarocha.prod.localhost)
    - [Mairiporã - Prof - PROD](https://professor.mairiporaeducasim.prod.localhost)
    - [Itanhaém - Prof - PROD](https://professor.educaita.prod.localhost)
    - [Nilópolis - Prof - PROD](https://professor.nilopoliseduca.prod.localhost)
    - [Ilhabela - Prof - PROD](https://professor.educailhabela.prod.localhost)
    - [Guarátinguetá - Prof - PROD](https://professor.escolaonlineguara.prod.localhost)
    - [Arujá - Prof - PROD](https://professor.segundotempoaruja.prod.localhost)
    - [Arujá - Prof - PROD](https://professor.educaaruja.prod.localhost)
    - [Itapecerica da Serra - Prof - PROD](https://professor.educaitapecerica.prod.localhost)
    - [Pindamonhagaba - Prof - PROD](https://professor.educapindamonhangaba.prod.localhost)

---
## 8. Bancos de dados de Desenvolvimento (Fake)
### 8.1 Fazer o download de cada dump do utilizando a url "/admin/dumps" em cada servidor de producao e colocar na pasta `dumps`
### 8.2 Descompactar cada dump para o banco de dados
```shell
gzip -d ./dumps/franco.sql.gz
gzip -d ./dumps/mairipora.sql.gz
gzip -d ./dumps/itanhaem.sql.gz
gzip -d ./dumps/nilopolis.sql.gz
gzip -d ./dumps/ilhabela.sql.gz
gzip -d ./dumps/guaratingueta.sql.gz
gzip -d ./dumps/aruja.sql.gz
gzip -d ./dumps/itapecerica.sql.gz
```
### 8.3 Importar cada dump para o banco de dados
```shell
docker exec -i devlocalhost.mariadb sh -c 'exec mariadb -uroot -ppassword --max-allowed-packet=1073741824 --database franco' < ./dumps/franco.sql
docker exec -i devlocalhost.mariadb sh -c 'exec mariadb -uroot -ppassword --max-allowed-packet=1073741824 --database mairipora' < ./dumps/mairipora.sql
docker exec -i devlocalhost.mariadb sh -c 'exec mariadb -uroot -ppassword --max-allowed-packet=1073741824 --database itanhaem' < ./dumps/itanhaem.sql
docker exec -i devlocalhost.mariadb sh -c 'exec mariadb -uroot -ppassword --max-allowed-packet=1073741824 --database nilopolis' < ./dumps/nilopolis.sql
docker exec -i devlocalhost.mariadb sh -c 'exec mariadb -uroot -ppassword --max-allowed-packet=1073741824 --database ilhabela' < ./dumps/ilhabela.sql
docker exec -i devlocalhost.mariadb sh -c 'exec mariadb -uroot -ppassword --max-allowed-packet=1073741824 --database guaratingueta' < ./dumps/guaratingueta.sql
docker exec -i devlocalhost.mariadb sh -c 'exec mariadb -uroot -ppassword --max-allowed-packet=1073741824 --database aruja' < ./dumps/aruja.sql
docker exec -i devlocalhost.mariadb sh -c 'exec mariadb -uroot -ppassword --max-allowed-packet=1073741824 --database itapecerica' < ./dumps/itapecerica.sql
```
