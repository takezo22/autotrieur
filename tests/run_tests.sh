#!/usr/bin/env bash
# Teste auto-organizer.sh dans un environnement fictif, sans toucher aux vrais fichiers.

set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d /tmp/ao_test.XXXXXX)"
SRC="$TEST_ROOT/Téléchargements"
DEST="$TEST_ROOT/Accueil"
FAILS=0

echo "=== Création de l'environnement de test dans $TEST_ROOT ==="
mkdir -p "$SRC" "$DEST/Images"

# Fichiers de test : espaces, accents, majuscules, parenthèses, cas limites
touch "$SRC/photo vacances.JPG"
touch "$SRC/facture 2026 final.pdf"
touch "$SRC/archive données.tar.gz"
touch "$SRC/rapport (v2).docx"
touch "$SRC/video test.mp4"
touch "$SRC/Ma présentation.pptx"
touch "$SRC/sans_extension"
touch "$SRC/.cache_caché"              # fichier caché : doit rester
touch "$SRC/telechargement.crdownload" # téléchargement incomplet : doit rester

# Test de collision : un fichier du même nom existe déjà à destination
touch "$DEST/Images/doublon.png"
touch "$SRC/doublon.png"

echo
echo "=== Test 1 : mode simulation (aucun fichier ne doit bouger) ==="
"$PROJECT_DIR/auto-organizer.sh" -n -s "$SRC" -d "$DEST"

if [[ -e "$SRC/photo vacances.JPG" && -e "$SRC/doublon.png" ]]; then
    echo "  OK   la simulation n'a rien déplacé"
else
    echo "  FAIL la simulation a déplacé des fichiers"
    FAILS=$((FAILS + 1))
fi

echo
echo "=== Test 2 : tri réel ==="
"$PROJECT_DIR/auto-organizer.sh" -s "$SRC" -d "$DEST"

check() {
    local path="$1"
    if [[ -e "$path" ]]; then
        echo "  OK   ${path#"$TEST_ROOT"/}"
    else
        echo "  FAIL ${path#"$TEST_ROOT"/}"
        FAILS=$((FAILS + 1))
    fi
}

echo
echo "=== Vérification des résultats ==="
check "$DEST/Images/photo vacances.JPG"
check "$DEST/Documents/facture 2026 final.pdf"
check "$DEST/Archives/archive données.tar.gz"
check "$DEST/Documents/rapport (v2).docx"
check "$DEST/Vidéos/video test.mp4"
check "$DEST/Documents/Ma présentation.pptx"
check "$DEST/Divers/sans_extension"
check "$DEST/Images/doublon (1).png"
check "$SRC/.cache_caché"
check "$SRC/telechargement.crdownload"

echo
if [[ "$FAILS" -eq 0 ]]; then
    echo "✅ Tous les tests sont passés."
else
    echo "❌ $FAILS test(s) en échec."
fi
echo "Environnement conservé pour inspection : $TEST_ROOT"
echo "Pour le supprimer : rm -rf $TEST_ROOT"

exit "$FAILS"

