"""Hình minh họa bài tập (T2.2): mỗi bài 2-3 khung SVG -> assets/exercises/<id>_<n>.svg.

Một "người văn phòng" cách điệu tạo dáng bằng khung xương (khớp vai/khuỷu/tay/hông/gối/chân) + đạo cụ
(ghế, bàn, màn hình) + mũi tên chỉ chuyển động + Upa nhỏ ở góc làm theo. Cùng phong cách sticker với mascot:
viền C["line"], cel-shading bóng dưới-phải, khung 256. Ưu tiên ĐÚNG ĐỘNG TÁC hơn dễ thương.

Chạy từ gốc project:  python3 tool/gen_exercises.py
Xem trước:            python3 tool/render_mascot.py --exercises   -> build/exercises_preview.png
"""
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from gen_mascot import C, Svg, capsule, circle_d, eyes, f, gills, hat, head, mouth, strap  # noqa: E402

OUT = "assets/exercises"

# bảng màu người + đạo cụ (base, shade, light) - cùng công thức với bảng màu mascot
P = dict(
    skin=("#F7C9A8", "#E3A47F", "#FFE4D2"),
    hair=("#5A3A4A", "#45293A", "#7A5468"),
    shirt=("#7FB0FF", C["blue"], "#B9D3FF"),
    pants=("#5E6382", "#474B66", "#7C81A0"),
    shoe=("#4A3A44", "#35282F", "#6A5762"),
    chair=("#D9C6B0", "#B8A189", "#EFE2D2"),
    desk=("#EAD3AE", "#CDB086", "#F7E9D2"),
    screen=("#5E6382", "#474B66", "#8C91B0"),
    arrow="#FF7A45",
)
OW = 5  # viền người/đạo cụ (mảnh hơn mascot một chút vì hình nhiều chi tiết)


# ---------------------------------------------------------------- primitives
def part(svg, d, col, ow=OW, off=(-2.5, -3), hl=None):
    """Khối tô cel-shading theo bảng màu P[...] (base, shade, light)."""
    base, shade, light = col
    return svg.shaded(d, base, shade, off=off, ow=ow, hl=[(*h, light, .9) for h in (hl or [])])


def limb(svg, pts, r, col, ow=OW):
    """Chi nhiều đoạn (vai-khuỷu-tay, hông-gối-chân) vẽ thành MỘT khối liền: viền chung ở dưới, rồi tô từng đoạn."""
    segs = [capsule(*pts[i], *pts[i + 1], r) for i in range(len(pts) - 1)]
    s = "".join(f'<path d="{d}" fill="{C["line"]}" stroke="{C["line"]}" stroke-width="{ow * 2}" '
                f'stroke-linejoin="round"/>' for d in segs)
    base, shade, _ = col
    for d in segs:
        cid = svg.uid("l")
        svg.defs.append(f'<clipPath id="{cid}"><path d="{d}"/></clipPath>')
        s += (f'<path d="{d}" fill="{shade}"/><g clip-path="url(#{cid})">'
              f'<path d="{d}" fill="{base}" transform="translate(-2 -2.5)"/></g>')
    return s


def ball(svg, x, y, r, col, ow=OW):
    return part(svg, circle_d(x, y, r), col, ow=ow, off=(-1.5, -2))


def _arrow(d, end, tangent, col=P["arrow"], w=5.5):
    """Vẽ đường [d] có đầu mũi tên ở [end] theo hướng [tangent]."""
    x1, y1 = end
    L = math.hypot(*tangent) or 1
    ux, uy = tangent[0] / L, tangent[1] / L
    nx, ny = -uy, ux
    hw, back = 8, 5
    tip = (x1 + ux * 6, y1 + uy * 6)
    a = (x1 - ux * back + nx * hw, y1 - uy * back + ny * hw)
    b = (x1 - ux * back - nx * hw, y1 - uy * back - ny * hw)
    head_d = f"M{f(tip[0])} {f(tip[1])} L{f(a[0])} {f(a[1])} L{f(b[0])} {f(b[1])} Z"
    return (f'<path d="{d}" stroke="{C["line"]}" stroke-width="{w + 5}" stroke-linecap="round" fill="none"/>'
            f'<path d="{head_d}" fill="{C["line"]}" stroke="{C["line"]}" stroke-width="5" stroke-linejoin="round"/>'
            f'<path d="{d}" stroke="{col}" stroke-width="{w}" stroke-linecap="round" fill="none"/>'
            f'<path d="{head_d}" fill="{col}"/>')


def arrow(pts, curve=None, **kw):
    """Mũi tên chỉ chuyển động: thẳng pts[0]->pts[1], hoặc cong qua điểm điều khiển [curve]."""
    (x0, y0), (x1, y1) = pts
    d = f"M{f(x0)} {f(y0)} " + (f"Q{f(curve[0])} {f(curve[1])} " if curve else "L") + f"{f(x1)} {f(y1)}"
    t = (x1 - curve[0], y1 - curve[1]) if curve else (x1 - x0, y1 - y0)
    return _arrow(d, (x1, y1), t, **kw)


def arc_arrow(c, r, a0, a1, **kw):
    """Mũi tên vòng cung quanh tâm [c], từ góc a0 tới a1 (độ, 0 = phải, 90 = xuống; a1 > a0 = chiều kim đồng hồ)."""
    cx, cy = c
    p = lambda a: (cx + r * math.cos(math.radians(a)), cy + r * math.sin(math.radians(a)))
    (x0, y0), (x1, y1) = p(a0), p(a1)
    sweep = 1 if a1 > a0 else 0
    large = 1 if abs(a1 - a0) > 180 else 0
    d = f"M{f(x0)} {f(y0)} A{r} {r} 0 {large} {sweep} {f(x1)} {f(y1)}"
    k = 1 if sweep else -1
    t = (-math.sin(math.radians(a1)) * k, math.cos(math.radians(a1)) * k)
    return _arrow(d, (x1, y1), t, **kw)


