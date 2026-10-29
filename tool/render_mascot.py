"""Render mascot SVGs to PNG for review and export.

  python3 tool/render_mascot.py                 # preview sheet -> build/mascot_preview.png
  python3 tool/render_mascot.py --zoom mascot_fresh   # one file at 640px -> build/zoom_<name>.png
  python3 tool/render_mascot.py --export        # PNG @1x/@2x/@3x + icon 1024 -> build/png/
  python3 tool/render_mascot.py --icons         # assets/icon/*.svg -> 1024 PNG (+ monochrome) cho launcher icon/splash

Requires: pip install cairosvg pillow
(Windows: run inside WSL, or install the GTK3 runtime so cairosvg can find libcairo.)
"""
import argparse
import glob
import os

import cairosvg
from PIL import Image, ImageDraw

SRC = "assets/mascot"
BUILD = "build"


def render(svg_path, size):
    tmp = os.path.join(BUILD, "_tmp.png")
    cairosvg.svg2png(url=svg_path, write_to=tmp, output_width=size, output_height=size)
    return Image.open(tmp).convert("RGBA")


def preview(size=320):
    files = sorted(glob.glob(f"{SRC}/*.svg"))
    # icons first, then states in a stable order
    files.sort(key=lambda p: (not os.path.basename(p).startswith("app_icon"), p))
    sheet = Image.new("RGBA", (size * len(files), size + 28), (255, 255, 255, 255))
    draw = ImageDraw.Draw(sheet)
    for i, f in enumerate(files):
        im = render(f, size)
        sheet.alpha_composite(im, (size * i, 0))
        # frame edge guide: anything touching this box is clipped in the app
        draw.rectangle([size * i, 0, size * i + size - 1, size - 1], outline=(230, 230, 230))
        draw.text((size * i + 8, size + 8), os.path.basename(f), fill=(90, 34, 51))
    out = os.path.join(BUILD, "mascot_preview.png")
    sheet.save(out)
    print(out)


def zoom(name):
    out = os.path.join(BUILD, f"zoom_{name}.png")
    render(f"{SRC}/{name}.svg", 640).save(out)
    print(out)


def export():
    d = os.path.join(BUILD, "png")
    os.makedirs(d, exist_ok=True)
    for f in glob.glob(f"{SRC}/*.svg"):
        name = os.path.splitext(os.path.basename(f))[0]
        for k in (1, 2, 3):
            render(f, 256 * k).save(os.path.join(d, f"{name}@{k}x.png"))
        if name.startswith("app_icon"):
            render(f, 1024).save(os.path.join(d, f"{name}_1024.png"))
    print(d)


def icons():
    """PNG nguồn cho flutter_launcher_icons / flutter_native_splash (cấu hình trong pubspec.yaml)."""
    d = "assets/icon"
    for f in sorted(glob.glob(f"{d}/*.svg")):
        name = os.path.splitext(os.path.basename(f))[0]
        im = render(f, 1024)
        if name == "icon_full":
            im = im.convert("RGB")  # App Store từ chối icon có kênh alpha
        im.save(os.path.join(d, f"{name}.png"))
        if name == "icon_foreground":
            # themed icon Android 13+: 1 màu, hệ thống tự tô. Giữ nét viền + mắt + miệng (pixel tối)
            # để vẫn nhận ra mặt Upa, thay vì một khối bóng trơn.
            dark = im.convert("L").point(lambda v: 255 if v < 110 else 0)
            alpha = Image.composite(dark, Image.new("L", im.size, 0), im.getchannel("A"))
            mono = Image.new("RGBA", im.size, (255, 255, 255, 0))
            mono.putalpha(alpha)
            mono.save(os.path.join(d, "icon_monochrome.png"))
    print(d, sorted(os.listdir(d)))


if __name__ == "__main__":
    os.makedirs(BUILD, exist_ok=True)
    ap = argparse.ArgumentParser()
    ap.add_argument("--zoom")
    ap.add_argument("--export", action="store_true")
    ap.add_argument("--icons", action="store_true")
    a = ap.parse_args()
    if a.zoom:
        zoom(a.zoom)
    elif a.export:
        export()
    elif a.icons:
        icons()
    else:
        preview()
