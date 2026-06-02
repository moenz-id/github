# Service Name

## Summary

Jelaskan fungsi service, alasan dipakai, dan posisi service dalam homelab.

---

# Environment

- Host:
- Runtime:
- Data path:
- Stack path:
- Network:

---

# Prerequisites

```bash
docker version
docker compose version
docker network ls
```

---

# Directory Layout

```text
/data
├── appdata
└── stack
```

---

# Docker Compose

File compose:

- `docker/service.yaml`

Deploy:

```bash
mkdir -p /data/stack/service
cp docker/service.yaml /data/stack/service/compose.yaml
cd /data/stack/service
docker compose config
docker compose pull
docker compose up -d
```

---

# Verification

```bash
docker ps
docker logs -f service
```

---

# Backup

```text
/data/appdata/service
/data/stack/service
```

---

# Troubleshooting

Catat error umum, log yang perlu dicek, dan langkah recovery.
