#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
logfile="$SCRIPT_DIR/log/gopro_scan.log"

# ignore list: space-separated entries
# entries may be:
#   - camera:PW      (ignore PW on camera only)
#   - bacpac:AB      (ignore AB on bacpac only)
#   - XY             (ignore XY on both camera and bacpac)
# patterns are allowed (e.g. "P*" or "*W")
# endpoints referenced in docs/API-docs.md
IGNORE_LIST="\
bacpac:PW bacpac:RS bacpac:NO camera:PW camera:SH camera:PV \
camera:LL camera:CM camera:VM camera:VV camera:FV camera:FS \
camera:PR camera:TI camera:CS camera:BU camera:PN camera:LO \
camera:LW camera:EX camera:PT camera:WB camera:EV camera:SP \
camera:GA camera:CO camera:DA camera:DL camera:DF camera:FO \
camera:BS camera:LB camera:DM camera:TM camera:UP camera:PI \
camera:CN camera:VR camera:AO camera:OB bacpac:SH \
\
bacpac:pw bacpac:rs bacpac:no camera:pw camera:sh camera:pv \
camera:ll camera:cm camera:vm camera:vv camera:fv camera:fs \
camera:pr camera:ti camera:cs camera:bu camera:pn camera:lo \
camera:lw camera:ex camera:pt camera:wb camera:ev camera:sp \
camera:ga camera:co camera:da camera:dl camera:df camera:fo \
camera:bs camera:lb camera:dm camera:tm camera:up camera:pi \
camera:cn camera:vr camera:ao camera:ob bacpac:sh \
\
bacpac:sd camera:bl camera:sx bacpac:tc bacpac:bl bacpac:wp \
bacpac:pf bacpac:sn bacpac:cv camera:cv camera:se camera:ai \
camera:bv camera:cc camera:ds camera:oo camera:rv camera:st \
camera:um camera:xs bacpac:ba bacpac:bm bacpac:bo bacpac:cs \
bacpac:lc bacpac:oo bacpac:pp bacpac:pv bacpac:se bacpac:sr \
bacpac:vs bacpac:wi bacpac:ws bacpac:wt \
"



should_ignore() {
    local type="$1" pair="$2"
    local key="${type}:${pair}"
    for e in $IGNORE_LIST; do
        # exact type:pair match or pair-only match
        if [ "$e" = "$key" ] || [ "$e" = "$pair" ]; then
            return 0
        fi
        # glob match against key or pair
        if [[ "$key" == $e ]] || [[ "$pair" == $e ]]; then
            return 0
        fi
    done
    return 1
}

process_endpoint() {
    local pair="$1"
    url="http://10.5.5.9/${type}/${pair}?t=password"
    echo "Scanning ${type} ${pair}: ${url}"

    hdr=$(mktemp)
    body=$(mktemp)

    curl_exit=0
    http_code=$(curl -s -S -w "%{http_code}" -o "$body" "$url") || curl_exit=$?
    size=$(stat -c%s "$body" 2>/dev/null || echo 0)

    # skip empty responses and single-byte responses that are 0x01
    if [ "$size" -eq 0 ]; then
        rm -f "$body" "$hdr"
        return 1
    fi

    if [ "$size" -eq 1 ]; then
        # get hex of first byte (try hexdump, fallback to od)
        byte_hex=$(hexdump -n1 -v -e '/1 "%02x"' "$body" 2>/dev/null || od -An -t x1 -N1 "$body" | tr -d '[:space:]')
        if [ "$byte_hex" = "01" ]; then
            rm -f "$body" "$hdr"
            return 1
        fi
    fi

    # detect binary by presence of NUL byte
    if grep -q $'\x00' "$body" 2>/dev/null; then
        is_binary=1
    else
        is_binary=0
    fi
    {
    echo "----------------------------------------"
    echo "Device: $type"
    echo "Endpoint: $pair"
    echo "URL: $url"
    echo "HTTP: ${http_code:-N/A}"
    echo "Curl exit: $curl_exit"
    echo "Size: ${size} bytes"
    if [ "$is_binary" -eq 1 ]; then
        echo "Body (hex dump):"
        hexdump -C "$body"
    else
        echo "Body:"
        cat "$body"
    fi
    } >> "$logfile"

    rm -f "$body" "$hdr"
}

# ensure log dir exists
mkdir -p "$(dirname "$logfile")"

# test all combinations possible in lowercase for both camera and bacpac
for type in camera bacpac; do
    for a in {a..z}; do
        for b in {a..z}; do
            pair="${a}${b}"
            if should_ignore "$type" "$pair"; then
                echo "Ignoring ${type} ${pair}"
                continue
            fi
            if process_endpoint "$pair"; then
                continue
            fi
        done
    done
done
# test all combinations possible in uppercase for camera and bacpac
for type in camera bacpac; do
    for a in {A..Z}; do
        for b in {A..Z}; do
            pair="${a}${b}"
            if should_ignore "$type" "$pair"; then
                echo "Ignoring ${type} ${pair}"
                continue
            fi
            if process_endpoint "$pair"; then
                continue
            fi
        done
    done
done
