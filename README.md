# 🍎 Dotfiles & Disaster Recovery (Mac M2 Air - Fedora Asahi)

Configurazioni personali per ambiente Wayland su Apple Silicon (Fedora Asahi Linux) basato su **Hyprland**, **DankMaterialShell**, **Kitty**, **Neovim** e gestito in modo dichiarativo e riproducibile tramite **Nix Flakes** e **Home Manager**.

---

## 🛠 Componenti Principali

| Componente | Software | Note |
| :--- | :--- | :--- |
| **OS** | Fedora Asahi Remix 44 | Driver audio, notch, kernel Apple Silicon |
| **Window Manager** | [Hyprland](https://hyprland.org/) | Wayland compositor per display Retina / ProMotion |
| **Desktop Shell** | [DankMaterialShell](https://github.com/DankMaterialShell) | Shell moderna in QML / Material Design 3 con Matugen |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | Terminale GPU-accelerated con temi dinamici |
| **Shell** | [Zsh](https://www.zsh.org/) | Configurazione ricca di alias, zoxide e opzioni |
| **Editor** | [Neovim](https://neovim.io/) | LazyVim setup preconfigurato |
| **Status Bar** | [Waybar](https://github.com/Alexays/Waybar) | Barra di stato alternativa/fallback |
| **Package & Config Manager** | [Nix](https://nixos.org/) + [Home Manager](https://github.com/nix-community/home-manager) | Gestione dichiarativa di pacchetti CLI e symlink |
| **Gestione Segreti** | [age](https://github.com/FiloSottile/age) | Cifratura sicura delle chiavi SSH con passphrase |

---

## 📂 Struttura del Repository

```text
dotfiles/
├── flake.nix             # Flake Nix: supporto sia per M2 (aarch64) che per x86_64
├── home.nix              # Configurazione dichiarativa Home Manager (pacchetti CLI e symlink)
├── bootstrap.sh          # Script per il ripristino automatico da zero (Disaster Recovery)
├── configs/              # File sorgente reali delle configurazioni
│   ├── DankMaterialShell/# Impostazioni interfaccia (settings.json, plugin, temi)
│   ├── hypr/             # Hyprland, hypridle, hyprlock e impostazioni dms
│   ├── kitty/            # Terminale Kitty
│   ├── nvim/             # Neovim (LazyVim)
│   ├── waybar/           # Configurazione Waybar
│   └── zsh/              # File .zshrc
├── scripts/
│   ├── backup-ssh.sh     # Script per cifrare le chiavi SSH prima del commit
│   └── fix-nix-service.sh# Script di supporto per il demone Nix
└── secrets/
    └── ssh-keys.tar.age  # Archivio cifrato delle chiavi SSH (sicuro da salvare su Git)
```

---

## ⚙️ Come Funziona il Sistema

1. **`flake.nix`**: È l'entrypoint di Nix. Definisce le dipendenze esterne (`nixpkgs` e `home-manager`) ed espone la configurazione `"lollodo"` per architettura Apple Silicon (`aarch64-linux`) e `"lollodo-x86"` per PC standard.
2. **`home.nix`**: Specifica l'elenco dei pacchetti CLI da installare (es. `neovim`, `matugen`, `zoxide`, `btop`, `kubectl`, ecc.) e mappa i symlink:
   - `configs/hypr` $\rightarrow$ `~/.config/hypr`
   - `configs/kitty` $\rightarrow$ `~/.config/kitty`
   - `configs/nvim` $\rightarrow$ `~/.config/nvim`
   - `configs/waybar` $\rightarrow$ `~/.config/waybar`
   - `configs/DankMaterialShell` $\rightarrow$ `~/.config/DankMaterialShell`
   - `configs/zsh/.zshrc` $\rightarrow$ `~/.zshrc`
3. **Nix Store**: Tutti i pacchetti e i file di configurazione sono isolati e immutabili. Modificare i sorgenti in `configs/` e riapplicare la configurazione crea una nuova **generazione atomica** con possibilità di rollback immediato.

---

## 🚨 Disaster Recovery: Ripristino Rapido da Zero

Se formatti il computer o configuri una nuova macchina Fedora da zero:

### 1. Installa Nix sul nuovo sistema
Apri il terminale ed esegui l'installer raccomandato di Determinate Systems:
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

Lo script si occuperà automaticamente di:
1. Verificare Nix e abilitare `flakes` e `nix-command` in `~/.config/nix/nix.conf`.
2. Chiederti la password master per decifrare `secrets/ssh-keys.tar.age` e ripristinare le chiavi in `~/.ssh/` con i permessi corretti (`600`/`644`).
3. Rilevare se sei su Apple Silicon (`aarch64`) o x86 (`x86_64`).
4. Applicare Home Manager con `-b backup` (gestendo eventuali conflitti preesistenti).

---

## 🔄 Manutenzione Quotidiana con Home Manager

### Applicare modifiche ai dotfiles
Dopo aver modificato file in `configs/` o aggiunto pacchetti in `home.nix`:
```bash
# IMPORTANTE: Nix Flakes legge solo i file tracciati da Git!
git add .

# Applica le modifiche:
home-manager switch --flake ".#lollodo"
```

> [!NOTE]
> In Zsh ricorda di mettere tra virgolette `".#lollodo"` per evitare l'errore `zsh: no match` dovuto al carattere `#`.

### Aggiornare tutti i pacchetti Nix
```bash
nix flake update
home-manager switch --flake ".#lollodo"
```

### Rollback (Tornare indietro se qualcosa non va)
Home Manager salva lo storico di ogni switch:
```bash
# Per vedere lo storico delle generazioni:
home-manager generations

# Per fare il rollback alla versione precedente immediata:
home-manager switch --rollback
```

---

## 🔐 Gestione Sicura delle Chiavi SSH

Le chiavi private **non sono mai salvate in chiaro su Git**. Sono archiviate in `secrets/ssh-keys.tar.age` usando **age** protetto da passphrase.

### Come aggiornare il backup delle chiavi SSH:
Se generi una nuova chiave SSH o modifichi la configurazione in `~/.ssh`:
```bash
./scripts/backup-ssh.sh
```
Inserisci la tua passphrase, poi committa e pusha su Git:
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
