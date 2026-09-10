#!/usr/bin/env python3
"""ストア用プロモスクリーンショット生成。
素のスクショをテーマ背景+キャッチコピー付きのストア規定サイズに加工する。
qlmanageが非正方形SVGを扱えないため、正方形でレンダリングして中央クロップする。

使い方:
  python3 make_promo_screenshots.py            # Google Play 用（1080x1920）
  python3 make_promo_screenshots.py ios        # App Store 6.9インチ用（1290x2796）
"""
import base64
import subprocess
import sys
from pathlib import Path

STORE = Path(__file__).parent

FONT = "Hiragino Sans, Hiragino Kaku Gothic ProN, sans-serif"


class Layout:
    """出力サイズごとのレイアウト定義。"""

    def __init__(self, w, h, shot_w, shot_h, font_1, font_2, font_2_long,
                 text_top, line_gap, accent_gap, shot_gap, radius, stroke,
                 accent_w, accent_h, dot_r):
        self.w, self.h = w, h
        self.canvas = h                 # 正方形レンダリングの一辺
        self.x0 = (h - w) // 2          # クロップ後に左端となるX
        self.shot_w, self.shot_h = shot_w, shot_h
        self.font_1, self.font_2, self.font_2_long = font_1, font_2, font_2_long
        self.text_top = text_top
        self.line_gap = line_gap
        self.accent_gap = accent_gap
        self.shot_gap = shot_gap
        self.radius, self.stroke = radius, stroke
        self.accent_w, self.accent_h = accent_w, accent_h
        self.dot_r = dot_r


# Google Play（1080x1920）— 元スクショは 1080x2424
PLAY = Layout(w=1080, h=1920, shot_w=646, shot_h=1450,
              font_1=76, font_2=72, font_2_long=64,
              text_top=150, line_gap=24, accent_gap=40, shot_gap=40,
              radius=40, stroke=5, accent_w=340, accent_h=6, dot_r=6)

# App Store 6.9インチ（1290x2796）— 元スクショは 1320x2868
IOS = Layout(w=1290, h=2796, shot_w=900, shot_h=1955,
             font_1=96, font_2=90, font_2_long=80,
             text_top=200, line_gap=30, accent_gap=54, shot_gap=60,
             radius=56, stroke=7, accent_w=420, accent_h=8, dot_r=8)


# (元ファイル, 出力名, キャプション行リスト)
PLAY_JOBS = [
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

IOS_JOBS = [
    ("ios_raw/ios_01_list.png", "promo_01_lists.png",
     ["数字だけじゃない", "好きなお題で、みんなでビンゴ。"]),
    ("ios_raw/ios_02_card.png", "promo_02_card.png",
     ["ワンタップで", "カードを自動生成"]),
    ("ios_raw/ios_03_draw.png", "promo_03_draw.png",
     ["司会者モードで", "抽選もおまかせ"]),
]


def build_svg(src, lines, lo):
    b64 = base64.b64encode(src.read_bytes()).decode()
    cx = lo.x0 + lo.w / 2
    shot_x = cx - lo.shot_w / 2

    n = len(lines)
    if n == 1:
        size = lo.font_1
    else:
        size = lo.font_2 if max(len(s) for s in lines) <= 12 else lo.font_2_long

    text_elems = []
    for i, line in enumerate(lines):
        y = lo.text_top + (i + 1) * (size + lo.line_gap)
        text_elems.append(
            f'<text x="{cx}" y="{y}" font-family="{FONT}" font-size="{size}" '
            f'font-weight="800" fill="#F5F0E8" text-anchor="middle">{line}</text>'
        )

    base = lo.font_2 if n > 1 else lo.font_1
    accent_y = lo.text_top + n * (base + lo.line_gap) + lo.accent_gap
    shot_y = accent_y + lo.shot_gap

    c = lo.canvas
    return f'''<svg width="{c}" height="{c}" viewBox="0 0 {c} {c}" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#243058"/>
      <stop offset="1" stop-color="#0F1629"/>
    </linearGradient>
    <clipPath id="shot">
      <rect x="{shot_x}" y="{shot_y}" width="{lo.shot_w}" height="{lo.shot_h}" rx="{lo.radius}"/>
    </clipPath>
  </defs>
  <rect width="{c}" height="{c}" fill="url(#bg)"/>
  <g fill="#D4AF37" opacity="0.5">
    <circle cx="{lo.x0 + 90}" cy="120" r="{lo.dot_r}"/>
    <circle cx="{lo.x0 + lo.w - 80}" cy="160" r="{lo.dot_r - 1}"/>
    <circle cx="{lo.x0 + 70}" cy="{lo.h - 220}" r="{lo.dot_r - 1}"/>
    <circle cx="{lo.x0 + lo.w - 90}" cy="{lo.h - 160}" r="{lo.dot_r}"/>
  </g>
  {''.join(text_elems)}
  <rect x="{cx - lo.accent_w / 2}" y="{accent_y}" width="{lo.accent_w}" height="{lo.accent_h}" rx="{lo.accent_h / 2}" fill="#CC3333"/>
  <image x="{shot_x}" y="{shot_y}" width="{lo.shot_w}" height="{lo.shot_h}"
         clip-path="url(#shot)" xlink:href="data:image/png;base64,{b64}"/>
  <rect x="{shot_x}" y="{shot_y}" width="{lo.shot_w}" height="{lo.shot_h}" rx="{lo.radius}"
        fill="none" stroke="#D4AF37" stroke-width="{lo.stroke}"/>
</svg>'''


def render(jobs, lo, out_dir):
    out_dir.mkdir(exist_ok=True)
    for src_name, out_name, lines in jobs:
        src = STORE / src_name
        svg_path = Path("/tmp") / (out_name.replace(".png", f"_{lo.w}.svg"))
        svg_path.write_text(build_svg(src, lines, lo))
        subprocess.run(["qlmanage", "-t", "-s", str(lo.canvas), "-o", "/tmp", str(svg_path)],
                       check=True, capture_output=True)
        rendered = Path("/tmp") / (svg_path.name + ".png")
        subprocess.run(["sips", "-c", str(lo.h), str(lo.w), str(rendered),
                        "--out", str(out_dir / out_name)],
                       check=True, capture_output=True)
        print(f"{out_name} ✓")
    print("done:", out_dir)


if __name__ == "__main__":
    platform = sys.argv[1] if len(sys.argv) > 1 else "play"
    if platform == "ios":
        render(IOS_JOBS, IOS, STORE / "promo_ios")
    else:
        render(PLAY_JOBS, PLAY, STORE / "promo")
