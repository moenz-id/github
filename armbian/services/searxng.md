# Deploy SearXNG on Armbian

## Summary

Dokumentasi deployment SearXNG menggunakan Docker Compose pada Armbian.

SearXNG dipakai sebagai metasearch engine self-hosted.

Panduan ini mengikuti standar homelab repository:

- Data aplikasi berada di `/data/appdata`
- Stack berada di `/data/stack`
- Menggunakan network internal `internal_net`
- Reverse proxy lewat Cloudflare Tunnel

---

# Prerequisites

Pastikan Docker sudah berjalan.

```bash
docker version
docker compose version
```

Pastikan network `internal_net` tersedia.

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
│   └── searxng
│       ├── config
│       ├── cache
│       └── valkey
└── stack
    └── searxng
        └── compose.yaml
```

---

# Docker Compose

File compose tersedia di:

- [../../docker/searxng.yaml](../../docker/searxng.yaml)

SearXNG menyimpan konfigurasi di `/etc/searxng` dan cache di `/var/cache/searxng`. Keduanya harus dipersistenkan agar konfigurasi tidak hilang saat container direcreate.

Minimal `settings.yml` yang dipakai adalah:

```yaml
use_default_settings: true
```

Karena instance ini diakses lewat Cloudflare Tunnel, limiter sebaiknya aktif dan Valkey wajib tersedia.

Cloudflare Tunnel sebaiknya diarahkan ke:

```text
http://searxng:8080
```

Bukan ke port host, supaya trafik tetap berada di Docker network `internal_net`.

Compose yang dipakai di repo ini tidak mem-publish port host. Akses dilakukan lewat Cloudflare Tunnel.

---

# Deploy

Buat direktori:

```bash
mkdir -p /data/appdata/searxng/config
mkdir -p /data/appdata/searxng/cache
mkdir -p /data/appdata/searxng/valkey
mkdir -p /data/stack/searxng
```

Buat file konfigurasi awal:

```bash
cat > /data/appdata/searxng/config/settings.yml <<'EOF'
use_default_settings: true
EOF
```

Salin compose:

```bash
cp docker/searxng.yaml /data/stack/searxng/compose.yaml
```

Jika Anda ingin SearXNG diakses lewat Cloudflare Tunnel, set `SEARXNG_BASE_URL` ke hostname tunnel Anda, misalnya:

```text
https://search.moenz.my.id/
```

Tambahkan juga `SEARXNG_SECRET` ke `.env` agar SearXNG tidak memakai secret bawaan.

Cara paling simpel adalah membuat file `.env` di stack deployment:

```bash
cat > /data/stack/searxng/.env <<'EOF'
SEARXNG_BASE_URL=https://search.moenz.my.id/
SEARXNG_SECRET=replace-with-random-secret
SEARXNG_LIMITER=true
SEARXNG_PUBLIC_INSTANCE=true
SEARXNG_IMAGE_PROXY=true
SEARXNG_VALKEY_URL=valkey://valkey:6379/0
EOF
```

### limiter.toml

Buat file `/data/appdata/searxng/config/limiter.toml` untuk trusted proxy Docker / Cloudflare Tunnel:

```toml
[botdetection]
ipv4_prefix = 32
ipv6_prefix = 48
trusted_proxies = [
  '127.0.0.0/8',
  '::1',
  '172.18.0.0/16',
]

[botdetection.ip_limit]
link_token = true
filter_link_local = false
```

---

# Validasi Compose

```bash
cd /data/stack/searxng
docker compose config
```

---

# Download Image

```bash
cd /data/stack/searxng
docker compose pull
```

---

# Deploy Container

```bash
cd /data/stack/searxng
docker compose up -d
```

---

# Verification

```bash
docker ps
docker logs -f searxng
```

Jika container berjalan normal, SearXNG bisa diakses melalui:

```text
https://search.moenz.my.id/
```

---

# Backup Data Penting

```text
/data/appdata/searxng
/data/stack/searxng
```

---

# Notes

Jika SearXNG nantinya dipasang di belakang reverse proxy, ubah `SEARXNG_BASE_URL` ke domain publik atau internal yang benar agar link dan redirect dari aplikasi tetap konsisten.

Untuk Cloudflare Tunnel, pastikan public hostname di Zero Trust diarahkan ke `http://searxng:8080` dan bukan ke service lain atau IP yang berubah-ubah.
