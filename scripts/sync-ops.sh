#!/bin/bash

# sync-ops.sh - Helper script to sync system configs to moenz-ops repo
# usage: ./sync-ops.sh [backup|sync|status]

REPO_DIR="/home/moenz/moenz-ops"
BACKUP_DIR="/home/moenz///moenz-ops/backups"

case "$1" in
    backup)
        echo "📦 Backing up important configs to $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
        # Example: backup docker-compose files (modify paths as needed)
        # cp /etc/docker/compose.yaml "$BACKUP_DIR/docker-compose-$(date +%F).yaml"
        echo "✅ Backup complete."
        ;;
    sync)
        echo "🔄 Syncing repo with remote..."
        cd "$REPO_DIR"
        git add .
        git commit -m "chore: auto-sync documentation updates $(date)"
        git push origin main
        echo "✅ Sync complete."
        ;;
    status)
        echo "📊 Repo Status:"
        cd "$REPO_DIR"
        git status
        ;;
    *)
        echo "Usage: $0 {backup|sync|status}"
        exit 1
        ;;
esac
