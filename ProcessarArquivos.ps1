# Lista de pastas a serem verificadas
$pastas = @(
    "Processados",
    "Backup",
    "Logs",
    "Relatorio"
)

#Cria as pastas, caso elas ainda não existam 

foreach ($pasta in $pastas) {
    if (Test-Path $pasta) {
        Write-Host "A pasta '$pasta' existe."
    }
    else {
        Write-Host "A pasta '$pasta' não existe."
        foreach ($pasta in $pastas) {
            New-Item -Path $pasta -ItemType Directory
            Write-Host "Pasta '$pasta' criada com sucesso."
        }
    }
}

# Move os arquivos .csv para a pasta Processados  

$arquivos = Get-ChildItem -Path "C:\Users\adryelle.sousa\Downloads\*.csv"

foreach ($arquivo in $arquivos) { 

    Move-Item -Path $arquivo.FullName -Destination "C:\Users\adryelle.sousa\Documents\EstudoGitHub\Processados"
    Write-Host "$($arquivo.Name) movido para a pasta de Processados."
}

# Contabiliza quantos arquivos foram processados, ignorados e o tempo de execução 

$ArquivosProcessados = 0
$ArquivosIgnorados = 0

$Inicio = Get-Date

foreach ($Arquivo in $Arquivos) {

    if ($Arquivo.Length -gt 0) {
        $ArquivosProcessados++
    }
    else {
        $ArquivosIgnorados++
    }
}


# função que cria o arquivo Relatorio_Processamento.csv e o arquivo log.txt
function CriaArquivo{
    param (
        [string]$NomeArquivo,
        [string]$PastaDestino,   
        [int]$Tamanho,
        [int]$QntArquivosProcessados = 0,
        [int]$QntArquivosIgnorados = 0,
        [single]$TempoTotalExecucao
        [string]$Extensao
    )
    Get-Command CriaArquiv**

    $DataProcessamento = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    
    $Conteudo = @"
Nome do Arquivo: $NomeArquivo
Extensão: $Extensao
Data de Processamento: $DataProcessamento
Tamanho: $Tamanho
Pasta de Destino: $PastaDestino
Arquivos Processados: $ArquivosProcessados
Arquivos Ignorados: $ArquivosIgnorados
Tempo de Execução: $TempoExecucao
"@
    $ArquivoRelatorio = Join-Path $PastaDestino "$NomeArquivo"
    Set-Content -Path $ArquivoRelatorio -Value $Conteudo
    Write-Host "$NomeArquivo criado"
}

$Fim = Get-Date
$TempoExecucao = ($Fim - $Inicio).TotalSeconds

# Chamado da funções que cria o arquivo q Relatorio_Processamento.csv

CriaArquivo `
    -NomeArquivo "Relatorio_Processamento.csv" `
    -Extensao ".csv" `
    -PastaDestino "C:\Users\adryelle.sousa\Documents\EstudoGitHub\Relatorio" `
    -Tamanho "150"

# Chamado da função que cria um arquivo log.txt

CriaArquivo `
    -NomeArquivo "log.txt" `
    -Extensao ".txt" `
    -PastaDestino "C:\Users\adryelle.sousa\Documents\EstudoGitHub\Logs" `
    -Tamanho "150" `
    -QntArquivosProcessados $ArquivosProcessados `
    -QntArquivosIgnorados $ArquivosIgnorados `
    -TempoTotalExecucao $TempoExecucao

#Backup de arquivos processados 

$ArquivosProcessados = Get-ChildItem "C:\Users\adryelle.sousa\Documents\EstudoGitHub\Processados\*.csv"

foreach ($Arquivo in $ArquivosProcessados) {

    if ($Arquivo.Length -gt 0) {
        $QntArquivosProcessados++
    }
    else {
        $QntArquivosIgnorados++
    }
}

$DataHora = Get-Date -Format "yyyy-MM-dd_HHmmss"
$PastaBackup = "C:\Users\adryelle.sousa\Documents\EstudoGitHub\Backup\Backup_$DataHora"
New-Item -Path $PastaBackup -ItemType Directory -Force

foreach ($arquivo in $ArquivosProcessados) {
    Copy-Item -Path $arquivo.FullName -Destination $PastaBackup
}

Write-Host "PROCESSAMENTO FINALIZADO"
Write-Host "Arquivos processados: $QntArquivosProcessados"
Write-Host "Arquivos Ignorados: $QntArquivosIgnorados"
Write-Host "Tempo de execução: $TempoExecucao"
Write-Host "Backup realizado com sucesso"
