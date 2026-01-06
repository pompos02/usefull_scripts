#!/bin/bash
set -Eeuo pipefail

source "windows_notifications.sh"
DOWNLOADS="/mnt/c/Users/yiann/Downloads/"
# check if the directory if valid
cd "$DOWNLOADS" || exit 22

# mcount the number of elements is the Downloads directroy excluding the destination dirs
ELEMENTS_COUNT=$(find . -mindepth 1 -maxdepth 1 \
  ! -name Images ! -name Documents ! -name Archives \
  ! -name Installers ! -name Others ! -name Folders | wc -l)

: $((counter=0))
# Ensure the needed directories are there
mkdir -p Images Documents Archives Installers Others Folders

blue() { echo -e "\033[1;34m$1\033[0m"; }
green() { echo -e "\033[1;32m$1\033[0m"; }
yellow() { echo -e "\033[1;33m$1\033[0m"; }
red() { echo -e "\033[1;31m$1\033[0m"; }

start=$(date +%s.%N)
declare -A mcount=(
  [images]=0
  [documents]=0
  [archives]=0
  [installers]=0
  [others]=0
  [folders]=0
  [skipped]=0
)

for item in *; do
    : $((counter++))
    if [[ -f "$item" ]]; then

        # get the extension
        extension="${item##*.}"
        # get it in lowercase
        extension="${extension,,}"

        case "$extension" in
            png|jpg|jpeg|gif|svg|webp)
                destination="Images"
                : $((mcount[images]++))
                ;;
            pdf|txt|docx|md)
                destination="Documents"
                : $((mcount[documents]++))
                ;;
            zip|tar|gz|7z)
                destination="Archives"
                : $((mcount[archives]++))
                ;;
            deb|exe|sh|msi)
                destination="Installers"
                : $((mcount[installers]++))
                ;;
            *)
                destination="Others"
                : $((mcount[others]++))
                ;;
        esac
        echo "$(green ["$counter"/"$ELEMENTS_COUNT"]) moving $(blue "$item") -> $(yellow "$destination/")"
        mv "$item" "$destination"
    elif  [[ -d "$item" ]]; then
        case "$item" in
            Images|Documents|Archives|Installers|Others|Folders)
                ((counter--))
                continue;
                ;;
        *)
            destination="Folders"
            : $((mcount[folders]++))
            echo "$(yellow ["$counter"/"$ELEMENTS_COUNT"]) moving $(blue "$item") -> $(yellow "$destination/")"
            mv "$item" "$destination"
            ;;
        esac
    else
        echo "$(red ["$counter"/"$ELEMENTS_COUNT"]) ""Unknown extension/type for element '$item'"
    fi
done
end=$(date +%s.%N)
# execution_time=$(echo "$end - $start" | bc)
execution_time=$(awk "BEGIN {printf \"%.3f\", $end - $start}")

printf "\n%s %s\n\n" "$(green "Downloads organized sucessfully!")" "in $(yellow "$execution_time"s)"
for key in $(printf '%s\n' "${!mcount[@]}" | sort); do
    key_length=${#key}
    padding=$((14 - key_length))
    printf "%s%*s %s\n" "$(blue "$key")" "$padding" "" "$(green "${mcount[$key]}")"
done
wNotification2 "Downloads Cleanup Completed" "$counter"
