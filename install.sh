#!/bin/sh
# Install labwc-wallpaper for the current user (no root needed).
set -eu

cd "$(dirname "$0")"
BINDIR="${BINDIR:-$HOME/.local/bin}"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
CONF="${XDG_CONFIG_HOME:-$HOME/.config}"
DESKTOP="$(printf '%s' "${XDG_CURRENT_DESKTOP:-labwc}" | cut -d: -f1 | tr '[:upper:]' '[:lower:]')"
PORTALS_CONF="$CONF/xdg-desktop-portal/$DESKTOP-portals.conf"

install -Dm755 labwc-wallpaper "$BINDIR/labwc-wallpaper"
install -Dm644 labwc-wallpaper.portal "$DATA/xdg-desktop-portal/portals/labwc-wallpaper.portal"
mkdir -p "$DATA/dbus-1/services"
sed "s|@BINDIR@|$BINDIR|" org.freedesktop.impl.portal.desktop.labwcwallpaper.service.in \
    > "$DATA/dbus-1/services/org.freedesktop.impl.portal.desktop.labwcwallpaper.service"

# Route the Wallpaper portal to this backend.
mkdir -p "$(dirname "$PORTALS_CONF")"
if [ ! -f "$PORTALS_CONF" ]; then
    printf '[preferred]\ndefault=gtk\n' > "$PORTALS_CONF"
fi
if ! grep -q '^org.freedesktop.impl.portal.Wallpaper=' "$PORTALS_CONF"; then
    printf 'org.freedesktop.impl.portal.Wallpaper=labwc-wallpaper\n' >> "$PORTALS_CONF"
fi

systemctl --user restart xdg-desktop-portal.service 2>/dev/null || true

cat <<EOF
Installed. Two manual steps left:

1. In your compositor autostart (e.g. ~/.config/labwc/autostart), replace your swaybg line with:
     $BINDIR/labwc-wallpaper --restore >/dev/null 2>&1 &

2. In ~/.config/swaylock/config, set:
     image=$DATA/labwc-wallpaper/lockscreen

Then set a first wallpaper:  labwc-wallpaper /path/to/image.jpg --on both
EOF
