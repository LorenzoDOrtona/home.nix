#!/usr/bin/env bash
# ==============================================================================
# Disaster Recovery & Bootstrap Script for Lollodo's Setup
# ==============================================================================
set -euo pipefail

echo "============================================="
echo " 🚀 Avvio Bootstrap & Disaster Recovery"
echo "============================================="

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# 1. Verifica/Installazione di Nix
if ! command -v nix &> /dev/null; then
    echo "📦 Nix non trovato. Installazione tramite Determinate Systems installer..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- run
    
    # Ricarica l'ambiente Nix
    if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
        . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
else
    echo "✅ Nix è già installato."
fi

# Abilita Flakes e nix-command se non abilitati
mkdir -p ~/.config/nix
if ! grep -q "flakes" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# 2. Ripristino Chiavi SSH
mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ -f "$DOTFILES_DIR/secrets/ssh-keys.tar.age" ]; then
    echo ""
    echo "🔑 Trovato archivio chiavi SSH cifrato."
    read -rp "Vuoi decifrare e ripristinare le chiavi SSH in ~/.ssh ora? [S/n] " confirm
    if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
        echo "Inserisci la passphrase per decifrare le chiavi SSH:"
        nix --extra-experimental-features "nix-command flakes" run nixpkgs#age -- -d "$DOTFILES_DIR/secrets/ssh-keys.tar.age" | tar -xz -C ~/.ssh
        chmod 600 ~/.ssh/* 2>/dev/null || true
        chmod 644 ~/.ssh/*.pub 2>/dev/null || true
        chmod 700 ~/.ssh
        echo "✅ Chiavi SSH ripristinate con permessi corretti."
    fi
else
    echo "ℹ️  Nessun archivio cifrato trovato in secrets/ssh-keys.tar.age (crealo con lo script di backup)."
fi

# 3. Rilevamento Architettura (Apple Silicon vs x86)
ARCH=$(uname -m)
FLAKE_TARGET="lollodo"
if [ "$ARCH" != "aarch64" ]; then
    FLAKE_TARGET="lollodo-x86"
fi

echo ""
echo "⚙️  Applicazione ambiente Home Manager (Target: $FLAKE_TARGET)..."
nix --extra-experimental-features "nix-command flakes" run github:nix-community/home-manager -- switch --flake ".#$FLAKE_TARGET" -b backup

echo ""
echo "============================================="
echo " 🎉 Configurazione completata con successo!"
echo " Riavvia il terminale o la sessione per goderti il tuo ambiente."
echo "============================================="
