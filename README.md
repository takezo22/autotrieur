# Autotrieur

## Description
script bash qui range les fichiers d'un dossier en fonction de leur extension.

## Requirements

### Operating System
I personnaly use Linux Mint, but this should work on Debian/Ubuntu, Fedora and Arch as well

### Dependencies
bash, find, basename, dirname, mv, mkdir

## Usage
Usage : 
```
./auto-organizer.sh [options]
```
```
   -s, --source DIR   dossier à nettoyer (défaut : Téléchargements)
   -d, --dest DIR     dossier qui contiendra Images, Documents... (défaut : $HOME)
   -n, --dry-run      simulation : n'effectue aucun déplacement
   -v, --verbose      affiche davantage de détails
   -h, --help         affiche l'aide
```