#!/usr/bin/env bash
# Détermine la catégorie (donc le sous-dossier) d'un fichier à partir de son extension.

# $1 : extension en minuscules (ex: "pdf")
# Affiche sur stdout le nom du dossier de destination.
get_category() {
    local ext="$1"

    case "$ext" in
        jpg|jpeg|png|gif|bmp|svg|webp|heic|tif|tiff)
            echo "$DIR_IMAGES" ;;
        pdf|doc|docx|odt|txt|rtf|md|xls|xlsx|ods|csv|ppt|pptx|odp)
            echo "$DIR_DOCUMENTS" ;;
        zip|rar|7z|tar|gz|bz2|xz|tgz)
            echo "$DIR_ARCHIVES" ;;
        mp4|mkv|avi|mov|wmv|flv|webm)
            echo "$DIR_VIDEOS" ;;
        mp3|flac|wav|ogg|m4a|aac)
            echo "$DIR_MUSIQUE" ;;
        deb|rpm|appimage|exe|msi)
            echo "$DIR_INSTALLATEURS" ;;
        epub|mobi|azw3)
            echo "$DIR_EBOOKS" ;;
        *)
            # Extension inconnue ou absence d'extension
            echo "$DIR_DIVERS" ;;
    esac
}

# $1 : nom du fichier (ex: "Rapport.PDF")
# Affiche l'extension en minuscules, ou une chaîne vide s'il n'y en a pas.
get_extension() {
    local name="$1"

    if [[ "$name" == *.* ]]; then
        local ext="${name##*.}"   # Supprime tout jusqu'au dernier point
        printf '%s' "${ext,,}"    # Conversion en minuscules
    else
        printf ''
    fi
}

# $1 : nom du fichier
# Retourne 0 (vrai) si le fichier doit être ignoré.
is_ignored() {
    local name="$1"

    # Fichiers cachés (commencent par un point)
    [[ "$name" == .* ]] && return 0

    # Téléchargements incomplets
    case "$name" in
        *.part|*.crdownload|*.tmp)
            return 0 ;;
    esac

    return 1
}
