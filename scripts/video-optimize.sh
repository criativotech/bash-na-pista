#!/usr/bin/env bash
# ==============================================================================
# BASH NA PISTA - https://github.com/criativotech/bash-na-pista
# Script: video-optimize.sh
# Descrição: Otimiza e converte vídeos em lote via FFmpeg para web/edição.
# Uso: ./video-optimize.sh -i <diretorio_entrada> [-o <diretorio_saida>] [-f <fps>]
# ==============================================================================

set -euo pipefail

# Cores para o terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  /===========================================\\"
echo "  |      BASH NA PISTA - AUTOMATION CLI       |"
echo "  |     Batch Video Optimizer (FFmpeg)        |"
echo "  \\===========================================/"
echo -e "${NC}"

usage() {
    echo -e "${YELLOW}Uso:${NC} $0 -i <diretorio_entrada> [-o <diretorio_saida>] [-f <fps>]"
    echo ""
    echo "Opções:"
    echo "  -i  Diretório com vídeos brutos (MP4, MKV, MOV, AVI)"
    echo "  -o  Diretório de saída (Padrão: ./output_videos)"
    echo "  -f  Taxa de quadros / FPS desejado (Padrão: 60)"
    echo "  -h  Exibe esta ajuda"
    exit 1
}

# Verificar se FFmpeg está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}[ERRO] FFmpeg não encontrado! Instale com: sudo zypper in ffmpeg (ou equivalente)${NC}"
    exit 1
fi

INPUT_DIR=""
OUTPUT_DIR="./output_videos"
FPS="60"

while getopts "i:o:f:h" opt; do
    case ${opt} in
        i) INPUT_DIR="${OPTARG}" ;;
        o) OUTPUT_DIR="${OPTARG}" ;;
        f) FPS="${OPTARG}" ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -z "${INPUT_DIR}" ]]; then
    echo -e "${RED}[ERRO] O parâmetro -i (diretório de entrada) é obrigatório.${NC}\n"
    usage
fi

if [[ ! -d "${INPUT_DIR}" ]]; then
    echo -e "${RED}[ERRO] Diretório de entrada '${INPUT_DIR}' não existe.${NC}"
    exit 1
fi

mkdir -p "${OUTPUT_DIR}"

echo -e "${GREEN}[+] Otimizando vídeos...${NC}"
echo -e "    Entrada: ${CYAN}${INPUT_DIR}${NC}"
echo -e "    Saída: ${CYAN}${OUTPUT_DIR}${NC}"
echo -e "    Target FPS: ${CYAN}${FPS}${NC}\n"

shopt -s nullglob
files=("${INPUT_DIR}"/*.{mp4,MP4,mkv,MKV,mov,MOV,avi,AVI})

if [[ ${#files[@]} -eq 0 ]]; then
    echo -e "${YELLOW}[!] Nenhum vídeo encontrado na pasta informada.${NC}"
    exit 0
fi

COUNT=0

for vid in "${files[@]}"; do
    filename=$(basename -- "${vid}")
    filename_no_ext="${filename%.*}"
    out_file="${OUTPUT_DIR}/${filename_no_ext}_opt.mp4"

    echo -e " Processing: ${YELLOW}${filename}${NC} -> ${CYAN}$(basename "${out_file}")${NC}"

    # Compressão H.264 inteligente (CRF 22), áudio AAC 192k e FPS ajustado
    ffmpeg -y -i "${vid}" \
           -r "${FPS}" \
           -c:v libx264 -crf 22 -preset medium \
           -c:a aac -b:a 192k \
           -pix_fmt yuv420p \
           "${out_file}" -loglevel error

    COUNT=$((COUNT + 1))
done

echo -e "\n${GREEN}[✓] Concluído! ${COUNT} vídeos otimizados com sucesso em ${OUTPUT_DIR}.${NC}"
