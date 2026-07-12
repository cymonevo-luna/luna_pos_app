#!/usr/bin/env python3
"""Generate assets/marketing/pos-app-mockup.png for the web landing page."""

from __future__ import annotations

import os
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "assets" / "marketing" / "pos-app-mockup.png"
FOOD_ASSET = ROOT / "assets" / "images" / "default_food.png"

WIDTH, HEIGHT = 750, 1400
PRIMARY = (47, 107, 237)
SCAFFOLD = (244, 246, 248)
SURFACE = (255, 255, 255)
TEXT = (17, 24, 39)
MUTED = (107, 114, 128)
BORDER = (229, 232, 236)
RADIUS = 24


def load_font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
    ]
    for path in candidates:
        if os.path.exists(path):
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def rounded_rect(
    draw: ImageDraw.ImageDraw,
    xy: tuple[int, int, int, int],
    radius: int,
    fill: tuple[int, int, int],
    outline: tuple[int, int, int] | None = None,
) -> None:
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=1 if outline else 0)


def paste_cover(base: Image.Image, overlay: Image.Image, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    target_w, target_h = x1 - x0, y1 - y0
    scale = max(target_w / overlay.width, target_h / overlay.height)
    resized = overlay.resize(
        (int(overlay.width * scale), int(overlay.height * scale)),
        Image.Resampling.LANCZOS,
    )
    left = (resized.width - target_w) // 2
    top = (resized.height - target_h) // 2
    cropped = resized.crop((left, top, left + target_w, top + target_h))
    base.paste(cropped, (x0, y0))


def draw_menu_card(
    img: Image.Image,
    draw: ImageDraw.ImageDraw,
    food: Image.Image,
    x: int,
    y: int,
    w: int,
    h: int,
    title: str,
    price: str,
    stock: str,
) -> None:
    rounded_rect(draw, (x, y, x + w, y + h), RADIUS, SURFACE, BORDER)
    photo_h = int(h * 0.58)
    paste_cover(img, food, (x + 2, y + 2, x + w - 2, y + photo_h))
    draw.rounded_rectangle((x + 2, y + 2, x + w - 2, y + photo_h), radius=RADIUS, outline=None)
    title_font = load_font(28, bold=True)
    price_font = load_font(24, bold=True)
    stock_font = load_font(20)
    text_x = x + 18
    draw.text((text_x, y + photo_h + 14), title, fill=TEXT, font=title_font)
    draw.text((text_x, y + photo_h + 48), price, fill=PRIMARY, font=price_font)
    draw.text((text_x, y + photo_h + 78), stock, fill=MUTED, font=stock_font)


def main() -> None:
    img = Image.new("RGB", (WIDTH, HEIGHT), SCAFFOLD)
    draw = ImageDraw.Draw(img)
    food = Image.open(FOOD_ASSET).convert("RGB")

    title_font = load_font(42, bold=True)
    label_font = load_font(24)
    total_font = load_font(34, bold=True)
    button_font = load_font(30, bold=True)

    # App bar
    draw.rectangle((0, 0, WIDTH, 120), fill=SCAFFOLD)
    draw.text((36, 42), "Menu", fill=TEXT, font=title_font)

    cart_x, cart_y = WIDTH - 96, 34
    rounded_rect(draw, (cart_x, cart_y, cart_x + 56, cart_y + 56), 16, SURFACE, BORDER)
    draw.text((cart_x + 14, cart_y + 12), "🛒", fill=TEXT, font=load_font(24))
    badge_font = load_font(18, bold=True)
    draw.ellipse((cart_x + 34, cart_y - 4, cart_x + 58, cart_y + 20), fill=PRIMARY)
    draw.text((cart_x + 42, cart_y - 1), "3", fill=SURFACE, font=badge_font, anchor="mm")

    # Section: Mains
    section_font = load_font(30, bold=True)
    draw.text((36, 148), "Mains", fill=TEXT, font=section_font)

    gap = 18
    card_w = (WIDTH - 36 * 2 - gap) // 2
    card_h = 290
    mains = [
        ("Nasi Goreng", "Rp 35.000", "Stock: 12"),
        ("Mie Goreng", "Rp 30.000", "Stock: 8"),
        ("Ayam Bakar", "Rp 40.000", "Stock: 6"),
        ("Sate Ayam", "Rp 25.000", "Stock: 10"),
    ]
    y = 196
    for i, item in enumerate(mains):
        col = i % 2
        row = i // 2
        x = 36 + col * (card_w + gap)
        cy = y + row * (card_h + gap)
        draw_menu_card(img, draw, food, x, cy, card_w, card_h, *item)

    # Section: Drinks
    drinks_y = y + 2 * (card_h + gap) + 36
    draw.text((36, drinks_y), "Drinks", fill=TEXT, font=section_font)
    drinks = [
        ("Es Teh", "Rp 5.000", "Stock: 20"),
        ("Es Jeruk", "Rp 8.000", "Stock: 15"),
    ]
    dy = drinks_y + 48
    for i, item in enumerate(drinks):
        x = 36 + i * (card_w + gap)
        draw_menu_card(img, draw, food, x, dy, card_w, card_h, *item)

    # Order bar
    bar_h = 220
    bar_y = HEIGHT - bar_h
    draw.rectangle((0, bar_y, WIDTH, HEIGHT), fill=SURFACE)
    draw.line((0, bar_y, WIDTH, bar_y), fill=BORDER, width=2)
    draw.text((36, bar_y + 24), "3 items", fill=MUTED, font=label_font)
    draw.text((36, bar_y + 62), "Order total", fill=TEXT, font=total_font)
    draw.text((WIDTH - 36, bar_y + 62), "Rp 100.000", fill=PRIMARY, font=total_font, anchor="ra")

    btn_y = bar_y + 118
    rounded_rect(draw, (36, btn_y, WIDTH - 36, btn_y + 72), 20, PRIMARY)
    draw.text((WIDTH // 2, btn_y + 36), "Checkout", fill=SURFACE, font=button_font, anchor="mm")

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    img.save(OUTPUT, format="PNG", optimize=True)
    print(f"Wrote {OUTPUT} ({OUTPUT.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
