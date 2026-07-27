# Base Server Setup (Ubuntu)

## Tags
ubuntu, server, setup, hardening, ufw, ssh, github, base-os

---

# Summary

Dokumentasi setup dasar server Ubuntu (fresh install) agar siap digunakan untuk
kebutuhan development & personal. Panduan ini mencakup:

- Update & upgrade sistem
- Instalasi tooling development & sysadmin
- Konfigurasi firewall (UFW)
- Hardening SSH (opsional)
- Koneksi GitHub CLI (`gh`)
- Konvensi working directory

Panduan ini berfokus pada Ubuntu 26.04 LTS, namun sebagian besar langkah
berlaku untuk versi Ubuntu LTS lainnya.

---

# Table of Contents

- Environment
- Update Sistem
- Install Tooling
- Firewall (UFW)
- Hardening SSH (Opsional)
- Koneksi GitHub CLI
- Konvensi Working Directory
- Final Verification

---

# Environment

Contoh environment pada panduan ini:

- Ubuntu 26.04 LTS
- User non-root dengan hak sudo
- Akses via SSH (key-based)

---

# Update Sistem

Selalu mulai dengan pembaruan sistem:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
```

Jika muncul pemberitahuan service restart ditunda (needrestart), itu normal.
Reboot hanya diperlukan jika kernel atau mikrokode berubah dan kamu ingin
bersih — tidak mendesak.

---

# Install Tooling

Tooling inti untuk development & sysadmin:

```bash
sudo apt install -y git git-lfs gh build-essential ca-certificates \
  neovim bat ripgrep fd-find fzf zoxide btop tmux htop rsync tree
```

Catatan distribusi:

- `bat` di Debian/Ubuntu binarnya bernama `batcat`. Buat symlink agar perintah
  `bat` langsung tersedia:
  ```bash
  sudo ln -sf /usr/bin/batcat /usr/bin/bat
  ```
- `fd-find` di Debian/Ubuntu binarnya bernama `fdfind`. Untuk menggunakan
  sebagai `fd`, buat symlink atau alias:
  ```bash
  sudo ln -sf /usr/bin/fdfind /usr/bin/fd
  ```

Set git global (isi dengan identitas GitHub kamu):

```bash
git config --global user.name "username"
git config --global user.email "email@domain"
git config --global init.defaultBranch main
```

---

# Firewall (UFW)

Aktifkan firewall dengan kebijakan default deny incoming. **Penting:** izinkan
SSH terlebih dahulu sebelum mengaktifkan UFW agar tidak ke-lockout.

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw --force enable
```

Verifikasi:

```bash
sudo ufw status verbose
```

Pastikan rule `22/tcp ALLOW IN` muncul dan status `active`. UFW otomatis aktif
saat boot.

---

# Hardening SSH (Opsional)

Langkah ini direkomendasikan untuk server yang diekspos ke jaringan. Buat
drop-in config agar tidak mengubah main config `sshd_config`:

```bash
sudo tee /etc/ssh/sshd_config.d/10-hardening.conf >/dev/null <<'EOF'
# Drop-in hardening
# Pubkey auth tetap aktif; password login dimatikan
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF
```

Uji config sebelum restart:

```bash
sudo sshd -t
```

Jika keluar `config OK` (tanpa error), restart service:

```bash
sudo systemctl restart ssh
```

Verifikasi nilai efektif:

```bash
sudo sshd -T | grep -E '^(passwordauthentication|pubkeyauthentication|permitrootlogin)'
```

Prasyarat: pastikan public key kamu sudah ada di `~/.ssh/authorized_keys`
sebelum mematikan password authentication, agar tidak ke-lockout.

---

# Koneksi GitHub CLI

Instalasi `gh` sudah dilakukan di bagian tooling. Ada dua cara login:

**Cara 1 — Interaktif (browser):**

```bash
gh auth login
```

Ikuti prompt: pilih GitHub.com, protokol HTTPS, lalu autentikasi via browser.

**Cara 2 — via environment variable (token):**

Simpan token di environment variable (jangan hardcode ke file dokumentasi):

```bash
export GH_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "$GH_TOKEN" | gh auth login --with-token
```

Verifikasi:

```bash
gh auth status
```

Pastikan menampilkan akun GitHub kamu dan token scopes yang sesuai
(mis. `repo`, `workflow`).

---

# Konvensi Working Directory

Gunakan satu folder standar untuk semua proyek agar terstruktur:

```bash
mkdir -p ~/projects
```

Setiap repo hasil clone otomatis mendapat subfolder sendiri, contoh:

```bash
cd ~/projects
gh repo clone owner/nama-repo
# hasil: ~/projects/nama-repo/
```

Untuk path khusus, tentukan eksplisit:

```bash
gh repo clone owner/nama-repo ~/projects/myapp
# hasil: ~/projects/myapp/
```

---

# Final Verification

Cek bahwa semua komponen siap:

```bash
# Tooling
command -v git gh nvim bat rg fdfind fzf zoxide btop tmux
# Firewall
sudo ufw status verbose
# SSH (jika di-hardening)
sudo sshd -T | grep -E '^(passwordauthentication|pubkeyauthentication)'
# GitHub
gh auth status
# Git config
git config --global --list
```

Jika seluruh perintah berjalan tanpa error, server siap digunakan untuk
development & personal operation.