def ground():
    return f'<ellipse cx="128" cy="247" rx="84" ry="6" fill="{C["line"]}" opacity=".12"/>'


def upa_badge(svg, happy=False, x=210, y=30, s=.2):
    """Upa nhỏ ở góc trên-phải làm theo (đổi biểu cảm giữa các khung)."""
    face = gills(svg) + head(svg) + eyes(svg, "happy" if happy else "open") + mouth(svg, "open" if happy else "smile") \
        + strap() + hat(svg)
    return f'<g transform="translate({x - 128 * s} {y - 100 * s}) scale({s})">{face}</g>'


# ---------------------------------------------------------------- head
def head_person(svg, c, facing="front", tilt=0, look="open", pivot=None):
    """Đầu người: tròn, tóc ngắn, mặt đơn giản. facing: front | left | right; look: open | closed | up | down."""
    x, y = c
    r = 21
    s = ball(svg, x, y, r, P["skin"])
    # tóc: chỏm trên + mái, lệch theo hướng mặt
    if facing == "front":
        hair = (f"M{x - r - 1} {y - 2} C{x - r} {y - r - 8} {x + r} {y - r - 8} {x + r + 1} {y - 2} "
                f"C{x + 12} {y - 12} {x - 4} {y - 14} {x - r - 1} {y - 2} Z")
    else:
        k = 1 if facing == "right" else -1  # mặt hướng về phía k
        hair = (f"M{x - k * (r + 1)} {y + 6} C{x - k * (r + 4)} {y - r - 6} {x + k * (r - 2)} {y - r - 8} "
                f"{x + k * (r - 2)} {y - 8} C{x + k * 4} {y - 14} {x - k * 6} {y - 8} {x - k * 8} {y + 2} "
                f"C{x - k * 12} {y + 8} {x - k * (r - 2)} {y + 10} {x - k * (r + 1)} {y + 6} Z")
    s += part(svg, hair, P["hair"], ow=4.5, off=(-1.5, -1.5))
    lw = f'stroke="{C["line"]}" stroke-width="3.2" stroke-linecap="round" fill="none"'
    dy = {"up": -4, "down": 3}.get(look, 0)
    eye_xs = (x - 8, x + 8) if facing == "front" else ((x + 10,) if facing == "right" else (x - 10,))
    for ex in eye_xs:
        if look == "closed":
            s += f'<path d="M{ex - 4} {y + 3} Q{ex} {y + 7} {ex + 4} {y + 3}" {lw}/>'
        else:
            s += f'<circle cx="{ex}" cy="{y + 2 + dy}" r="3" fill="{C["line"]}"/>'
    if facing == "front":
        s += f'<path d="M{x - 6} {y + 11} Q{x} {y + 16} {x + 6} {y + 11}" {lw}/>'
        s += (f'<ellipse cx="{x - 13}" cy="{y + 9}" rx="5" ry="3" fill="{C["cheek"]}" opacity=".35"/>'
              f'<ellipse cx="{x + 13}" cy="{y + 9}" rx="5" ry="3" fill="{C["cheek"]}" opacity=".35"/>')
    else:
        k = 1 if facing == "right" else -1
        s += f'<path d="M{x + k * 6} {y + 13} Q{x + k * 11} {y + 15} {x + k * 15} {y + 11}" {lw}/>'
        s += f'<ellipse cx="{x + k * 4}" cy="{y + 8}" rx="5" ry="3" fill="{C["cheek"]}" opacity=".35"/>'
    if tilt:
        px, py = pivot or (x, y + r)
        s = f'<g transform="rotate({tilt} {px} {py})">{s}</g>'
    return s


# ---------------------------------------------------------------- body
def torso(svg, neck, hip, bend=(0, 0), w=44):
    """Thân (áo) dạng khối bo theo cột sống hông->cổ; [bend] đẩy giữa lưng (ưỡn / gù / nghiêng)."""
    (nx, ny), (hx, hy) = neck, hip
    mx, my = (nx + hx) / 2 + bend[0], (ny + hy) / 2 + bend[1]
    L = math.hypot(nx - hx, ny - hy) or 1
    ux, uy = (nx - hx) / L, (ny - hy) / L
    px, py = -uy, ux
    hwn, hwh = w / 2, w / 2 + 2  # vai hơi hẹp hơn hông một chút cho mềm
    d = (f"M{f(hx + px * hwh)} {f(hy + py * hwh)} Q{f(mx + px * (w / 2 + 3))} {f(my + py * (w / 2 + 3))} "
         f"{f(nx + px * hwn)} {f(ny + py * hwn)} Q{f(nx)} {f(ny - 10)} {f(nx - px * hwn)} {f(ny - py * hwn)} "
         f"Q{f(mx - px * (w / 2 + 3))} {f(my - py * (w / 2 + 3))} {f(hx - px * hwh)} {f(hy - py * hwh)} "
         f"Q{f(hx)} {f(hy + 8)} {f(hx + px * hwh)} {f(hy + py * hwh)} Z")
    return part(svg, d, P["shirt"])


def neck_part(svg, neck, head_c):
    return limb(svg, [neck, (head_c[0] * .5 + neck[0] * .5, head_c[1] * .5 + neck[1] * .5)], 7, P["skin"])


