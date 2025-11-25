# Guia de Configuração do Git

Este guia explica como configurar o controle de versão Git para o projeto.

## 1. Inicializar o Repositório

```bash
cd projeto-devops
git init
```

## 2. Criar as Branches

```bash
# Criar branch develop
git checkout -b develop

# Criar branch staging
git checkout -b staging

# Voltar para main
git checkout -b main
```

## 3. Fazer o Primeiro Commit

```bash
# Adicionar todos os arquivos
git add .

# Fazer commit inicial
git commit -m "Initial commit: Projeto DevOps completo"

# Definir main como branch padrão
git branch -M main
```

## 4. Conectar ao GitHub

```bash
# Adicionar remote (substitua <seu-usuario> e <seu-repositorio>)
git remote add origin https://github.com/<seu-usuario>/<seu-repositorio>.git

# Enviar todas as branches para o GitHub
git push -u origin main
git push -u origin develop
git push -u origin staging
```

## 5. Workflow de Desenvolvimento

### Criar uma nova feature:

```bash
# Mudar para develop
git checkout develop

# Criar branch da feature
git checkout -b feature/nome-da-feature

# Fazer alterações e commits
git add .
git commit -m "Descrição da feature"

# Voltar para develop e fazer merge
git checkout develop
git merge feature/nome-da-feature

# Enviar para o GitHub
git push origin develop
```

### Enviar para staging:

```bash
# Mudar para staging
git checkout staging

# Fazer merge de develop
git merge develop

# Enviar para o GitHub
git push origin staging
```

### Enviar para produção:

```bash
# Mudar para main
git checkout main

# Fazer merge de staging
git merge staging

# Enviar para o GitHub
git push origin main
```

## 6. Verificar Branches

```bash
# Ver todas as branches locais
git branch

# Ver todas as branches (incluindo remotas)
git branch -a

# Ver status atual
git status
```

## Estrutura de Branches

- **main**: Código de produção (estável)
- **staging**: Código de homologação/testes
- **develop**: Código de desenvolvimento ativo


