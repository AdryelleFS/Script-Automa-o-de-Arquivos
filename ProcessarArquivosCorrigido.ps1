# Tempo inicial
$Inicio = Get-Date

# Caminhos
$PastaBase = "C:\Users\adryelle.sousa\Documents\EstudoGitHub"

$PastaEntrada = "C:\Users\adryelle.sousa\Downloads"
$PastaProcessados = Join-Path $PastaBase "Processados"
$PastaBackup = Join-Path $PastaBase "Backup"
$PastaLogs = Join-Path $PastaBase "Logs"
$PastaRelatorios = Join-Path $PastaBase "Relatorios"

# Criar estrutura caso não exista
$Pastas = @(
    $PastaProcessados,
    $PastaBackup,
    $PastaLogs,
    $PastaRelatorios
)

foreach ($Pasta in $Pastas) {

    if (!(Test-Path $Pasta)) {

        New-Item -Path $Pasta -ItemType Directory -Force | Out-Null
        Write-Host "Pasta criada: $Pasta"

    }
    else {

        Write-Host "Pasta já existe: $Pasta"

    }
}

Write-Host ""
# Contadores
$QntArquivosProcessados = 0
$QntArquivosIgnorados = 0

# Array para gerar relatório
$Relatorio = @()

# Localiza todos os arquivos na pasta de entrada
$Arquivos = Get-ChildItem -Path $PastaEntrada -File

foreach ($Arquivo in $Arquivos) {

    if ($Arquivo.Extension -eq ".csv") {

        Move-Item `
            -Path $Arquivo.FullName `
            -Destination $PastaProcessados

        $QntArquivosProcessados++

        $Relatorio += [PSCustomObject]@{
            NomeArquivo       = $Arquivo.Name
            Extensao          = $Arquivo.Extension
            DataProcessamento = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Tamanho           = $Arquivo.Length
            PastaDestino      = $PastaProcessados
        }

        Write-Host "$($Arquivo.Name) processado"

    }
    else {

        $QntArquivosIgnorados++

        Write-Host "$($Arquivo.Name) ignorado"

    }
}

# Criação do relatório CSV
$CaminhoRelatorio = Join-Path `
    $PastaRelatorios `
    "Relatorio_Processamento.csv"

$Relatorio | Export-Csv `
    -Path $CaminhoRelatorio `
    -NoTypeInformation `
    -Encoding UTF8

# Tempo final
$Fim = Get-Date
$TempoExecucao = ($Fim - $Inicio).TotalSeconds

# Criação do Log
$LogPath = Join-Path $PastaLogs "log.txt"

@"
Data: $(Get-Date -Format 'dd/MM/yyyy')
Hora: $(Get-Date -Format 'HH:mm:ss')
Arquivos processados: $QntArquivosProcessados
Arquivos ignorados: $QntArquivosIgnorados
Tempo total da execução: $TempoExecucao segundos
"@ | Out-File -FilePath $LogPath -Encoding UTF8

# Backup dos arquivos processados
$DataHora = Get-Date -Format "yyyy-MM-dd_HHmmss"

$PastaBackupExecucao = Join-Path `
    $PastaBackup `
    "Backup_$DataHora"

New-Item `
    -Path $PastaBackupExecucao `
    -ItemType Directory `
    -Force | Out-Null

Get-ChildItem "$PastaProcessados\*.csv" |
    Copy-Item -Destination $PastaBackupExecucao

# Resumo final

Write-Host ""
Write-Host "PROCESSAMENTO FINALIZADO"
Write-Host ""
Write-Host "Arquivos processados: $QntArquivosProcessados"
Write-Host "Arquivos ignorados: $QntArquivosIgnorados"
Write-Host "Tempo de execução: $TempoExecucao segundos"
Write-Host ""
Write-Host "Backup realizado com sucesso"
Write-Host ""