def arm_part(svg, sh, el, hand, sleeve=True, hand_r=7.5):
    """Tay: tay áo (vai->khuỷu) + cẳng tay da + bàn tay tròn."""
    s = limb(svg, [sh, el], 9, P["shirt"]) if sleeve else ""
    s += limb(svg, [el, hand], 7, P["skin"]) if sleeve else limb(svg, [sh, el, hand], 7, P["skin"])
    return s + ball(svg, *hand, hand_r, P["skin"])


def shoe_front(svg, ax, ay):
    """Giày nhìn chính diện (mũi giày hướng về người xem): khối vòm đối xứng + đế + điểm sáng mũi giày."""
    d = (f"M{ax - 15} {ay + 10} Q{ax - 16} {ay - 3} {ax - 8} {ay - 6} Q{ax} {ay - 9} {ax + 8} {ay - 6} "
         f"Q{ax + 16} {ay - 3} {ax + 15} {ay + 10} Q{ax} {ay + 14} {ax - 15} {ay + 10} Z")
    return (part(svg, d, P["shoe"], ow=4, off=(-1.5, -2), hl=[(ax - 6, ay - 1, 4.5, 2.5, -20)])
            + f'<path d="M{ax - 12} {ay + 9} Q{ax} {ay + 12} {ax + 12} {ay + 9}" stroke="{P["shoe"][2]}" '
              f'stroke-width="2" stroke-linecap="round" fill="none" opacity=".8"/>')


def shoe_side(svg, ax, ay, k=1):
    """Giày nhìn ngang kiểu giày thể thao: gót sau cổ chân, mũi giày dài bo tròn về phía [k] (1 = phải), đế phẳng."""
    x = lambda dx: ax + k * dx
    d = (f"M{x(-11)} {ay + 11} L{x(21)} {ay + 11} Q{x(32)} {ay + 11} {x(31)} {ay + 3} Q{x(29)} {ay - 4} {x(16)} {ay - 5} "
         f"L{x(6)} {ay - 9} Q{x(-4)} {ay - 13} {x(-11)} {ay - 6} Q{x(-15)} {ay + 2} {x(-11)} {ay + 11} Z")
    hl = (x(-4), ay - 4, 4.5, 2.5, -20 * k)
    return (part(svg, d, P["shoe"], ow=4, off=(-1.5 * k, -2), hl=[hl])
            + f'<path d="M{x(-9)} {ay + 8} L{x(24)} {ay + 8}" stroke="{P["shoe"][2]}" stroke-width="2.4" '
              f'stroke-linecap="round" opacity=".85"/>'
            + f'<circle cx="{x(8)}" cy="{ay - 4}" r="1.8" fill="{P["shoe"][2]}"/>')


def leg_part(svg, hip, knee, ankle, toe_dir=1, shoe=True, foot_angle=0):
    """Chân: quần (hông->gối->cổ chân) + giày; [foot_angle] xoay bàn chân quanh cổ chân (kiễng gót, xoay cổ chân).
    toe_dir: 1 / -1 = giày nhìn ngang, mũi chĩa phải / trái; 0 = giày nhìn chính diện."""
    if shoe and toe_dir == 0:  # gấu quần dừng trên cổ chân để giày lộ rõ bên dưới
        ax, ay = ankle
        return limb(svg, [hip, knee, (ax, ay - 6)], 11, P["pants"]) + shoe_front(svg, ax, ay + 4)
    if not shoe:
        return limb(svg, [hip, knee, ankle], 11, P["pants"])
    # gấu quần dừng trên cổ chân (theo hướng ống chân) để giày lộ rõ
    ax, ay = ankle
    L = math.hypot(ax - knee[0], ay - knee[1]) or 1
    hem = (ax - (ax - knee[0]) / L * 7, ay - (ay - knee[1]) / L * 7)
    sh = shoe_side(svg, ax, ay, toe_dir)
    s = limb(svg, [hip, knee, hem], 11, P["pants"])
    return s + (f'<g transform="rotate({foot_angle} {ax} {ay})">{sh}</g>' if foot_angle else sh)


# ---------------------------------------------------------------- props
def chair_front(svg, back=True):
    s = ""
    if back:
        s += part(svg, "M86 92 Q86 82 96 82 L160 82 Q170 82 170 92 L170 168 L86 168 Z", P["chair"])
    s += part(svg, "M74 166 Q74 160 80 160 L176 160 Q182 160 182 166 L182 176 Q182 182 176 182 L80 182 Q74 182 74 176 Z",
              P["chair"])
    s += part(svg, "M124 182 L132 182 L132 226 L124 226 Z", P["chair"], ow=4)
    s += part(svg, "M100 230 Q128 222 156 230 L156 236 L100 236 Z", P["chair"], ow=4)
    return s


def chair_side(svg, facing=1, x=118):
    """Ghế nhìn ngang; người quay mặt về phía [facing] (1 = phải)."""
    k = facing
    bx = x - k * 30  # lưng ghế ở phía sau người
    s = part(svg, f"M{bx - 6} 92 Q{bx - 6} 84 {bx} 84 Q{bx + 6} 84 {bx + 6} 92 L{bx + 6} 172 L{bx - 6} 172 Z", P["chair"])
    s += part(svg, f"M{x - k * 36} 166 L{x + k * 44} 166 L{x + k * 44} 180 L{x - k * 36} 180 Z", P["chair"])
    s += part(svg, f"M{x + 2} 180 L{x + 10} 180 L{x + 10} 228 L{x + 2} 228 Z", P["chair"], ow=4)
    s += part(svg, f"M{x - 22} 232 Q{x + 6} 224 {x + 34} 232 L{x + 34} 238 L{x - 22} 238 Z", P["chair"], ow=4)
    return s


