# Armbian Documentation

Dokumentasi operasional homelab berbasis Armbian STB.

Repository ini menggunakan struktur dokumentasi yang dipisahkan berdasarkan fungsi agar lebih mudah dicari saat rebuild, migrasi, maupun troubleshooting.

---

# Documentation Structure

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
```

---

# Setup

Dokumentasi instalasi dan konfigurasi dasar sistem.

- [Install Docker](setup/install-docker.md)
- [Install Tailscale](setup/install-tailscale.md)
- [Migrate Docker Root to SD Card](setup/migrate-docker-root-to-sdcard.md)

Topik:
- Instalasi Docker
- Konfigurasi Docker Compose
- Network internal_net
- Instalasi Tailscale
- Migrasi Docker Root ke SD Card

---

# Services

Dokumentasi deployment layanan yang digunakan pada homelab.

- [Home Assistant](services/homeassistant.md)
- [Portainer](services/portainer.md)
- [Cloudflared](services/cloudflared.md)
- [SearXNG](services/searxng.md)

Topik:
- Home Assistant + Mosquitto
- Portainer CE
- Cloudflare Tunnel
- SearXNG

---

# Maintenance

Dokumentasi pemeliharaan, backup, recovery, dan troubleshooting.

- [Docker Backup & Restore](maintenance/backup-restore-docker.md)
- [Troubleshooting](maintenance/troubleshooting.md)

Topik:
- Backup dan Restore Docker
- Recovery setelah kegagalan sistem
- Docker Storage Layout
- Troubleshooting jaringan
- Catatan operasional homelab

---

# Docker Compose

File compose siap pakai disimpan di:

- [Docker Compose Files](../docker/README.md)
- [homeassistant.yaml](../docker/homeassistant.yaml)
- [portainer.yaml](../docker/portainer.yaml)
- [cloudflared.yaml](../docker/cloudflared.yaml)
- [searxng.yaml](../docker/searxng.yaml)

---

# Current Architecture

## OpenWrt

Role:
- Gateway
- DHCP Server
- DNS Server
- Internet Routing

## Armbian STB

Role:
- Docker Host
- Home Assistant
- Mosquitto
- Portainer
- Cloudflared

## Network Standard

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

# Notes

Dokumentasi utama berada di subfolder berdasarkan fungsi. File lama di root `armbian/` sudah dimigrasikan ke struktur ini.
