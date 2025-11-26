# Script de Verificação do Docker
# Execute este script no PowerShell para verificar se o Docker está funcionando

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verificação do Docker Desktop" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se o Docker está instalado
Write-Host "1. Verificando instalação do Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker instalado: $dockerVersion" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Docker não encontrado!" -ForegroundColor Red
        Write-Host "   Por favor, instale o Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "   ✗ Docker não encontrado!" -ForegroundColor Red
    Write-Host "   Por favor, instale o Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Verificar se o Docker Compose está instalado
Write-Host ""
Write-Host "2. Verificando Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker Compose instalado: $composeVersion" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Docker Compose não encontrado!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "   ✗ Docker Compose não encontrado!" -ForegroundColor Red
    exit 1
}

# Verificar se o Docker daemon está rodando
Write-Host ""
Write-Host "3. Verificando se o Docker Desktop está rodando..." -ForegroundColor Yellow
try {
    $dockerInfo = docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker Desktop está rodando!" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Docker Desktop NÃO está rodando!" -ForegroundColor Red
        Write-Host ""
        Write-Host "   SOLUÇÃO:" -ForegroundColor Yellow
        Write-Host "   1. Abra o Docker Desktop no Windows" -ForegroundColor White
        Write-Host "   2. Aguarde até o ícone na bandeja do sistema ficar verde" -ForegroundColor White
        Write-Host "   3. Execute este script novamente" -ForegroundColor White
        Write-Host ""
        Write-Host "   Para abrir o Docker Desktop:" -ForegroundColor Cyan
        Write-Host "   - Procure por 'Docker Desktop' no menu Iniciar" -ForegroundColor White
        Write-Host "   - Ou execute: Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'" -ForegroundColor White
        exit 1
    }
} catch {
    Write-Host "   ✗ Erro ao verificar Docker daemon!" -ForegroundColor Red
    Write-Host "   Por favor, inicie o Docker Desktop" -ForegroundColor Yellow
    exit 1
}

# Verificar containers rodando
Write-Host ""
Write-Host "4. Verificando containers..." -ForegroundColor Yellow
try {
    $containers = docker ps -a 2>&1
    if ($LASTEXITCODE -eq 0) {
        $containerCount = (docker ps -q 2>&1 | Measure-Object).Count
        Write-Host "   ✓ Containers encontrados: $containerCount rodando" -ForegroundColor Green
    }
} catch {
    Write-Host "   ⚠ Não foi possível listar containers" -ForegroundColor Yellow
}

# Verificar imagens
Write-Host ""
Write-Host "5. Verificando imagens Docker..." -ForegroundColor Yellow
try {
    $images = docker images 2>&1
    if ($LASTEXITCODE -eq 0) {
        $imageCount = (docker images -q 2>&1 | Measure-Object).Count
        Write-Host "   ✓ Imagens encontradas: $imageCount" -ForegroundColor Green
    }
} catch {
    Write-Host "   ⚠ Não foi possível listar imagens" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✓ Docker está pronto para uso!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Agora você pode executar:" -ForegroundColor Yellow
Write-Host "  docker-compose up -d" -ForegroundColor White
Write-Host ""