def desk(svg, x0=164, top=136):
    """Bàn làm việc nhìn ngang, mặt bàn từ x0 tới mép phải."""
    s = part(svg, f"M{x0} {top} L250 {top} L250 {top + 12} L{x0} {top + 12} Z", P["desk"])
    s += part(svg, f"M{x0 + 12} {top + 12} L{x0 + 22} {top + 12} L{x0 + 22} 240 L{x0 + 12} 240 Z", P["desk"], ow=4)
    return s


def monitor(svg, x=214, top=136):
    s = part(svg, f"M{x - 4} {top} L{x + 4} {top} L{x + 4} {top - 22} L{x - 4} {top - 22} Z", P["screen"], ow=4)
    s += part(svg, f"M{x - 14} {top - 76} Q{x - 14} {top - 82} {x - 8} {top - 82} L{x + 8} {top - 82} "
                   f"Q{x + 14} {top - 82} {x + 14} {top - 76} L{x + 14} {top - 26} Q{x + 14} {top - 20} {x + 8} {top - 20} "
                   f"L{x - 8} {top - 20} Q{x - 14} {top - 20} {x - 14} {top - 26} Z", P["screen"])
    return s


def far_tree(svg, x=34, y=60, sc=.8):
    """Cây nhỏ ở xa (mục tiêu nhìn xa khoảng 6 m)."""
    leaf = ("#8ED081", "#5FAE5A", "#C4EBB9")
    trunk = ("#B98A5E", "#946A43", "#D9AF85")
    g = part(svg, f"M-4 10 L4 10 L4 34 L-4 34 Z", trunk, ow=3.5)
    g += part(svg, circle_d(0, 0, 18), leaf, ow=3.5, hl=[(-6, -7, 5, 3, -30)])
    return f'<g transform="translate({x} {y}) scale({sc})">{g}</g>'


# ---------------------------------------------------------------- poses
FRONT_HIP, FRONT_NECK, FRONT_HEAD = (128, 168), (128, 100), (128, 72)


def seated_front(svg, *, head_kw=None, arms=None, legs=None, neck=FRONT_NECK, hip=FRONT_HIP, bend=(0, 0),
                 head_c=None, chair=True, front_arms=(), extra_back="", extra_front="", hand_r=7.5):
    """Người ngồi nhìn thẳng. arms: [(vai, khuỷu, tay)] vẽ sau thân; front_arms: vẽ trước thân."""
    head_c = head_c or (neck[0], neck[1] - 28)
    arms = arms if arms is not None else [((106, 106), (96, 140), (108, 166)), ((150, 106), (160, 140), (148, 166))]
    legs = legs if legs is not None else [((114, 170), (110, 186), (110, 226), 0), ((142, 170), (146, 186), (146, 226), 0)]
    s = ground() + (chair_front(svg) if chair else "") + extra_back
    for (h, k, a, d, *fa) in legs:
        s += leg_part(svg, h, k, a, d, foot_angle=fa[0] if fa else 0)
    for a in arms:
        s += arm_part(svg, *a)
    s += neck_part(svg, neck, head_c) + torso(svg, neck, hip, bend)
    s += head_person(svg, head_c, **(head_kw or {}))
    for a in front_arms:
        s += arm_part(svg, *a, hand_r=hand_r)
    return s + extra_front


SIDE_HIP, SIDE_NECK = (116, 168), (120, 100)


