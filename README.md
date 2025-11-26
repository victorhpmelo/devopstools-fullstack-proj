# 🚀 Projeto Final de DevOps

Projeto completo de DevOps integrando desenvolvimento, containerização, versionamento, CI/CD, monitoramento e testes.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Requisitos](#requisitos)
- [Instalação e Execução](#instalação-e-execução)
- [Funcionalidades](#funcionalidades)
- [API Endpoints](#api-endpoints)
- [Monitoramento com Zabbix](#monitoramento-com-zabbix)
- [Testes com Postman](#testes-com-postman)
- [Estrutura de Branches](#estrutura-de-branches)

## 🎯 Visão Geral

Este projeto implementa uma aplicação web completa com:
- **Frontend**: React com interface moderna e responsiva
- **Backend**: Node.js/Express com API RESTful
- **Banco de Dados**: PostgreSQL com persistência de dados
- **Containerização**: Docker e Docker Compose
- **Monitoramento**: Zabbix para monitoramento de recursos
- **Testes**: Collection do Postman com testes automáticos

## 📁 Estrutura do Projeto

```
projeto-devops/
├── backend/                 # API Node.js/Express
│   ├── server.js           # Servidor principal
│   ├── package.json        # Dependências do backend
│   └── Dockerfile          # Imagem Docker do backend
├── frontend/               # Aplicação React
│   ├── src/               # Código fonte React
│   ├── public/          # Arquivos públicos
│   ├── package.json      # Dependências do frontend
│   ├── Dockerfile        # Imagem Docker do frontend
│   └── nginx.conf        # Configuração Nginx
├── database/              # Scripts de banco de dados
│   └── init.sql          # Script de inicialização
├── zabbix/                # Configuração do Zabbix
│   └── docker-compose.yml # Orquestração do Zabbix
├── docker-compose.yml     # Orquestração principal
├── postman_collection.json # Collection do Postman
└── README.md              # Este arquivo
```

## 🔧 Requisitos

- Docker (versão 20.10 ou superior)
- Docker Compose (versão 2.0 ou superior)
- Git (para controle de versão)
- Postman (para testes da API - opcional)

## ⚠️ Verificação Rápida - Docker Desktop

**IMPORTANTE:** Antes de executar o projeto, certifique-se de que o **Docker Desktop está rodando**!

### Verificar se o Docker está rodando:

```powershell
# Execute no PowerShell
docker ps
```

Se você receber um erro como:
```
error during connect: open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.
```

**O Docker Desktop não está rodando!** 

### Solução Rápida:

1. **Abra o Docker Desktop** (procure no menu Iniciar)
2. **Aguarde** até o ícone na bandeja ficar verde (1-3 minutos)
3. **Execute novamente:** `docker ps` (deve funcionar sem erro)

### Script de Verificação:

Execute o script incluído no projeto:

```powershell
.\verificar-docker.ps1
```

Para mais detalhes, consulte: [INICIAR-DOCKER.md](INICIAR-DOCKER.md)

## 🚀 Instalação e Execução

### 1. Clone o Repositório

```bash
git clone <url-do-repositorio>
cd projeto-devops
```

### 2. Executar a Aplicação Principal

Para iniciar todos os serviços (frontend, backend e banco de dados):

```bash
docker-compose up -d
```

Este comando irá:
- Criar e iniciar o container do PostgreSQL
- Criar e iniciar o container do Backend
- Criar e iniciar o container do Frontend
- Configurar a rede entre os serviços

### 3. Verificar os Serviços

Após alguns segundos, os serviços estarão disponíveis em:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **Health Check**: http://localhost:3001/health
- **PostgreSQL**: localhost:5432

### 4. Executar o Zabbix (Monitoramento)

Para iniciar o ambiente de monitoramento:

```bash
cd zabbix
docker-compose up -d
```

O Zabbix estará disponível em:
- **Zabbix Web Interface**: http://localhost:8080
  - Usuário padrão: `Admin`
  - Senha padrão: `zabbix`

### 5. Parar os Serviços

Para parar todos os serviços:

```bash
# Parar a aplicação principal
docker-compose down

# Parar o Zabbix
cd zabbix
docker-compose down
```

Para remover também os volumes (dados do banco):

```bash
docker-compose down -v
```

## ✨ Funcionalidades

### Aplicação Web

- ✅ Interface moderna e responsiva
- ✅ CRUD completo (Create, Read, Update, Delete)
- ✅ Validação de formulários
- ✅ Mensagens de feedback ao usuário
- ✅ Listagem de itens com informações detalhadas

### API RESTful

- ✅ **GET** `/api/items` - Lista todos os itens
- ✅ **GET** `/api/items/:id` - Busca item por ID
- ✅ **POST** `/api/items` - Cria novo item
- ✅ **PUT** `/api/items/:id` - Atualiza item existente
- ✅ **DELETE** `/api/items/:id` - Exclui item
- ✅ **GET** `/health` - Health check da API

### Banco de Dados

- ✅ PostgreSQL 15
- ✅ Persistência de dados com volumes Docker
- ✅ Tabela `items` com campos: id, name, description, created_at, updated_at

## 📡 API Endpoints

### Health Check
```http
GET /health
```

**Resposta:**
```json
{
  "status": "healthy",
  "database": "connected",
  "timestamp": "2025-01-03T10:00:00.000Z"
}
```

### Listar Itens
```http
GET /api/items
```

**Resposta:**
```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "id": 1,
      "name": "Item 1",
      "description": "Descrição do item",
      "created_at": "2025-01-03T10:00:00.000Z",
      "updated_at": "2025-01-03T10:00:00.000Z"
    }
  ]
}
```

### Criar Item
```http
POST /api/items
Content-Type: application/json

{
  "name": "Novo Item",
  "description": "Descrição do novo item"
}
```

### Atualizar Item
```http
PUT /api/items/:id
Content-Type: application/json

{
  "name": "Item Atualizado",
  "description": "Nova descrição"
}
```

### Excluir Item
```http
DELETE /api/items/:id
```

## 📊 Monitoramento com Zabbix

O Zabbix está configurado para monitorar:

- **CPU**: Uso de processador dos containers
- **Memória**: Uso de memória RAM
- **Disponibilidade**: Status dos serviços (frontend, backend, banco de dados)
- **Rede**: Tráfego de rede

### Configuração do Zabbix

1. Acesse http://localhost:8080
2. Faça login com `Admin` / `zabbix`
3. Configure hosts e templates conforme necessário
4. O Zabbix Agent já está configurado para monitorar o sistema

### Guias de Configuração

- **Guia Rápido:** `zabbix/GUIA-RAPIDO.md` - Configuração básica em 5 passos
- **Guia Completo:** `zabbix/CONFIGURAR-HOSTS-TEMPLATES.md` - Instruções detalhadas passo a passo
- **Solução de Problemas:** `zabbix/SOLUCAO-ERRO-BANCO.md` - Resolver erros de conexão

## 🧪 Testes com Postman

A collection do Postman (`postman_collection.json`) inclui:

- ✅ Testes automáticos para todas as rotas
- ✅ Validação de status codes
- ✅ Validação de estrutura de resposta
- ✅ Testes de criação, leitura, atualização e exclusão

### Como usar:

1. Abra o Postman
2. Importe o arquivo `postman_collection.json`
3. Execute a collection completa ou requisições individuais
4. Os testes automáticos serão executados automaticamente

### Executar Collection Completa:

1. Selecione a collection "Projeto DevOps - API Collection"
2. Clique em "Run"
3. Verifique os resultados dos testes

## 🌿 Estrutura de Branches

O projeto utiliza Git Flow com as seguintes branches:

- **`main`**: Branch de produção (código estável)
- **`staging`**: Branch de homologação/testes
- **`develop`**: Branch de desenvolvimento

### Workflow:

```bash
# Criar branch de desenvolvimento
git checkout -b develop

# Criar feature branch
git checkout -b feature/nova-funcionalidade

# Merge para develop
git checkout develop
git merge feature/nova-funcionalidade

# Merge para staging
git checkout staging
git merge develop

# Merge para main (após testes)
git checkout main
git merge staging
```

## 📝 Variáveis de Ambiente

### Backend

As seguintes variáveis podem ser configuradas no `docker-compose.yml`:

- `PORT`: Porta do servidor (padrão: 3001)
- `DB_HOST`: Host do banco de dados (padrão: postgres)
- `DB_PORT`: Porta do banco (padrão: 5432)
- `DB_NAME`: Nome do banco (padrão: devopsdb)
- `DB_USER`: Usuário do banco (padrão: devopsuser)
- `DB_PASSWORD`: Senha do banco (padrão: devopspass)

### Frontend

- `REACT_APP_API_URL`: URL da API (padrão: http://localhost:3001)

## 🔍 Troubleshooting

### Problemas comuns:

1. **Porta já em uso**: Altere as portas no `docker-compose.yml`
2. **Banco de dados não conecta**: Aguarde alguns segundos para o PostgreSQL inicializar
3. **Frontend não carrega**: Verifique se o backend está rodando na porta 3001
4. **Zabbix não acessa**: Aguarde alguns minutos para inicialização completa

### Logs dos containers:

```bash
# Ver logs de todos os serviços
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f postgres
```

## 📚 Tecnologias Utilizadas

- **Frontend**: React 18, Axios
- **Backend**: Node.js, Express, PostgreSQL
- **Containerização**: Docker, Docker Compose
- **Web Server**: Nginx
- **Monitoramento**: Zabbix 6.4
- **Testes**: Postman

## 👥 Contribuição

Este é um projeto acadêmico desenvolvido para o curso de DevOps.

## 📄 Licença

Este projeto é para fins educacionais.

---

**Desenvolvido para o Projeto Final de DevOps - 2025**


