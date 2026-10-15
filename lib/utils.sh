#!/usr/bin/env bash
# Fonctions utilitaires : messages et gestion des erreurs.

log() {
    printf '[INFO] %s\n' "$*"
}

debug() {
    # N'affiche que si le mode verbeux est activé
    if [[ "$VERBOSE" == true ]]; then
        printf '[DEBUG] %s\n' "$*"
    fi
}

warn() {
    printf '[ATTENTION] %s\n' "$*" >&2
}

die() {
    printf '[ERREUR] %s\n' "$*" >&2
    exit 1
}
