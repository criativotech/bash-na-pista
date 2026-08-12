#!/usr/bin/env bash
# ==============================================================================
# BASH NA PISTA - https://github.com/criativotech/bash-na-pista
# Script: img-watermark.sh
# Descrição: Processa imagens em lote, redimensiona para tamanho padrão web/social
#            e aplica marca d'água com transparência.
# Uso: ./img-watermark.sh -i <diretorio_entrada> -w <marca_dagua.png> [-o <diretorio_saida>]
# ==============================================================================

set -euo pipefail

# Cores para output no terminal (compatível com visual Neon/Terminal)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Mensagem de Banner
echo -e "${CYAN}"
echo "  /===========================================\\"
echo "  |      BASH NA PISTA - AUTOMATION CLI       |"
echo "  |    Batch Image Resizer & Watermarker      |"
echo "  \\===========================================/"
echo -e "${NC}"

# Função de Ajuda
usage() {
    echo -e "${YELLOW}Uso:${NC} $0 -i <diretorio_entrada> -w <marca_dagua.png> [-o <diretorio_saida>]"
    echo ""
    echo "Opções:"
    echo "  -i  Diretório contendo as imagens originais (JPG, PNG, WEBP)"
    echo "  -w  Caminho da imagem de marca d'água (PNG com transparência)"
    echo "  -o  Diretório de saída (Padrão: ./output_bash_na_pista)"
    echo "  -h  Exibe esta ajuda"
    exit 1
}

# Verificar dependência do ImageMagick (magick / convert)
if command -v magick &> /dev/null; then
    CMD="magick"
elif command -v convert &> /dev/null; then
    CMD="convert"
else
    echo -e "${RED}[ERRO] ImageMagick não encontrado! Instale com: sudo zypper in ImageMagick (ou no seu gerenciador)${NC}"
    exit 1
fi

INPUT_DIR=""
WATERMARK=""
OUTPUT_DIR="./output_bash_na_pista"

# Parse dos argumentos
while getopts "i:w:o:h" opt; do
    case ${opt} in
        i) INPUT_DIR="${OPTARG}" ;;
        w) WATERMARK="${OPTARG}" ;;
        o) OUTPUT_DIR="${OPTARG}" ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -z "${INPUT_DIR}" || -z "${WATERMARK}" ]]; then
    echo -e "${RED}[ERRO] Os parâmetros -i (entrada) e -w (marca d'água) são obrigatórios.${NC}\n"
    usage
fi

if [[ ! -d "${INPUT_DIR}" ]]; then
    echo -e "${RED}[ERRO] O diretório de entrada '${INPUT_DIR}' não existe.${NC}"
    exit 1
fi

if [[ ! -f "${WATERMARK}" ]]; then
    echo -e "${RED}[ERRO] O arquivo de marca d'água '${WATERMARK}' não foi encontrado.${NC}"
    exit 1
fi

# Criar pasta de saída se não existir
mkdir -p "${OUTPUT_DIR}"

echo -e "${GREEN}[+] Iniciando processamento de imagens...${NC}"
echo -e "    Entrada: ${CYAN}${INPUT_DIR}${NC}"
echo -e "    Marca d'água: ${CYAN}${WATERMARK}${NC}"
echo -e "    Saída: ${CYAN}${OUTPUT_DIR}${NC}\n"

COUNT=0

# Loop por formatos suportados
shopt -s nullglob
files=("${INPUT_DIR}"/*.{jpg,JPG,jpeg,JPEG,png,PNG,webp,WEBP})

if [[ ${#files[@]} -eq 0 ]]; then
    echo -e "${YELLOW}[!] Nenhuma imagem encontrada no diretório informado.${NC}"
    exit 0
fi

for img in "${files[@]}"; do
    filename=$(basename -- "${img}")
    filename_no_ext="${filename%.*}"
    out_file="${OUTPUT_DIR}/${filename_no_ext}_pista.png"

    echo -e " Processing: ${YELLOW}${filename}${NC} -> ${CYAN}$(basename "${out_file}")${NC}"

    # Executa redimensionamento max 1920x1080 + composição da marca d'água no canto inferior direito
    if [ "$CMD" = "magick" ]; then
        magick "${img}" -resize 1920x1080\> \
               \( "${WATERMARK}" -resize 200x200 \) \
               -gravity SouthEast -geometry +20+20 -composite "${out_file}"
    else
        convert "${img}" -resize 1920x1080\> \
                \( "${WATERMARK}" -resize 200x200 \) \
                -gravity SouthEast -geometry +20+20 -composite "${out_file}"
    fi

    COUNT=$((COUNT + 1))
done

echo -e "\n${GREEN}[✓] Concluído! ${COUNT} imagens processadas com sucesso em ${OUTPUT_DIR}.${NC}"
