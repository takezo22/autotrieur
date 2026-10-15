#!/usr/bin/env bash
#
# Auto-Organizer : range les fichiers d'un dossier dans des sous-dossiers
# selon leur extension.
#
# Usage : ./auto-organizer.sh [options]
#   -s, --source DIR   dossier à nettoyer (défaut : Téléchargements)
#   -d, --dest DIR     dossier qui contiendra Images, Documents... (défaut : $HOME)
#   -n, --dry-run      simulation : n'effectue aucun déplacement
#   -v, --verbose      affiche davantage de détails
#   -h, --help         affiche l'aide

set -euo pipefail

# Chemin absolu du dossier contenant ce script,
# pour charger les modules quel que soit le répertoire courant.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/config.sh
source "$SCRIPT_DIR/lib/config.sh"
# shellcheck source=lib/utils.sh
source "$SCRIPT_DIR/lib/utils.sh"
# shellcheck source=lib/classify.sh
source "$SCRIPT_DIR/lib/classify.sh"
# shellcheck source=lib/organize.sh
source "$SCRIPT_DIR/lib/organize.sh"

# Valeurs par défaut (modifiables par variables d'environnement ou options)
SOURCE_DIR="${AO_SOURCE_DIR:-$DEFAULT_SOURCE_DIR}"
DEST_ROOT="${AO_DEST_ROOT:-$HOME}"
DRY_RUN=false
VERBOSE=false

usage() {
    cat << 'EOF'
Usage : auto-organizer.sh [options]

  -s, --source DIR   dossier à nettoyer (défaut : Téléchargements)
  -d, --dest DIR     dossier qui contiendra Images, Documents... (défaut : $HOME)
  -n, --dry-run      simulation : n'effectue aucun déplacement
  -v, --verbose      affiche davantage de détails
  -h, --help         affiche cette aide
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--source)
                [[ $# -ge 2 ]] || die "L'option $1 demande une valeur."
                SOURCE_DIR="$2"
                shift 2 ;;
            -d|--dest)
                [[ $# -ge 2 ]] || die "L'option $1 demande une valeur."
                DEST_ROOT="$2"
                shift 2 ;;
            -n|--dry-run)
                DRY_RUN=true
                shift ;;
            -v|--verbose)
                VERBOSE=true
                shift ;;
            -h|--help)
                usage
                exit 0 ;;
            *)
                die "Option inconnue : $1 (voir --help)" ;;
        esac
    done
}

main() {
    parse_args "$@"

    [[ -d "$SOURCE_DIR" ]] || die "Dossier source introuvable : $SOURCE_DIR"

    if [[ "$DRY_RUN" == true ]]; then
        log "Mode SIMULATION : aucun fichier ne sera déplacé."
    fi

    log "Source : $SOURCE_DIR"
    log "Destination : $DEST_ROOT"

    organize_directory "$SOURCE_DIR" "$DEST_ROOT"
}

main "$@"
