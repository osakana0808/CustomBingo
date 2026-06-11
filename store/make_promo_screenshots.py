#!/usr/bin/env python3
"""ストア用プロモスクリーンショット生成。
素のスクショ(1080x2424)をテーマ背景+キャッチコピー付きの1080x1920に加工する。
qlmanageが非正方形SVGを扱えないため、1920x1920でレンダリングして中央クロップする。
"""
import base64
import subprocess
import sys
from pathlib import Path

STORE = Path(__file__).parent
OUT = STORE / "promo"
OUT.mkdir(exist_ok=True)

# (元ファイル, 出力名, キャプション行リスト)
JOBS = [
    ("Screenshot_20260611_155739.png", "promo_01_lists.png",
     ["数字だけじゃない", "好きなお題で、みんなでビンゴ。"]),
    ("Screenshot_20260611_155755.png", "promo_02_edit.png",
     ["お題リストを", "自由に作成"]),
    ("Screenshot_20260611_155834.png", "promo_03_import.png",
     ["テキストを貼り付けるだけ", "リストをカンタン共有"]),
    ("Screenshot_20260611_155855.png", "promo_04_card.png",
     ["ワンタップで", "カードを自動生成"]),
    ("Screenshot_20260611_155921.png", "promo_05_draw.png",
     ["ワンタップで", "カンタン抽選"]),
]

# 1920x1920キャンバス内の1080x1920領域(x: 420..1500)に配置
X0 = 420            # クロップ後に左端となるX
W, H = 1080, 1920   # 最終サイズ
SHOT_W, SHOT_H = 646, 1450  # スクショ表示サイズ(元比率1080:2424を維持)

def build_svg(src, lines):
    b64 = base64.b64encode(src.read_bytes()).decode()
    cx = X0 + W / 2
    shot_x = cx - SHOT_W / 2
    font = "Hiragino Sans, Hiragino Kaku Gothic ProN, sans-serif"
    text_elems = []
    n = len(lines)
    for i, line in enumerate(lines):
        size = 76 if n == 1 else (72 if max(len(s) for s in lines) <= 12 else 64)
        y = 150 + (i + 1) * (size + 24)
        text_elems.append(
            f'<text x="{cx}" y="{y}" font-family="{font}" font-size="{size}" '
            f'font-weight="800" fill="#F5F0E8" text-anchor="middle">{line}</text>'
        )
    accent_y = 150 + n * ((72 if n > 1 else 76) + 24) + 40
    shot_y = accent_y + 40
    return f'''<svg width="1920" height="1920" viewBox="0 0 1920 1920" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#243058"/>
      <stop offset="1" stop-color="#0F1629"/>
    </linearGradient>
    <clipPath id="shot">
      <rect x="{shot_x}" y="{shot_y}" width="{SHOT_W}" height="{SHOT_H}" rx="40"/>
    </clipPath>
  </defs>
  <rect width="1920" height="1920" fill="url(#bg)"/>
  <g fill="#D4AF37" opacity="0.5">
    <circle cx="{X0 + 90}" cy="120" r="6"/>
    <circle cx="{X0 + W - 80}" cy="160" r="5"/>
    <circle cx="{X0 + 70}" cy="1700" r="5"/>
    <circle cx="{X0 + W - 90}" cy="1760" r="6"/>
  </g>
  {''.join(text_elems)}
  <rect x="{cx - 170}" y="{accent_y}" width="340" height="6" rx="3" fill="#CC3333"/>
  <image x="{shot_x}" y="{shot_y}" width="{SHOT_W}" height="{SHOT_H}"
         clip-path="url(#shot)" xlink:href="data:image/png;base64,{b64}"/>
  <rect x="{shot_x}" y="{shot_y}" width="{SHOT_W}" height="{SHOT_H}" rx="40"
        fill="none" stroke="#D4AF37" stroke-width="5"/>
</svg>'''

for src_name, out_name, lines in JOBS:
    src = STORE / src_name
    svg_path = Path("/tmp") / (out_name.replace(".png", ".svg"))
    svg_path.write_text(build_svg(src, lines))
    subprocess.run(["qlmanage", "-t", "-s", "1920", "-o", "/tmp", str(svg_path)],
                   check=True, capture_output=True)
    rendered = Path("/tmp") / (svg_path.name + ".png")
    subprocess.run(["sips", "-c", str(H), str(W), str(rendered),
                    "--out", str(OUT / out_name)],
                   check=True, capture_output=True)
    print(f"{out_name} ✓")

print("done:", OUT)
