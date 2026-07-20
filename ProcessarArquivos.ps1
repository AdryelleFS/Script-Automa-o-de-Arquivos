# Lista de pastas a serem verificadas
$pastas = @(
    "Processados",
    "Backup",
    "Logs",
    "Relatorio"
)

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

$arquivos = Get-ChildItem -Path "C:\Users\adryelle.sousa\Downloads\*.csv"

foreach ($arquivo in $arquivos) { 

    Move-Item -Path $arquivo.FullName -Destination "C:\Users\adryelle.sousa\Processados"
    Write-Host "$($arquivo.Name) movido."
}

function CriaArquivo {
    param (
        [string]$NomeArquivo,
        [string]$PastaDestino,   
        [int]$Tamanho
    )
    New-Item -Path "Relatorio_Processamento.csv" -ItemType File
}
