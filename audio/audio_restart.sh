#!/bin/bash
set -x #echo on

#systemctl --user restart pulseaudio

systemctl --user restart pipewire pipewire-pulse
systemctl --user daemon-reload

