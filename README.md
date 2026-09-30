# 🍎 Dotfiles & Disaster Recovery (Mac M2 Air - Fedora Asahi)

Configurazioni personali per ambiente Wayland su Apple Silicon (Fedora Asahi Linux) basato su **Hyprland**, **DankMaterialShell**, **Kitty**, **Neovim** e gestito in modo dichiarativo e riproducibile tramite **Nix Flakes** e **Home Manager**.

---

## 🛠 Componenti Principali

| Componente | Software | Note |
| :--- | :--- | :--- |
| **OS** | Fedora Asahi Remix 44 | Driver audio, notch, kernel Apple Silicon |
| **Window Manager** | [Hyprland](https://hyprland.org/) | Wayland compositor per display Retina / ProMotion |
| **Desktop Shell** | [DankMaterialShell](https://github.com/DankMaterialShell) | Shell moderna in QML / Material Design 3 |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | Terminale GPU-accelerated con temi dinamici |
| **Shell** | [Zsh](https://www.zsh.org/) | Configurazione ricca di alias e opzioni |
| **Editor** | [Neovim](https://neovim.io/) | LazyVim setup preconfigurato |
| **Status Bar** | [Waybar](https://github.com/Alexays/Waybar) | Barra di stato alternativa/fallback |
| **Package & Config Manager**| [Nix](https://nixos.org/) + [Home Manager](https://github.com/nix-community/home-manager) | Gestione dichiarativa di pacchetti e symlink |
| **Gestione Segreti** | [age](https://github.com/FiloSottile/age) | Cifratura sicura delle chiavi SSH |

---

## 📂 Struttura del Repository

```text
dotfiles/
├── flake.nix             # Flake Nix: supporto sia per M2 (aarch64) che per x86_64
├── home.nix              # Configurazione dichiarativa Home Manager (pacchetti e symlink)
├── bootstrap.sh          # Script per il ripristino automatico da zero
├── configs/              # Configurazioni vive e autosufficienti
│   ├── DankMaterialShell/# Impostazioni interfaccia (settings.json, plugin, temi)
│   ├── hypr/             # Hyprland, hypridle, hyprlock
│   ├── kitty/            # Terminale Kitty
│   ├── nvim/             # Neovim (LazyVim)
│   ├── waybar/           # Configurazione Waybar
│   └── zsh/              # File .zshrc
├── scripts/
│   └── backup-ssh.sh     # Script per cifrare le chiavi SSH prima del commit
└── secrets/
    └── ssh-keys.tar.age  # Archivio cifrato delle chiavi SSH (sicuro da pushare su Git)
```

---

## 🚨 Guida Disaster Recovery: Da Fedora pulita al tuo desktop in 5 minuti

Se il computer viene formattato o ne configuri uno nuovo da zero:

### 1. Installa Nix sul nuovo sistema
Apri il terminale di Fedora ed esegui l'installer raccomandato:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- run
```
*(Chiudi e riapri il terminale per caricare i binari di Nix nel PATH).*

### 2. Clona questo repository
```bash
git clone https://github.com/LorenzoDOrtona/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Esegui il Bootstrap automatico
```bash
./bootstrap.sh
```
Lo script si occuperà di:
1. Verificare che Nix e i Flakes siano abilitati.
2. Chiederti la password master per decifrare `secrets/ssh-keys.tar.age` e ripristinare tutte le chiavi in `~/.ssh/` con i corretti permessi (`600`/`644`).
3. Rilevare se sei su Apple Silicon (`aarch64`) o PC Intel/AMD (`x86_64`).
4. Applicare la configurazione Home Manager scaricando tutti i tool CLI e collegando i file in `~/.config/`.

---

## 🔐 Gestione Chiavi SSH

Le chiavi private **non sono mai salvate in chiaro su Git**. Sono archiviate in `secrets/ssh-keys.tar.age` usando **age** protetto da passphrase.

### Come aggiornare il backup delle chiavi SSH:
Se generi una nuova chiave SSH o modifichi la configurazione:
```bash
./scripts/backup-ssh.sh
```
Inserisci la tua passphrase, poi committa e pusha le modifiche:
```bash
git add secrets/ssh-keys.tar.age
git commit -m "chore: update encrypted ssh keys"
git push
```

### Come decifrare manualmente le chiavi SSH:
```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
nix run nixpkgs#age -- -d secrets/ssh-keys.tar.age | tar -xz -C ~/.ssh
chmod 600 ~/.ssh/* && chmod 644 ~/.ssh/*.pub
```

---

## 🔄 Manutenzione Quotidiana con Nix & Home Manager

### Applicare modifiche ai dotfiles
Dopo aver modificato file in `configs/` o aggiunto pacchetti in `home.nix`:
```bash
# Se aggiungi nuovi file a configs, segnalali prima a Git:
git add .

# Applica le modifiche:
nix run github:nix-community/home-manager -- switch --flake .#lollodo
```

### Aggiornare tutti i pacchetti Nix all'ultima versione
```bash
nix flake update
nix run github:nix-community/home-manager -- switch --flake .#lollodo
```

### Ripristino di una generazione precedente (Rollback immediato)
Se un aggiornamento crea problemi a un tool:
```bash
home-manager generations
# Per tornare indietro:
/nix/var/nix/profiles/per-user/lollodo/home-manager-XX-link/activate
```
