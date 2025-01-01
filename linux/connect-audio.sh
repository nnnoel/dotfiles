#!/bin/bash

HEADPHONES_MAC="xxx"
SPEAKERS_MAC="xxx"

SOUND_FILE="/usr/share/sounds/alsa/Front_Center.wav"

if [[ "$1" == "headphones" ]]; then
  DEVICE_MAC=$HEADPHONES_MAC
  DEVICE_NAME="Headphones"
elif [[ "$1" == "speakers" ]]; then
  DEVICE_MAC=$SPEAKERS_MAC
  DEVICE_NAME="Speakers"
else
  echo "Usage: $0 {headphones|speakers}"
  exit 1
fi

run_bluetoothctl() {
  echo -e "$1" | bluetoothctl >/dev/null 2>&1
}
echo "Ensuring $DEVICE_NAME are disconnected before connecting..."
run_bluetoothctl "disconnect $DEVICE_MAC"
sleep 4

echo "Attempting to connect to $DEVICE_NAME..."
run_bluetoothctl "connect $DEVICE_MAC"
sleep 4

if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes" >/dev/null 2>&1; then
  echo "$DEVICE_NAME connected successfully!"
else
  echo "Failed to connect to $DEVICE_NAME. Exiting."
  exit 1
fi

sleep 2
echo "Playing test sound..."
pw-play "$SOUND_FILE"

echo "Sound playback complete for $DEVICE_NAME."
