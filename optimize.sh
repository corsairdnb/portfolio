#!/bin/bash

# Скрипт написан с помощью Gemini
# Конвертирует исходный JPEG с оптимизацией

# Проверка наличия всех необходимых параметров
if [ "$#" -ne 4 ]; then
    echo "Использование: $0 <исходный_файл.jpg> <процент_размера> <качество_jpeg> <качество_webp>"
    echo "Пример: $0 photo.jpg 50 85 75"
    echo "  (Уменьшит размер до 50% от оригинала, JPEG Q=85, WebP Q=75)"
    exit 1
fi

# 1. Считывание параметров
INPUT_FILE="$1"          # Исходный файл (например, photo.jpg)
RESIZE_PERCENT="$2"      # Процент изменения размера (например, 50)
QUALITY_JPEG="$3"        # Качество для JPEG (например, 85)
QUALITY_WEBP="$4"        # Качество для WebP (например, 75)

# Проверка, существует ли исходный файл
if [ ! -f "$INPUT_FILE" ]; then
    echo "Ошибка: Файл '$INPUT_FILE' не найден."
    exit 1
fi

# Установка базового имени для выходных файлов
# Убираем расширение (.jpg) из исходного имени
BASE_NAME=$(basename "$INPUT_FILE" .jpg)
OUTPUT_BASE="${BASE_NAME}_${RESIZE_PERCENT}pc"

echo "Начало обработки файла: $INPUT_FILE"
echo "Изменение размера: $RESIZE_PERCENT%"

# -------------------------------------------------------------
# --- 1. Создание оптимизированного JPEG
# -------------------------------------------------------------
OUTPUT_JPEG="${OUTPUT_BASE}_q${QUALITY_JPEG}.jpg"
echo "Создание JPEG: $OUTPUT_JPEG (Качество: $QUALITY_JPEG)"
magick "$INPUT_FILE" -resize "${RESIZE_PERCENT}%" -quality "$QUALITY_JPEG" "$OUTPUT_JPEG"

# -------------------------------------------------------------
# --- 2. Создание оптимизированного WebP
# -------------------------------------------------------------
TEMP_PNG="temp_${BASE_NAME}_resized.png"
OUTPUT_WEBP="${OUTPUT_BASE}_q${QUALITY_WEBP}.webp"

# Создаем временный PNG с измененным размером для лучшего WebP сжатия
echo "Создание временного PNG для конвертации в WebP..."
magick "$INPUT_FILE" -resize "${RESIZE_PERCENT}%" "$TEMP_PNG"

# Конвертируем временный PNG в WebP
echo "Создание WebP: $OUTPUT_WEBP (Качество: $QUALITY_WEBP)"
cwebp -q "$QUALITY_WEBP" "$TEMP_PNG" -o "$OUTPUT_WEBP"

# Удаление временного файла
rm "$TEMP_PNG"

echo "✨ Готово! Созданы файлы:"
echo "  - $OUTPUT_JPEG"
echo "  - $OUTPUT_WEBP"