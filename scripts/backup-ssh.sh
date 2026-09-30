#!/usr/bin/env bash
# ==============================================================================
# Script per cifrare le chiavi SSH in secrets/ssh-keys.tar.age
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS_DIR="$DOTFILES_DIR/secrets"
mkdir -p "$SECRETS_DIR"

if [ ! -d "$HOME/.ssh" ] || [ -z "$(ls -A "$HOME/.ssh" 2>/dev/null)" ]; then
    echo "❌ Nessun file trovato in ~/.ssh"
    exit 1
fi

echo "=========================================================="
echo " 🔐 Cifratura chiavi SSH per il Disaster Recovery"
echo "=========================================================="
echo "Verrà creato l'archivio cifrato: $SECRETS_DIR/ssh-keys.tar.age"
echo "Ti verrà chiesta una PASSWORD. Ricordala o salvala nel tuo password manager!"
echo "----------------------------------------------------------"

# Usiamo age via Nix se non installato a livello di sistema
if command -v age &> /dev/null; then
    tar -cz -C "$HOME/.ssh" --exclude='agent' . | age -p > "$SECRETS_DIR/ssh-keys.tar.age"
else
    tar -cz -C "$HOME/.ssh" --exclude='agent' . | nix --extra-experimental-features "nix-command flakes" run nixpkgs#age -- -p > "$SECRETS_DIR/ssh-keys.tar.age"
fi

echo ""
echo "✅ Archivio cifrato creato con successo in secrets/ssh-keys.tar.age"
echo "Ora puoi committare questo file su Git in totale sicurezza:"
echo "  git add secrets/ssh-keys.tar.age"
echo "  git commit -m 'feat: add encrypted ssh keys'"
echo "=========================================================="
