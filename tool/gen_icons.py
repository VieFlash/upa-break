"""Sinh icon app Android + iOS từ assets/upa_assets. Cần Pillow. Chạy từ thư mục gốc:
    python3 tool/gen_icons.py"""
import json
import os

from PIL import Image

SRC = 'assets/upa_assets'
RES = 'android/app/src/main/res'
DENSITIES = dict(mdpi=1, hdpi=1.5, xhdpi=2, xxhdpi=3, xxxhdpi=4)

icon = Image.open(f'{SRC}/app_icon_1024.png').convert('RGBA')
fg = Image.open(f'{SRC}/app_icon_foreground_1024.png').convert('RGBA')
bg = icon.getpixel((512, 940))[:3]  # màu nền gần tâm dưới của icon

# Android legacy launcher (< API 26): giữ góc bo trong suốt.
for d, k in DENSITIES.items():
    icon.resize((round(48 * k),) * 2, Image.LANCZOS).save(f'{RES}/mipmap-{d}/ic_launcher.png')

# Android adaptive icon (API 26+): foreground 108dp + nền màu đặc.
for d, k in DENSITIES.items():
    fg.resize((round(108 * k),) * 2, Image.LANCZOS).save(f'{RES}/mipmap-{d}/ic_launcher_foreground.png')
os.makedirs(f'{RES}/mipmap-anydpi-v26', exist_ok=True)
with open(f'{RES}/mipmap-anydpi-v26/ic_launcher.xml', 'w') as f:
    f.write('''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
''')
with open(f'{RES}/values/ic_launcher_background.xml', 'w') as f:
    f.write('''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#%02X%02X%02X</color>
</resources>
''' % bg)

# iOS: không được có alpha -> tô góc bằng màu nền (iOS tự bo góc).
flat = Image.new('RGB', icon.size, icon.getpixel((512, 6))[:3])
flat.paste(icon, mask=icon.split()[3])
d = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for img in json.load(open(f'{d}/Contents.json'))['images']:
    if 'filename' not in img:
        continue
    px = round(float(img['size'].split('x')[0]) * int(img['scale'][0]))
    flat.resize((px, px), Image.LANCZOS).save(f'{d}/{img["filename"]}')

print('✓ icon Android + iOS, nền adaptive #%02X%02X%02X' % bg)
