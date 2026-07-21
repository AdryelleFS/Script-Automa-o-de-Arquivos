# Script-Automação-de-Arquivos
## Objetivo
O objetivo do repositório é armazenar scripts que organizem automaticamente os arquivos recebidos por uma empresa. 

## Autor
Adryelle Fonseca Sousa 

## Data
20/07/2026

## Scripts para automatizar processor de arquivos 

### ProcessarArquivos.ps1

Valida a estrutura: 

├── Entrada

│ ├── clientes.csv

│ ├── funcionarios.csv

│ ├── vendas.csv

│ ├── imagem.png

│ ├── contrato.pdf

│ └── relatorio.docx

Caso não existam, cria as pastas: 

- Processados

- Relatorios

- Backup

- Logs

Gera relatório:

Cria arquivo "Relatorio_Processamento.csv" contendo: 
- Nome do arquivo
  
- Extensão
  
- Data de processamento

- Tamanho
  
- Pasta de destino

Registra execução criando arquivo log.txt, contendo:
-Data e Hora;

- Quantidade de arquivos processados

- Quantidade de arquivos ignorados

- Tempo total de execução

Realiza Backup:
Copiar todos os arquivos processados para uma pasta de backup.
O nome da pasta deverá segue o padrão: Backup_2026-07-05_143000

## Como executar: 

Abrir o PowerShell.

Navegar até a pasta do projeto.

Executar: .\ProcessarArquivos.ps1
