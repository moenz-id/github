# Install Docker on Armbian (STB Homelab)

## Summary

Dokumentasi instalasi Docker pada Armbian untuk kebutuhan homelab STB.

Panduan ini mencakup:

- Install Docker Engine
- Install Docker Compose Plugin
- Verifikasi instalasi Docker
- Setup direktori data homelab
- Setup mount SD Card untuk data Docker
- Pembuatan network internal_net (opsional)

Panduan ini tidak mencakup instalasi aplikasi seperti Home Assistant, Mosquitto, AdGuard Home, ESPHome, maupun n8n.

---

# Environment

Contoh environment:

- Armbian 26.x
- Kernel OPhub
- ARM64 / AArch64
- eMMC untuk sistem operasi
- SD Card untuk data homelab

---

# Update Sistem

```bash
sudo apt update
sudo apt upgrade -y
```

---

# Install Dependency

```bash
sudo apt install -y ca-certificates curl
```

---

# Tambahkan Repository Docker

```bash
sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/debian/gpg \
-o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Tambahkan repository:

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update repository:

```bash
sudo apt update
```

---

# Install Docker Engine

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

---

# Aktifkan Docker Saat Boot

```bash
sudo systemctl enable --now docker
```

Verifikasi:

```bash
systemctl status docker
```

---

# Tambahkan User ke Group Docker

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Atau logout dan login kembali.

---

# Verifikasi Instalasi

Cek versi Docker:

```bash
docker version
```

Cek Docker Compose:

```bash
docker compose version
```

Cek informasi Docker:

```bash
docker info
```

Cek container aktif:

```bash
docker ps
```

Tes Docker:

```bash
docker run hello-world
```

---

# Setup SD Card Untuk Data Homelab

Cek disk:

```bash
lsblk -f
```

Contoh mount point:

```bash
sudo mkdir -p /data
```

Tambahkan ke fstab:

```fstab
UUID=<UUID_SD_CARD> /data ext4 defaults,noatime 0 2
```

Reload:

```bash
sudo mount -a
sudo systemctl daemon-reload
```

Verifikasi:

```bash
df -h /data
```

---

# Struktur Direktori Homelab

Contoh struktur direktori:

```text
/data
├── appdata
│   ├── homeassistant
│   ├── mosquitto
│   ├── adguardhome
│   ├── esphome
│   └── n8n
├── backups
└── stack
```

Buat direktori:

```bash
mkdir -p /data/appdata
mkdir -p /data/backups
mkdir -p /data/stack
```

---

# Opsional: Pindahkan Docker Root ke SD Card

Jika kapasitas eMMC terbatas, Docker Root dapat dipindahkan ke SD Card.

Buat direktori:

```bash
mkdir -p /data/docker-data
```

Buat konfigurasi:

```bash
sudo mkdir -p /etc/docker
sudo nano /etc/docker/daemon.json
```

Isi:

```json
{
  "data-root": "/data/docker-data"
}
```

Restart Docker:

```bash
sudo systemctl restart docker
```

Verifikasi:

```bash
docker info | grep "Docker Root Dir"
```

Output yang diharapkan:

```text
Docker Root Dir: /data/docker-data
```

---

# Opsional: Membuat Network internal_net

Buat network bridge internal untuk komunikasi antar container.

```bash
docker network create internal_net
```

Verifikasi:

```bash
docker network ls
```

Contoh output:

```text
internal_net
```

Network ini dapat digunakan oleh service seperti:

- Mosquitto
- ESPHome
- AdGuard Home
- n8n
- Portainer

---

# Final Verification

```bash
docker version
docker compose version
docker info
docker network ls
docker ps
```

Jika seluruh perintah berjalan tanpa error maka Docker siap digunakan untuk deploy service homelab.
