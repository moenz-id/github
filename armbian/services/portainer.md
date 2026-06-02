# Deploy Portainer on Armbian

## Summary

Dokumentasi instalasi Portainer CE menggunakan Docker Compose pada Armbian.

Portainer digunakan sebagai web interface untuk mengelola:

- Container
- Images
- Volumes
- Networks
- Docker Compose Stack

Panduan ini mengikuti standar homelab repository:

- Docker Root berada di SD Card (opsional)
- Data aplikasi berada di /data/appdata
- Stack berada di /data/stack
- Menggunakan network internal_net

---

# Prerequisites

Pastikan Docker sudah berjalan.

```bash
docker version
docker compose version
```

Pastikan network internal_net tersedia.

```bash
docker network ls
```

Jika belum ada:

```bash
docker network create internal_net
```

---

# Struktur Direktori

```text
/data
├── appdata
│   └── portainer
└── stack
    └── portainer
```

---

# Docker Compose

File compose tersedia di:

- [../../docker/portainer.yaml](../../docker/portainer.yaml)

---

# Deploy

Buat direktori:

```bash
mkdir -p /data/appdata/portainer
mkdir -p /data/stack/portainer
```

Salin compose:

```bash
cp docker/portainer.yaml /data/stack/portainer/compose.yaml
```

Validasi dan deploy:

```bash
cd /data/stack/portainer
docker compose config
docker compose pull
docker compose up -d
```

---

# Verification

```bash
docker ps
docker logs -f portainer
```

---

# Akses Web UI

```text
https://IP-STB:9443
```

Portainer akan meminta pembuatan akun administrator pada login pertama.

---

# Backup Data Penting

```text
/data/appdata/portainer
/data/stack/portainer
```

---

# Notes

Portainer bukan kebutuhan wajib untuk Docker, namun sangat membantu ketika jumlah container mulai bertambah dan menjadi dashboard utama pengelolaan homelab berbasis Docker.
