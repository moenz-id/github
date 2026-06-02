# Docker Backup & Restore Notes

Dokumentasi ini berisi catatan operasional terkait backup, restore, migrasi Docker ke SD Card, serta recovery setelah kegagalan sistem.

---

# Docker Storage Layout

## Docker Root

Docker data disimpan pada SD Card:

```bash
/data/docker-data
```

Direkomendasikan untuk memindahkan Docker Root dari eMMC ke SD Card agar image dan layer container tidak menghabiskan ruang penyimpanan internal.

Jika masih menggunakan layout lama dengan bind mount ke `/var/lib/docker`, contoh `/etc/fstab`:

```fstab
UUID=<sdcard-uuid>  /data  ext4  defaults,noatime,commit=600  0  2

/data/docker      /var/lib/docker       none  bind  0  0
/data/containerd  /var/lib/containerd   none  bind  0  0
```

---

# Bind Mount vs Named Volume

Standar homelab ini menggunakan bind mount.

Contoh:

```yaml
volumes:
  - /data/appdata/homeassistant:/config
```

Artinya data aplikasi berada di luar container dan tetap aman saat container dihapus atau dibuat ulang.

---

# Backup Yang Direkomendasikan

Backup direktori berikut:

```text
/data/appdata
/data/stack
```

Pada layout lama, lokasi penting yang pernah digunakan:

```text
/home/moenz/docker
```

Berisi:

- Konfigurasi aplikasi
- Docker Compose
- Database aplikasi
- Data persisten container

---

# Backup Strategy

Contoh backup bind mount ke PC:

```bash
sudo rsync -avz /data/appdata/ user@BACKUP_PC:/home/user/backup/appdata/
sudo rsync -avz /data/stack/ user@BACKUP_PC:/home/user/backup/stack/
```

Jika masih memakai layout lama:

```bash
sudo rsync -avz /home/moenz/docker/ user@BACKUP_PC:/home/user/backup/config/
```

Backup metadata Docker hanya diperlukan untuk skenario recovery tertentu. Data aplikasi tetap prioritas utama.

```bash
sudo rsync -avz /var/lib/docker/ user@BACKUP_PC:/home/user/backup/docker/
```

---

# Recovery Workflow

Restart layanan:

```bash
sudo systemctl restart containerd
sudo systemctl restart docker
```

Kemudian deploy ulang:

```bash
docker compose up -d
```

---

# Common Issues

## RWLayer Error

Jika muncul error RWLayer atau metadata container rusak, biasanya data aplikasi masih aman selama direktori bind mount tidak hilang.

## Nested Docker Directory

Pastikan hasil restore tidak membuat struktur seperti:

```text
/var/lib/docker/docker
```

Karena Docker tidak dapat membaca metadata dengan benar.

Gunakan trailing slash saat restore agar yang disalin adalah isi direktori, bukan parent directory:

```bash
sudo rsync -avz user@BACKUP_PC:/home/user/backup/docker/docker/ /var/lib/docker/
```

## DNS Troubleshooting

Gunakan gateway OpenWrt sebagai DNS utama jika OpenWrt menjadi pusat jaringan:

```text
nameserver 192.168.1.1
```

`8.8.8.8` bisa dipakai sebagai fallback, tetapi konfigurasi DNS lokal lebih mudah dikelola lewat OpenWrt.

## MAC Address Conflict

Gejala umum:

- SSH kadang tidak bisa diakses
- Tidak bisa ping gateway
- Koneksi jaringan tidak stabil
- ARP bermasalah

Temporary fix:

```bash
sudo ip link set eth0 down
sudo ip link set eth0 address 02:11:22:33:44:55
sudo ip link set eth0 up
```

Permanent fix di `/etc/network/interfaces`:

```ini
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hwaddress ether 02:11:22:33:44:55
```

## Realtek WiFi Driver Spam

Jika log `RTL871X` membanjiri terminal:

```bash
dmesg -n 1
```

Opsional jika WiFi tidak digunakan:

```bash
sudo ip link set wlan0 down
```

---

# Useful Network Commands

```bash
ip a
ip route
sudo ip neigh flush all
sudo ip link set eth0 down
sudo ip link set eth0 up
```

---

# Final Lesson

Data terpenting bukan container Docker, melainkan direktori bind mount yang menyimpan konfigurasi dan state aplikasi.

Dengan backup yang baik, container dapat dibuat ulang menggunakan Docker Compose dalam hitungan menit.
