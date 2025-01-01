#!/bin/bash

NAS_IP="xxx"
NAS_SHARE="//$NAS_IP/mount-point"
NAS_USERNAME="xxx"
NAS_PASSWORD="xxx"

MOUNT_BASE="/mnt/nas"
MOUNT_SHARE="$MOUNT_BASE/share"

MAX_RETRIES=8
RETRY_COUNT=0

is_mounted() {
  mountpoint -q "$1"
}

ensure_mount_point() {
  if [ ! -d "$1" ]; then
    echo "Creating mount point: $1"
    sudo mkdir -p "$1"
  fi
}

echo "Checking NAS connectivity..."
while ! ping -c 1 -W 1 "$NAS_IP" >/dev/null 2>&1; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "ERROR: Unable to contact NAS at $NAS_IP after $MAX_RETRIES attempts."
    exit 1
  fi
  echo "Attempt $RETRY_COUNT of $MAX_RETRIES: Waiting for network..."
  sleep 1
done

if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
  ensure_mount_point "$MOUNT_BASE"
  ensure_mount_point "$MOUNT_SHARE"

  if is_mounted "$MOUNT_SHARE"; then
    echo "Network share is already mounted at $MOUNT_SHARE"
  else
    echo "Mounting network share at $MOUNT_SHARE..."
    sudo mount -t cifs \
      -o username="$NAS_USERNAME",password="$NAS_PASSWORD",nounix,noserverino \
      "$NAS_SHARE/share" "$MOUNT_SHARE"

    if is_mounted "$MOUNT_SHARE"; then
      echo "Successfully mounted network share at $MOUNT_SHARE"

      NVIM_CONFIG_DIR="$HOME/.config/nvim"
      if [ ! -L "$NVIM_CONFIG_DIR" ]; then
        echo "Creating symlink for nvim config..."
        ln -s "$MOUNT_SHARE/nvim" "$NVIM_CONFIG_DIR"
        echo "Symlink created: $NVIM_CONFIG_DIR -> $MOUNT_SHARE/nvim"
      fi
    else
      echo "ERROR: Failed to mount network share"
      exit 1
    fi
  fi
else
  echo "ERROR: NAS unreachable, mount aborted"
  exit 1
fi
