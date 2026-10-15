#!/usr/bin/env bash
# Logique principale : parcourir le dossier source et déplacer les fichiers.

# $1 : dossier source    $2 : dossier racine de destination
organize_directory() {
    local src="$1"
    local root="$2"
    local file name ext category target_dir dest
    local moved=0 skipped=0 errors=0

    # find -print0 sépare les chemins par un caractère nul : c'est le seul
    # séparateur qui ne peut pas apparaître dans un nom de fichier, donc les
    # espaces, accents et parenthèses ne posent aucun problème.
    # -maxdepth 1 : on ne regarde pas dans les sous-dossiers existants.
    while IFS= read -r -d '' file; do
        name="$(basename -- "$file")"

        if is_ignored "$name"; then
            debug "Ignoré : $name"
            skipped=$((skipped + 1))
            continue
        fi

        ext="$(get_extension "$name")"
        category="$(get_category "$ext")"
        target_dir="$root/$category"
        dest="$(unique_destination "$target_dir" "$name")"

        if move_file "$file" "$dest"; then
            moved=$((moved + 1))
        else
            errors=$((errors + 1))
        fi
    done < <(find "$src" -mindepth 1 -maxdepth 1 -type f -print0)

    log "Terminé : $moved déplacé(s), $skipped ignoré(s), $errors erreur(s)."
}

# Calcule un chemin de destination qui n'écrase rien :
# "photo.png" devient "photo (1).png" si le nom est déjà pris.
# $1 : dossier de destination    $2 : nom du fichier
unique_destination() {
    local dir="$1"
    local name="$2"
    local base="${name%.*}"
    local ext=""
    local candidate="$dir/$name"
    local counter=1

    if [[ "$name" == *.* ]]; then
        ext=".${name##*.}"
    fi

    while [[ -e "$candidate" ]]; do
        candidate="$dir/${base} ($counter)${ext}"
        counter=$((counter + 1))
    done

    printf '%s' "$candidate"
}

# $1 : fichier source    $2 : destination complète
move_file() {
    local src="$1"
    local dest="$2"
    local rel_dest="${dest#"$DEST_ROOT"/}"

    if [[ "$DRY_RUN" == true ]]; then
        log "[simulation] $(basename -- "$src") -> $rel_dest"
        return 0
    fi

    mkdir -p -- "$(dirname -- "$dest")"

    if ! mv -- "$src" "$dest"; then
        warn "Échec du déplacement de : $src"
        return 1
    fi

    log "$(basename -- "$src") -> $rel_dest"
}
