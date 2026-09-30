#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "❌ Questo script deve essere eseguito come root: sudo $0"
  exit 1
fi

echo "🔧 Impostazione contesto SELinux per librerie e glibc di Nix..."

# 1. Assegna a /nix/store il contesto di sistema usr_t (come /usr per caricare glibc e librerie)
chcon -R -t usr_t /nix/store
semanage fcontext -a -t usr_t "/nix/store(/.*)?" 2>/dev/null || true

# 2. Assegna il contesto bin_t agli eseguibili
chcon -R -t bin_t /nix/store/*-nix-*/bin 2>/dev/null || true
semanage fcontext -a -t bin_t "/nix/store/[^/]+/bin(/.*)?" 2>/dev/null || true

# 3. Mantiene var_run_t per il socket
chcon -t var_run_t /nix/var/nix/daemon-socket

# 4. Compila e applica eventuali permessi residui tramite audit2allow
WORKDIR=$(mktemp -d)
cd "$WORKDIR"
if ausearch -m AVC,USER_AVC -ts recent 2>/dev/null | audit2allow -M nix-daemon-auto; then
    semodule -i nix-daemon-auto.pp 2>/dev/null || true
fi
rm -rf "$WORKDIR"

# 5. Riavvia socket e servizio
systemctl reset-failed nix-daemon.service nix-daemon.socket 2>/dev/null || true
systemctl restart nix-daemon.socket
systemctl restart nix-daemon.service

echo ""
echo "✅ Fatto! Verifica stato del servizio:"
systemctl status nix-daemon.service --no-pager
