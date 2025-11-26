# Script de Diagnóstico do Docker
# Este script ajuda a identificar problemas com Docker e Docker Compose

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Diagnóstico do Docker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$erroEncontrado = $false

# 1. Verificar se Docker está instalado
Write-Host "[1/5] Verificando instalação do Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker instalado: $dockerVersion" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Docker não encontrado!" -ForegroundColor Red
        Write-Host "   → Instale o Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
        $erroEncontrado = $true
    }
} catch {
    Write-Host "   ✗ Docker não encontrado!" -ForegroundColor Red
    $erroEncontrado = $true
}

# 2. Verificar se Docker Compose está instalado
Write-Host ""
Write-Host "[2/5] Verificando Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker Compose instalado: $composeVersion" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Docker Compose não encontrado!" -ForegroundColor Red
        $erroEncontrado = $true
    }
} catch {
    Write-Host "   ✗ Docker Compose não encontrado!" -ForegroundColor Red
    $erroEncontrado = $true
}

# 3. Verificar se Docker Desktop está rodando
Write-Host ""
Write-Host "[3/5] Verificando se Docker Desktop está rodando..." -ForegroundColor Yellow
try {
    $dockerInfo = docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker Desktop está RODANDO!" -ForegroundColor Green
        
        # Extrair informações úteis
        $serverVersion = ($dockerInfo | Select-String "Server Version:").ToString()
        if ($serverVersion) {
            Write-Host "   $serverVersion" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ✗ Docker Desktop NÃO está rodando!" -ForegroundColor Red
        Write-Host ""
        Write-Host "   🔴 CAUSA DO ERRO IDENTIFICADA!" -ForegroundColor Red
        Write-Host ""
        Write-Host "   SOLUÇÃO:" -ForegroundColor Yellow
        Write-Host "   1. Abra o Docker Desktop no Windows" -ForegroundColor White
        Write-Host "   2. Aguarde até o ícone na bandeja ficar VERDE" -ForegroundColor White
        Write-Host "   3. Execute este script novamente" -ForegroundColor White
        Write-Host ""
        Write-Host "   Para abrir o Docker Desktop:" -ForegroundColor Cyan
        Write-Host "   - Menu Iniciar > Docker Desktop" -ForegroundColor White
        Write-Host "   - Ou execute: Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'" -ForegroundColor White
        $erroEncontrado = $true
    }
} catch {
    Write-Host "   ✗ Erro ao verificar Docker daemon!" -ForegroundColor Red
    Write-Host "   → Docker Desktop provavelmente não está rodando" -ForegroundColor Yellow
    $erroEncontrado = $true
}

# 4. Verificar se está no diretório correto
Write-Host ""
Write-Host "[4/5] Verificando diretório do projeto..." -ForegroundColor Yellow
if (Test-Path "docker-compose.yml") {
    Write-Host "   ✓ docker-compose.yml encontrado" -ForegroundColor Green
} else {
    Write-Host "   ⚠ docker-compose.yml não encontrado no diretório atual" -ForegroundColor Yellow
    Write-Host "   → Certifique-se de estar em: projeto-devops/" -ForegroundColor White
}

# 5. Verificar arquivos necessários
Write-Host ""
Write-Host "[5/5] Verificando arquivos do projeto..." -ForegroundColor Yellow
$arquivos = @("backend/Dockerfile", "frontend/Dockerfile", "backend/package.json", "frontend/package.json")
$todosOk = $true
foreach ($arquivo in $arquivos) {
    if (Test-Path $arquivo) {
        Write-Host "   ✓ $arquivo" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $arquivo não encontrado" -ForegroundColor Red
        $todosOk = $false
    }
}

# Resumo
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
if ($erroEncontrado) {
    Write-Host "  ❌ PROBLEMAS ENCONTRADOS" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "AÇÃO NECESSÁRIA:" -ForegroundColor Yellow
    Write-Host "1. Inicie o Docker Desktop" -ForegroundColor White
    Write-Host "2. Aguarde até ficar verde na bandeja" -ForegroundColor White
    Write-Host "3. Execute: docker-compose up -d --build" -ForegroundColor White
} else {
    Write-Host "  ✓ TUDO PRONTO!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Você pode executar:" -ForegroundColor Yellow
    Write-Host "  docker-compose up -d --build" -ForegroundColor White
}
Write-Host ""

