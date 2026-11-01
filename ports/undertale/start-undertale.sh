```sh
#!/bin/sh

PORT_DIR="/home/player/ports/undertale"
DEBUG_LOG="/home/player/undertale-launcher-debug.log"

exec >> "$DEBUG_LOG" 2>&1

echo "===== UNDERTALE DEBUG ====="
date
echo "HOME=$HOME"
uname -a

echo "===== DOSYA KONTROLÜ ====="
for p in "$PORT_DIR" "$PORT_DIR/butterscotch" "$PORT_DIR/data.win"; do
    [ -e "$p" ] && ls -ld "$p" || echo "EKSIK: $p"
done

[ -d "$PORT_DIR" ] || exit 90
cd "$PORT_DIR" || exit 90

[ -f "$PORT_DIR/data.win" ] || exit 92
[ -f "$PORT_DIR/butterscotch" ] || exit 91

chmod +x "$PORT_DIR/butterscotch"

# Save klasörünü oluştur; kayıtlar SD kartta kalır.
mkdir -p "$PORT_DIR/saves"

export SDL_VIDEODRIVER=kmsdrm

echo "===== KAYIT KONUMU ====="
echo "$PORT_DIR/saves"

echo "===== BUTTERSCOTCH BAŞLIYOR ====="
"$PORT_DIR/butterscotch" \
    --lazy-rooms \
    --lazy-textures \
    --disable-log-colours \
    --save-folder "$PORT_DIR/saves" \
    "$PORT_DIR/data.win"

RESULT=$?
echo "===== EXIT CODE: $RESULT ====="
exit "$RESULT"
```
