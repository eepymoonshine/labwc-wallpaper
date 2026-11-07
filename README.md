# labwc-wallpaper

A small wallpaper setter for [labwc](https://labwc.github.io/) and other wlroots compositors. It sets the desktop background with [swaybg](https://github.com/swaywm/swaybg) and the lock screen with [swaylock](https://github.com/swaywm/swaylock).

It also implements the backend side of the xdg-desktop-portal [Wallpaper portal](https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.Wallpaper.html) (`org.freedesktop.impl.portal.Wallpaper`). Neither xdg-desktop-portal-wlr nor xdg-desktop-portal-gtk provides that interface outside GNOME, so on labwc "Set as background" in photo viewers does nothing. With this installed, it works in apps like gThumb, Loupe and Firefox, including Flatpaks.

## What it does

- When an app asks for a preview, it shows a dialog with the picture cropped to your screen's shape. There you choose **Desktop**, **Lock Screen** or **Both**.
- It copies the image to `~/.local/share/labwc-wallpaper/{desktop,lockscreen}`, so moving or deleting the original doesn't matter.
- It applies the EXIF rotation, so phone photos come out the right way up. swaybg and swaylock ignore that tag.
- It swaps swaybg without a black flash by starting the new instance before stopping the old one.

## Requirements

You need Python 3 with PyGObject, GTK 4, swaybg, swaylock, xdg-desktop-portal 1.18 or newer, and systemd. On Fedora:

```sh
sudo dnf install python3-gobject gtk4 swaybg swaylock
```

## Install

```sh
./install.sh
```

The script installs everything into `~/.local` and routes the Wallpaper portal to this backend in `~/.config/xdg-desktop-portal/<desktop>-portals.conf`. Then make two manual changes:

1. In `~/.config/labwc/autostart`, replace your `swaybg` line with:
   ```sh
   ~/.local/bin/labwc-wallpaper --restore >/dev/null 2>&1 &
   ```
2. In `~/.config/swaylock/config`, set:
   ```
   image=/home/YOU/.local/share/labwc-wallpaper/lockscreen
   ```

## Usage

From any app that uses the portal, choose its "Set as background" action. From a terminal:

```sh
labwc-wallpaper photo.jpg              # desktop and lock screen
labwc-wallpaper photo.jpg --on desktop
labwc-wallpaper photo.jpg --on lock
```

The first time an app sets the wallpaper, xdg-desktop-portal asks once whether to allow it.

## License

[MIT](LICENSE)
