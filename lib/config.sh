#!/usr/bin/env bash
# Configuration globale : dossier source et noms des dossiers de destination.

# Dossier à nettoyer : on demande à xdg-user-dir le dossier Téléchargements
# officiel (il peut être en français ou en anglais selon la langue du système).
DEFAULT_SOURCE_DIR="$(xdg-user-dir DOWNLOAD 2>/dev/null || true)"
DEFAULT_SOURCE_DIR="${DEFAULT_SOURCE_DIR:-$HOME/Téléchargements}"

# Noms des sous-dossiers créés dans la destination (par défaut : $HOME)
DIR_IMAGES="Images"
DIR_DOCUMENTS="Documents"
DIR_ARCHIVES="Archives"
DIR_VIDEOS="Vidéos"
DIR_MUSIQUE="Musique"
DIR_INSTALLATEURS="Installateurs"
DIR_EBOOKS="Ebooks"
DIR_DIVERS="Divers"