def standing_side(svg, *, raise_heels=0, arm=((122, 92), (146, 112), (170, 126)), extra_back="", extra_front=""):
    """Người đứng nhìn ngang (mặt sang phải), vịn tay lên bàn; [raise_heels] = số px kiễng gót."""
    up = raise_heels
    hip, neck = (118, 148 - up), (118, 82 - up)
    s = ground() + desk(svg, x0=160, top=118) + extra_back
    s += leg_part(svg, hip, (120, 192 - up), (120, 228 - up), 1, foot_angle=up * 2.6)
    s += neck_part(svg, neck, (122, 54 - up)) + torso(svg, neck, hip, w=38)
    s += head_person(svg, (122, 54 - up), facing="right")
    s += arm_part(svg, (arm[0][0], arm[0][1] - up), (arm[1][0], arm[1][1] - up // 2), arm[2])
    return s + extra_front


def seated_side(svg, *, head_kw=None, arm=None, back_arm=None, neck=SIDE_NECK, hip=SIDE_HIP, bend=(0, 0),
                head_c=None, legs=None, chair=True, extra_back="", extra_front=""):
    """Người ngồi nhìn ngang, mặt quay sang phải."""
    head_c = head_c or (neck[0] + 4, neck[1] - 28)
    arm = arm if arm is not None else ((122, 108), (128, 140), (150, 158))
    legs = legs if legs is not None else [((118, 170), (166, 170), (166, 226), 1)]
    s = ground() + (chair_side(svg) if chair else "") + extra_back
    if back_arm:
        s += arm_part(svg, *back_arm)
    for (h, k, a, d, *fa) in legs:
        s += leg_part(svg, h, k, a, d, foot_angle=fa[0] if fa else 0)
    s += neck_part(svg, neck, head_c) + torso(svg, neck, hip, bend, w=38)
    s += head_person(svg, head_c, **({"facing": "right"} | (head_kw or {})))
    if arm:
        s += arm_part(svg, *arm)
    return s + extra_front


# ---------------------------------------------------------------- bàn tay (bài cổ tay)
def blob(svg, paths, col, ow=OW):
    """Nhiều hình chồng nhau vẽ thành MỘT khối liền (ngón + lòng bàn tay): viền chung bên dưới, rồi tô từng phần."""
    s = "".join(f'<path d="{d}" fill="{C["line"]}" stroke="{C["line"]}" stroke-width="{ow * 2}" '
                f'stroke-linejoin="round"/>' for d in paths)
    base, shade, _ = col
    for d in paths:
        cid = svg.uid("b")
        svg.defs.append(f'<clipPath id="{cid}"><path d="{d}"/></clipPath>')
        s += (f'<path d="{d}" fill="{shade}"/><g clip-path="url(#{cid})">'
              f'<path d="{d}" fill="{base}" transform="translate(-2 -2.5)"/></g>')
    return s


def rrect(cx, cy, w, h, r):
    x0, y0, x1, y1 = cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2
    return (f"M{f(x0 + r)} {f(y0)} L{f(x1 - r)} {f(y0)} Q{f(x1)} {f(y0)} {f(x1)} {f(y0 + r)} L{f(x1)} {f(y1 - r)} "
            f"Q{f(x1)} {f(y1)} {f(x1 - r)} {f(y1)} L{f(x0 + r)} {f(y1)} Q{f(x0)} {f(y1)} {f(x0)} {f(y1 - r)} "
            f"L{f(x0)} {f(y0 + r)} Q{f(x0)} {f(y0)} {f(x0 + r)} {f(y0)} Z")


def _polar(x, y, ang, ln):
    """Điểm cách (x, y) đoạn [ln] theo góc [ang] (độ, 0 = thẳng lên, dương = nghiêng phải)."""
    return x + ln * math.sin(math.radians(ang)), y - ln * math.cos(math.radians(ang))


def front_hand(svg, cx, cy, thumb, open_, arm=True):
    """Bàn tay nhìn chính diện (lòng bàn tay hướng về người xem) + cổ tay áo. thumb = +1 / -1: ngón cái bên phải / trái.
    open_: xòe rộng 4 ngón + ngón cái; ngược lại là nắm đấm (4 đốt ngón cuộn, ngón cái vắt ngang)."""
    k = thumb
    s = (limb(svg, [(cx, cy + 20), (cx, 262)], 15, P["skin"]) + limb(svg, [(cx, 236), (cx, 290)], 20, P["shirt"])) if arm else ""
    palm = rrect(cx, cy, 50, 46, 16)
    if open_:
        # (độ lệch x từ phía ngón cái, độ dài, góc xòe) cho ngón trỏ, giữa, áp út, út
        fingers = [(15, 34, 16), (5, 39, 4), (-6, 36, -8), (-16, 28, -22)]
        parts = [capsule(cx + k * dx, cy - 10, *_polar(cx + k * dx, cy - 10, k * ang, ln), 6.8) for dx, ln, ang in fingers]
        parts.append(capsule(cx + k * 18, cy + 10, *_polar(cx + k * 18, cy + 10, k * 58, 24), 7.5))  # ngón cái
        s += blob(svg, parts + [palm], P["skin"])
        lw = f'stroke="{P["skin"][1]}" stroke-width="2.4" stroke-linecap="round" fill="none"'
        s += (f'<path d="M{cx - k * 14} {cy - 4} Q{cx} {cy + 2} {cx + k * 12} {cy - 8}" {lw}/>'
              f'<path d="M{cx - k * 2} {cy + 18} Q{cx + k * 4} {cy + 6} {cx + k * 14} {cy + 2}" {lw}/>')
        return s
    # nắm đấm: 4 đốt ngón cuộn ở nửa trên + ngón cái vắt ngang phía trước
    knuckles = [rrect(cx + k * dx, cy - 12, 13, 22, 6.5) for dx in (16, 4, -8, -19)]
    s += blob(svg, [palm] + knuckles, P["skin"])
    for dx in (10, -2, -14):
        s += (f'<path d="M{cx + k * dx} {cy - 21} L{cx + k * dx} {cy - 3}" stroke="{C["line"]}" stroke-width="2.6" '
              f'stroke-linecap="round"/>')
    s += limb(svg, [(cx + k * 22, cy + 8), (cx - k * 6, cy + 1)], 7.5, P["skin"])  # ngón cái
    return s


def flat_hand(svg, wrist, angle, show, thumb, scale=1.0, foreshorten=1.0):
    """Bàn tay duỗi, các ngón khép, cùng kiểu khối liền với bàn tay xòe (front_hand), nhìn thẳng vào mặt bàn tay.
    wrist: cổ tay; angle: hướng ngón tay (độ, 0 = phải, 90 = xuống); show = "palm" (thấy lòng bàn tay, có chỉ tay)
    hoặc "back" (thấy mu bàn tay, có đốt ngón + móng); thumb = +1 / -1: ngón cái bên phải / trái khi ngón chĩa lên."""
    k = thumb
    cx, cy = 0, -26  # vẽ trong toạ độ riêng: cổ tay ở gốc, ngón chĩa lên
    palm = rrect(cx, cy, 44, 40, 15)
    fingers = [(14, 30, 4), (4.5, 35, 1), (-5, 32, -2), (-14.5, 25, -6)]
    parts = [capsule(cx + k * dx, cy - 10, *_polar(cx + k * dx, cy - 10, k * ang, ln), 6.4) for dx, ln, ang in fingers]
    parts.append(capsule(cx + k * 17, cy + 8, *_polar(cx + k * 17, cy + 8, k * 42, 22), 7))  # ngón cái
    g = blob(svg, parts + [palm], P["skin"])
    if show == "palm":
        lw = f'stroke="{P["skin"][1]}" stroke-width="2.4" stroke-linecap="round" fill="none"'
        g += (f'<path d="M{cx - k * 13} {cy - 4} Q{cx} {cy + 2} {cx + k * 11} {cy - 8}" {lw}/>'
              f'<path d="M{cx - k * 2} {cy + 16} Q{cx + k * 4} {cy + 5} {cx + k * 13} {cy + 1}" {lw}/>')
    else:
        for dx, ln, ang in fingers:  # đốt ngón (vạch ngắn ở gốc ngón) + móng tay
            bx, by = cx + k * dx, cy - 14
            g += (f'<path d="M{f(bx - 3)} {f(by)} Q{f(bx)} {f(by - 3)} {f(bx + 3)} {f(by)}" stroke="{P["skin"][1]}" '
                  f'stroke-width="2.2" stroke-linecap="round" fill="none"/>')
            tx, ty = _polar(cx + k * dx, cy - 10, k * ang, ln - 4)
            g += f'<ellipse cx="{f(tx)}" cy="{f(ty)}" rx="3.6" ry="4.2" fill="{P["skin"][2]}" opacity=".95"/>'
    x, y = wrist
    return f'<g transform="translate({f(x)} {f(y)}) rotate({angle + 90}) scale({scale} {scale * foreshorten})">{g}</g>'


def grip_fist(svg, c, elbow, scale=.8):
    """Tay kia NẮM lấy đầu các ngón đang gập: dùng nắm đấm của bài nắm - xòe, xoay ngang cho các đốt ngón hướng
    sang trái (ôm quanh các ngón); cẳng tay nối từ [elbow] tới cổ tay của nắm đấm."""
    x, y = c
    wrist = (x + 20 * scale, y)  # cổ tay nắm đấm sau khi xoay -90 độ
    s = limb(svg, [elbow, wrist], 10, P["skin"])
    fist = front_hand(svg, x, y, -1, False, arm=False)
    return s + f'<g transform="translate({x} {y}) rotate(-90) scale({scale}) translate({-x} {-y})">{fist}</g>'


def wrist_scene(svg, show, bent, helper):
    """Giãn cổ tay nhìn CHÍNH DIỆN (như ảnh tham khảo): người đứng, tay phải duỗi thẳng ra trước (cẳng tay to dần
    về phía người xem); bàn tay [show] = "palm" / "back". bent = False: bàn tay nằm ngang, ngón chĩa về phía người xem
    (vẽ co ngắn); True: cổ tay gập, ngón chĩa xuống. helper: "grip" = tay kia nắm các ngón kéo về,
    "press" = tay kia áp lên mu bàn tay ấn xuống, None = tay trái buông bên hông."""
    s = ground()
    for leg in (((116, 164), (114, 198), (114, 228)), ((140, 164), (142, 198), (142, 228))):
        s += leg_part(svg, *leg, 0)
    s += torso(svg, (128, 66), (128, 166), w=74) + neck_part(svg, (128, 62), (128, 36))
    s += head_person(svg, (128, 36))
    wrist = (106, 128)
    if helper == "grip":  # tay trái: vai -> khuỷu; cẳng tay + nắm đấm vẽ sau cùng (ôm lấy các ngón)
        s += limb(svg, [(166, 80), (194, 146)], 12, P["shirt"])
    elif helper == "press":  # tay trái: vai -> khuỷu; cẳng tay + bàn tay ấn vẽ sau cùng (chồng lên mu bàn tay)
        s += limb(svg, [(166, 80), (194, 136)], 12, P["shirt"])
    else:  # tay trái buông bên hông
        s += limb(svg, [(166, 80), (178, 122)], 12, P["shirt"]) + limb(svg, [(178, 120), (182, 166)], 10, P["skin"])
        s += ball(svg, 183, 172, 10, P["skin"])
    s += limb(svg, [(90, 80), (98, 102)], 14, P["shirt"])            # tay áo phải (ngắn vì hướng ra trước)
    s += limb(svg, [(98, 100), (102, 112), wrist], 13, P["skin"])     # cẳng tay to dần về phía người xem
    thumb = 1 if show == "palm" else -1  # ngón cái tay phải nằm bên trái khung khi lòng quay ra trước
    s += flat_hand(svg, wrist, 90, show, thumb, scale=1.05, foreshorten=1.0 if bent else .58)
    if helper == "grip":
        s += grip_fist(svg, (108, 214), (194, 144))
    elif helper == "press":
        # tay chồng lên tay: cùng chiều ngón chĩa xuống, áp lên mu bàn tay; nhỏ hơn để đầu ngón bên dưới lộ ra
        hw = (120, 126)
        s += limb(svg, [(194, 134), (150, 132), hw], 10, P["skin"])
        s += flat_hand(svg, hw, 96, "back", 1, scale=.86)
    return s


# ---------------------------------------------------------------- exercises
# QUY ƯỚC TRÁI/PHẢI: hướng dẫn nói theo cơ thể người tập. Nhìn chính diện (seated_front) thì bên PHẢI của người
# nằm ở bên TRÁI khung hình (x nhỏ). Nhìn ngang (seated_side) người quay mặt sang phải khung hình.
SH_L, SH_R = (106, 106), (150, 106)          # vai phải / vai trái của người (bên trái / phải khung hình)
REST_R = ((106, 106), (96, 140), (108, 166))  # tay phải buông, đặt lên đùi
REST_L = ((150, 106), (160, 140), (148, 166))


def neck_tilt(svg, n):
    # 2: tai phải về vai phải (nghiêng về bên trái khung); 3: sang trái
    tilt = {1: 0, 2: -24, 3: 24}[n]
    a = {1: "", 2: arrow([(106, 36), (80, 62)], curve=(84, 36)), 3: arrow([(150, 36), (176, 62)], curve=(172, 36))}[n]
    return seated_front(svg, head_kw=dict(tilt=tilt, pivot=FRONT_NECK), extra_front=a)


def chin_tuck(svg, n):
    hc = (124, 72) if n == 1 else (116, 74)
    a = arrow([(160, 70), (138, 70)]) if n == 2 else ""
    return seated_side(svg, head_c=hc, extra_front=a)


def neck_turn(svg, n):
    # 1: quay sang phải (mặt hướng về bên trái khung); 2: về giữa; 3: sang trái
    facing = {1: "left", 2: "front", 3: "right"}[n]
    a = {1: arrow([(116, 40), (86, 52)], curve=(96, 34)), 2: "", 3: arrow([(140, 40), (170, 52)], curve=(160, 34))}[n]
    return seated_front(svg, head_kw=dict(facing=facing), extra_front=a)


def shoulder_roll(svg, n):
    # nhìn ngang: vai nhún lên (1) rồi kéo ra sau + hạ xuống (2); mũi tên tròn nhỏ ngay sau khớp vai
    if n == 1:
        arm, neck = ((122, 96), (126, 130), (148, 150)), (120, 98)
    else:
        arm, neck = ((114, 110), (112, 142), (140, 158)), (120, 100)
    return seated_side(svg, arm=arm, neck=neck, extra_front=arc_arrow((92, 102), 17, 150, 420))


def shoulder_shrug(svg, n):
    if n == 1:  # hít vào, nhún vai lên cao
        arms = [((106, 92), (98, 128), (108, 156)), ((150, 92), (158, 128), (148, 156))]
        a = arrow([(80, 112), (80, 80)]) + arrow([(176, 112), (176, 80)])
        return seated_front(svg, arms=arms, neck=(128, 94), extra_front=a)
    a = arrow([(80, 80), (80, 112)]) + arrow([(176, 80), (176, 112)])
    return seated_front(svg, head_kw=dict(look="closed"), extra_front=a)


def chest_open(svg, n):
    if n == 1:
        return seated_side(svg)
    # đan tay sau lưng, ưỡn ngực, mắt nhìn hơi lên
    back = ((116, 108), (84, 132), (96, 158))
    a = arrow([(140, 128), (160, 128)])
    return seated_side(svg, arm=None, back_arm=back, bend=(5, 0), head_c=(127, 71), head_kw=dict(look="up"),
                       extra_front=a)


def overhead_reach(svg, n):
    if n == 1:  # đan tay trước ngực
        fa = [((106, 106), (100, 136), (126, 140)), ((150, 106), (156, 136), (130, 140))]
        return seated_front(svg, arms=[], front_arms=fa)
    up = [((106, 104), (100, 64), (124, 22)), ((150, 104), (156, 64), (132, 22))]
    return seated_front(svg, arms=up, neck=(128, 98), extra_front=arrow([(74, 70), (74, 30)]) + arrow([(182, 70), (182, 30)]))


def side_bend(svg, n):
    # 1: giơ tay PHẢI (bên trái khung), nghiêng người sang TRÁI người (sang phải khung); 2: ngược lại
    k = 1 if n == 1 else -1
    neck = (128 + k * 16, 102)
    head_c = (128 + k * 26, 76)
    up_sh = (106 + k * 12, 108) if k == 1 else (150 + k * 12, 108)
    up = (up_sh, (up_sh[0] - k * 4, 70), (up_sh[0] + k * 34, 44))
    down_sh = (150 + k * 16, 112) if k == 1 else (106 + k * 16, 112)
    down = (down_sh, (down_sh[0] + k * 8, 142), (down_sh[0] - k * 4, 166))
    a = arrow([(128 - k * 30, 30), (128 + k * 20, 26)], curve=(128 - k * 4, 14))
    return seated_front(svg, arms=[up, down], neck=neck, bend=(k * 6, 0), head_c=head_c,
                        head_kw=dict(tilt=k * 18, pivot=neck), extra_front=a)


def seated_twist(svg, n):
    # 1: xoay thân sang PHẢI người (về bên trái khung), tay trái người đặt lên gối phải; 2: ngược lại
    k = -1 if n == 1 else 1
    facing = "left" if k == -1 else "right"
    knee = (110, 182) if k == -1 else (146, 182)
    cross_sh = (150, 106) if k == -1 else (106, 106)
    cross = (cross_sh, (128, 140), knee)
    back_sh = (106, 106) if k == -1 else (150, 106)
    back = (back_sh, (back_sh[0] + k * 18, 132), (back_sh[0] + k * 26, 160))
    a = arrow([(128 - k * 34, 196), (128 + k * 34, 196)], curve=(128, 214))
    return seated_front(svg, arms=[back], front_arms=[cross], head_kw=dict(facing=facing), extra_front=a)


def cat_cow(svg, n):
    # ngồi mép ghế. 1 (hít vào): ưỡn ngực, nhìn lên; 2 (thở ra): cong tròn lưng, cúi đầu
    if n == 1:
        return seated_side(svg, bend=(7, 0), neck=(124, 100), head_c=(130, 72), head_kw=dict(look="up"),
                           arm=((126, 108), (138, 136), (156, 160)), extra_front=arrow([(150, 122), (168, 110)]))
    return seated_side(svg, bend=(-14, -2), neck=(134, 108), head_c=(150, 92), head_kw=dict(look="down"),
                       arm=((134, 114), (146, 140), (156, 160)), extra_front=arrow([(98, 120), (70, 116)]))


def wrist_flex(svg, n):
    # 1: duỗi tay phải ra trước, lòng bàn tay NGỬA (ngón chĩa về phía người xem);
    # 2: gập cổ tay cho ngón chĩa xuống (lòng bàn tay quay ra trước), tay kia nắm các ngón kéo nhẹ về phía người
    if n == 1:
        return wrist_scene(svg, "palm", False, None)
    return wrist_scene(svg, "palm", True, "grip") + arrow([(64, 214), (70, 158)], curve=(44, 186))


def wrist_ext(svg, n):
    # 1: duỗi tay phải ra trước, lòng bàn tay ÚP (thấy mu bàn tay);
    # 2: gập cổ tay cho ngón chĩa xuống, tay kia áp lên mu bàn tay ấn nhẹ xuống
    if n == 1:
        return wrist_scene(svg, "back", False, None)
    return wrist_scene(svg, "back", True, "press") + arrow([(66, 140), (62, 200)], curve=(44, 168))


def fist_spread(svg, n):
    # hai tay của chính người tập (cẳng tay từ mép dưới, nhìn vào lòng bàn tay) => ngón cái ở phía ngoài.
    # 1: nắm chặt; 2: xòe rộng hết cỡ
    if n == 1:
        return ground() + front_hand(svg, 76, 140, -1, False) + front_hand(svg, 180, 140, 1, False)
    a = (arrow([(40, 82), (26, 62)]) + arrow([(76, 66), (76, 44)]) + arrow([(180, 66), (180, 44)])
         + arrow([(216, 82), (230, 62)]))
    return ground() + front_hand(svg, 76, 140, -1, True) + front_hand(svg, 180, 140, 1, True) + a


def eye_2020(svg, n):
    # ngồi trước màn hình (bên phải); 2: quay đi nhìn cây ở xa ~6 m (bên trái)
    props = desk(svg) + monitor(svg)
    arm = ((124, 108), (140, 132), (176, 134))
    if n == 1:
        return seated_side(svg, arm=arm, extra_front=props)
    sight = (f'<path d="M108 76 L56 60" stroke="{C["line"]}" stroke-width="3" stroke-dasharray="2 7" '
             f'stroke-linecap="round" fill="none"/>'
             f'<text x="84" y="56" font-family="Arial Rounded MT Bold, Arial, sans-serif" font-weight="900" '
             f'font-size="15" fill="{C["line"]}">6 m</text>')
    return seated_side(svg, arm=arm, head_kw=dict(facing="left"), extra_front=props + far_tree(svg) + sight)


def eye_palming(svg, n):
    if n == 1:  # xoa hai lòng bàn tay cho ấm
        fa = [((106, 106), (104, 140), (124, 138)), ((150, 106), (152, 140), (132, 138))]
        rub = "".join(f'<path d="M{x} 124 l-4 -6 l8 0 l-4 -6" stroke="{P["arrow"]}" stroke-width="3" fill="none" '
                      f'stroke-linecap="round" stroke-linejoin="round"/>' for x in (112, 144))
        return seated_front(svg, arms=[], front_arms=fa, extra_front=rub)
    fa = [((106, 106), (88, 100), (118, 72)), ((150, 106), (168, 100), (138, 72))]
    return seated_front(svg, arms=[], front_arms=fa, head_kw=dict(look="closed"), hand_r=12)


def calf_raise(svg, n):
    if n == 1:
        return standing_side(svg)
    return standing_side(svg, raise_heels=12, extra_front=arrow([(86, 212), (86, 180)]))


def ankle_circle(svg, n):
    # duỗi chân, nhấc nhẹ khỏi sàn; xoay cổ chân (mũi tên tròn quanh bàn chân)
    ang = -35 if n == 1 else 35
    legs = [((118, 170), (166, 174), (212, 196), 1, ang)]
    return seated_side(svg, legs=legs, extra_front=arc_arrow((222, 196), 24, -120 if n == 1 else 60, 150 if n == 1 else 330))


def figure_four(svg, n):
    # gác mắt cá chân PHẢI (bên trái khung) lên gối TRÁI (bên phải khung); 2: lưng thẳng, nghiêng nhẹ về trước
    legs = [((142, 170), (146, 186), (146, 226), 0), ((114, 170), (76, 186), (140, 188), 1)]
    rest = [((106, 106), (92, 140), (86, 176)), ((150, 106), (160, 140), (148, 178))]
    if n == 1:
        return seated_front(svg, legs=legs, arms=rest)
    return seated_front(svg, legs=legs, arms=[((106, 116), (92, 148), (86, 178)), ((150, 116), (160, 148), (148, 180))],
                        neck=(128, 112), head_c=(128, 88), extra_front=arrow([(186, 64), (186, 100)]))


EXERCISES = {
    "neck_tilt": (neck_tilt, 3),
    "chin_tuck": (chin_tuck, 2),
    "neck_turn": (neck_turn, 3),
    "shoulder_roll": (shoulder_roll, 2),
    "shoulder_shrug": (shoulder_shrug, 2),
    "chest_open": (chest_open, 2),
    "overhead_reach": (overhead_reach, 2),
    "side_bend": (side_bend, 2),
    "seated_twist": (seated_twist, 2),
    "cat_cow": (cat_cow, 2),
    "wrist_flex": (wrist_flex, 2),
    "wrist_ext": (wrist_ext, 2),
    "fist_spread": (fist_spread, 2),
    "eye_2020": (eye_2020, 2),
    "eye_palming": (eye_palming, 2),
    "calf_raise": (calf_raise, 2),
    "ankle_circle": (ankle_circle, 2),
    "figure_four": (figure_four, 2),
}


def main(only=None):
    os.makedirs(OUT, exist_ok=True)
    for ex_id, (draw, frames) in EXERCISES.items():
        if only and ex_id not in only:
            continue
        for n in range(1, frames + 1):
            svg = Svg()
            inner = draw(svg, n) + upa_badge(svg, happy=n % 2 == 0)
            with open(f"{OUT}/{ex_id}_{n}.svg", "w") as fp:
                fp.write(svg.render(inner))
    print("ok:", len(os.listdir(OUT)), "files")


if __name__ == "__main__":
    main(sys.argv[1:])
