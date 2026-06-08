# Armbian Documentation

Dokumentasi operasional homelab berbasis Armbian STB.
Repository ini menggunakan struktur dokumentasi yang dipisahkan berdasarkan fungsi agar lebih mudah dicari saat rebuild, migrasi, maupun troubleshooting.

---

## Documentation Structure

```text
armbian/
├── setup/
│   ├── install-docker.md
│   ├── install-tailscale.md
│   └── migrate-docker-root-to-sdcard.md
├── services/
│   ├── cloudflared.md
│   ├── homeassistant.md
│   ├── portainer.md
│   └── searxng.md
├── maintenance/
│   ├── backup-restore-docker.md
│   └── troubleshooting.md
└── scripts/ # Akan segera ditambahkan
```

---

## Current Architecture

### OpenWrt
Role:
- Gateway
- DHCP Server
- DNS Server
- Internet Routing

### Armbian STB
Role:
- Docker Host
- Home Assistant
- Mosquitto
- Portainer
- Cloudflared

### Network Standard
Sebagian besar container menggunakan:
```text
internal_net
```
Sedangkan Home Assistant menggunakan:
```text
network_mode: host
```
untuk mempermudah discovery perangkat lokal.

---

## Related Documentation

Berikut adalah daftar dokumentasi terkait yang bisa Anda jelajahi:

### ⚙️ Setup & Instalasi
- [Install Docker](setup/install-docker.md)
- [Install Tailscale](setup/install-tailscale.md)
- [Migrate Docker Root to SD Card](setup/migrate-docker-root-to-sdcard.md)

### 🚀 Layanan (Services)
- [Home Assistant](services/homeassistant.md)
- [Portainer](services/portainer.md)
- [Cloudflared](services/cloudflared.md)
- [SearXNG](services/searxng.md)

### 🧹 Pemeliharaan (Maintenance)
- [Docker Backup & Restore](maintenance/backup-restore-docker.md)
- [Troubleshooting](maintenance/troubleshooting.md)

### 🐳 Konfigurasi Docker Compose (Referensi)
- [Docker Compose Overview (Main Repo)](../docker/README.md)
- [homeassistant.yaml](../docker/homeassistant.yaml)
- [portainer.yaml](../docker/portainer.yaml)
- [cloudflared.yaml](../docker/cloudflared.yaml)
- [searxng.yaml](../docker/searxng.yaml)

### 🧑‍💻 Script Pembantu (Akan Datang)
- Skrip otomatisasi untuk backup, sync, dan maintenance akan ditambahkan di folder ini.

---

## Notes

Dokumentasi utama berada di subfolder berdasarkan fungsi. File lama di root `armbian/` sudah dimigrasikan ke struktur ini.
