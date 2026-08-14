#!/usr/bin/env bash
# ==============================================================================
# BASH NA PISTA - https://github.com/criativotech/bash-na-pista
# Script: 10-comandos-criativos.sh
# Descrição: Exemplos práticos dos 10 comandos Bash para criadores visuais (Vídeo #02)
# ==============================================================================

# Cores para output no terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  /===========================================\\"
echo "  |      BASH NA PISTA - CLI FOR DESIGNERS     |"
echo "  |       10 Comandos Essenciais de Mídia     |"
echo "  \\===========================================/"
echo -e "${NC}"

echo -e "${YELLOW}Exemplos de uso rápido:${NC}\n"

echo -e "${GREEN}1. Redimensionar imagem em lote (ImageMagick):${NC}"
echo "   magick imagem.jpg -resize 1920x1920\> imagem_1920.jpg"
echo ""

echo -e "${GREEN}2. Extrair frame de vídeo em alta resolução (FFmpeg):${NC}"
echo "   ffmpeg -ss 00:01:25 -i video.mp4 -vframes 1 -q:v 2 frame.png"
echo ""

echo -e "${GREEN}3. Extrair apenas o áudio de um vídeo (FFmpeg):${NC}"
echo "   ffmpeg -i video.mp4 -vn -c:a libmp3lame -q:a 2 audio.mp3"
echo ""

echo -e "${GREEN}4. Comprimir PNGs sem perda de qualidade:${NC}"
echo "   optipng -o2 *.png"
echo ""

echo -e "${GREEN}5. Encontrar todos os arquivos SVG em subpastas:${NC}"
echo "   find . -type f -name \"*.svg\""
echo ""

echo -e "${GREEN}6. Converter páginas de PDF para imagens PNG:${NC}"
echo "   pdftoppm -png -r 300 documento.pdf pagina"
echo ""

echo -e "${GREEN}7. Limpar metadados de privacidade de uma foto:${NC}"
echo "   exiftool -all= foto.jpg"
echo ""

echo -e "${GREEN}8. Baixar vídeo/áudio de referência (yt-dlp):${NC}"
echo "   yt-dlp -f \"bestvideo[height<=1080]+bestaudio/best\" \"URL\""
echo ""

echo -e "${GREEN}9. Copiar código de cor HEX para a área de transferência:${NC}"
echo "   echo \"#00FF44\" | wl-copy   # Wayland"
echo "   echo \"#00FF44\" | xclip -selection clipboard   # X11"
echo ""

echo -e "${GREEN}10. Automação completa de Marca d'Água do canal:${NC}"
echo "   ./scripts/img-watermark.sh -i ~/Fotos -w ./templates/marca.png"
echo ""
