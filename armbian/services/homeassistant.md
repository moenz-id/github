# Deploy Home Assistant Container on Armbian

## Summary

Dokumentasi deployment Home Assistant Container dan Mosquitto menggunakan Docker Compose pada Armbian.

Dokumen ini diasumsikan menggunakan environment yang telah mengikuti panduan:

- [Install Docker](../setup/install-docker.md)

---

# Prerequisites

Pastikan Docker sudah berjalan normal.

Verifikasi:

```bash
docker version
docker compose version
docker ps
```

Pastikan network internal_net sudah tersedia:

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
│   ├── homeassistant
│   └── mosquitto
│       ├── config
│       ├── data
│       └── log
└── stack
    └── homeassistant
        └── compose.yaml
```

---

# Docker Compose

File compose tersedia di:

- [../../docker/homeassistant.yaml](../../docker/homeassistant.yaml)

Home Assistant menggunakan `network_mode: host` untuk discovery perangkat lokal. Mosquitto tetap menggunakan `internal_net` dan port `1883` dipublish agar dapat diakses dari Home Assistant.

Mosquitto membutuhkan file konfigurasi. Contoh tersedia di:

- [../../docker/mosquitto.conf.example](../../docker/mosquitto.conf.example)

Untuk production, matikan anonymous access dan gunakan password file.

---

# Deploy

Buat direktori:

```bash
mkdir -p /data/appdata/homeassistant
mkdir -p /data/appdata/mosquitto/config
mkdir -p /data/appdata/mosquitto/data
mkdir -p /data/appdata/mosquitto/log
mkdir -p /data/stack/homeassistant
```

Salin compose dan contoh konfigurasi:

```bash
cp docker/homeassistant.yaml /data/stack/homeassistant/compose.yaml
cp docker/mosquitto.conf.example /data/appdata/mosquitto/config/mosquitto.conf
```

Validasi dan deploy:

```bash
cd /data/stack/homeassistant
docker compose config
docker compose pull
docker compose up -d
```

---

# Verification

```bash
docker ps
docker logs -f homeassistant
docker logs -f mosquitto
```

---

# Backup Data Penting

Direktori yang perlu dibackup:

```text
/data/appdata/homeassistant
/data/appdata/mosquitto
/data/stack/homeassistant
```

Dengan backup direktori tersebut, deployment dapat dipulihkan dengan cepat setelah reinstall Armbian atau migrasi perangkat.
