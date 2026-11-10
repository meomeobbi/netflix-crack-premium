#!/usr/bin/env python3
"""Generate Gemini assets for the GeminiPro prank app:
- Gemini sparkle logo (gradient 4-point star, transparent PNG)
- App icon (sparkle on white) in all iOS sizes
- gemini_sparkle.imageset for the splash screen
- Filler wallpaper PNGs so the IPA lands ~25-30 MB
"""
import os, json
import numpy as np
from PIL import Image, ImageDraw

BASE = os.path.dirname(os.path.abspath(__file__))
ASSETS = os.path.join(BASE, "Sources", "Assets.xcassets")
ICONSET = os.path.join(ASSETS, "AppIcon.appiconset")
SPARKLE_SET = os.path.join(ASSETS, "gemini_sparkle.imageset")
RES = os.path.join(BASE, "Resources")
os.makedirs(SPARKLE_SET, exist_ok=True)
os.makedirs(RES, exist_ok=True)

# ---------------- Gemini gradient ----------------
STOPS = [
    (0.0, (66, 133, 244)),    # blue
    (0.45, (155, 114, 203)),  # purple
    (1.0, (232, 113, 138)),   # pink
]
stops_t = np.array([s[0] for s in STOPS])
stops_c = np.array([s[1] for s in STOPS], dtype=float)

def gradient_image(size):
    yy, xx = np.mgrid[0:size, 0:size]
    t = (xx + yy) / (2.0 * size)
    r = np.interp(t, stops_t, stops_c[:, 0])
    g = np.interp(t, stops_t, stops_c[:, 1])
    b = np.interp(t, stops_t, stops_c[:, 2])
    return Image.fromarray(np.stack([r, g, b], axis=-1).astype(np.uint8), "RGB")

# ---------------- sparkle shape ----------------
def quad(p0, p1, p2, t):
    x = (1 - t) ** 2 * p0[0] + 2 * (1 - t) * t * p1[0] + t * t * p2[0]
    y = (1 - t) ** 2 * p0[1] + 2 * (1 - t) * t * p1[1] + t * t * p2[1]
    return (x, y)

def sparkle_outline(size, R, n=80):
    cx = cy = size / 2
    pts = [(cx, cy - R), (cx + R, cy), (cx, cy + R), (cx - R, cy)]
    outline = []
    for i in range(4):
        p0 = pts[i]
        p2 = pts[(i + 1) % 4]
        p1 = (cx, cy)
        for j in range(n):
            outline.append(quad(p0, p1, p2, j / n))
    return outline

SIZE = 1024
grad = gradient_image(SIZE)
mask = Image.new("L", (SIZE, SIZE), 0)
ImageDraw.Draw(mask).polygon(sparkle_outline(SIZE, 452), fill=255)
sparkle = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
sparkle.paste(grad, (0, 0), mask)

sparkle_path = os.path.join(SPARKLE_SET, "gemini_sparkle.png")
sparkle.save(sparkle_path)
print("sparkle:", sparkle_path, os.path.getsize(sparkle_path), "bytes")

with open(os.path.join(SPARKLE_SET, "Contents.json"), "w") as f:
    json.dump({
        "images": [
            {"filename": "gemini_sparkle.png", "idiom": "universal", "scale": "1x"},
            {"filename": "gemini_sparkle.png", "idiom": "universal", "scale": "2x"},
            {"filename": "gemini_sparkle.png", "idiom": "universal", "scale": "3x"},
        ],
        "info": {"author": "xcode", "version": 1},
    }, f, indent=2)

# ---------------- app icon: sparkle on white ----------------
icon_base = Image.new("RGB", (1024, 1024), (255, 255, 255))
sp = sparkle.resize((740, 740), Image.LANCZOS)
icon_base.paste(sp, ((1024 - 740) // 2, (1024 - 740) // 2), sp)
icon_sizes = {
    "AppIcon-1024.png": 1024,
    "AppIcon-180.png": 180,
    "AppIcon-120.png": 120,
    "AppIcon-120-spot.png": 120,
    "AppIcon-87.png": 87,
    "AppIcon-80.png": 80,
    "AppIcon-60.png": 60,
    "AppIcon-58.png": 58,
    "AppIcon-40.png": 40,
    "AppIcon-29.png": 29,
}
for name, px in icon_sizes.items():
    im = icon_base.resize((px, px), Image.LANCZOS) if px != 1024 else icon_base
    im.save(os.path.join(ICONSET, name))
print("icons written")

# ---------------- filler wallpapers to reach ~26 MB ----------------
TARGET_FILLER = 26 * 1024 * 1024
total = 0
idx = 1
rng = np.random.default_rng(7)
while total < TARGET_FILLER and idx <= 10:
    size = 1600
    c1 = rng.integers(0, 255, 3).astype(float)
    c2 = rng.integers(0, 255, 3).astype(float)
    yy, xx = np.mgrid[0:size, 0:size]
    t = (xx + yy) / (2.0 * size)
    base = np.zeros((size, size, 3), dtype=float)
    for ch in range(3):
        base[..., ch] = c1[ch] * (1 - t) + c2[ch] * t
    noise = rng.integers(-45, 46, size=(size, size, 3))
    arr = np.clip(base + noise, 0, 255).astype(np.uint8)
    img = Image.fromarray(arr, "RGB")
    path = os.path.join(RES, f"gemini_wallpaper_{idx}.png")
    img.save(path, optimize=False)
    sz = os.path.getsize(path)
    total += sz
    print(f"filler {idx}: {sz/1024/1024:.2f} MB  (total {total/1024/1024:.2f} MB)")
    idx += 1
print(f"TOTAL filler: {total/1024/1024:.2f} MB")
