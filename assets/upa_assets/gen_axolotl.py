"""Original office-axolotl mascot ("Upa") - sticker style: thick outline, 2-tone cel shading,
glossy highlights, sparkly eyes. Run: python3 gen_axolotl.py [out_dir]"""
import math
import os
import sys

OUT = sys.argv[1] if len(sys.argv) > 1 else "upa_assets"
os.makedirs(OUT, exist_ok=True)

C = dict(
    line="#5A2233",
    skin="#FFC4D2", shade="#F49AB2", light="#FFE4EB", gloss="#FFFFFF",
    spot="#F68AA8",
    gill="#FF5F8A", gill_shade="#DD3D6B", gill_light="#FFA3BD",
    belly="#FFE8EE", belly_shade="#FBD3DE",
    cheek="#FF6F96",
    mouth="#8A2A3E", tongue="#FF7A96",
    eye_top="#2B1420", eye_bot="#6E3A52",
    blue="#4F86FF", blue_dark="#2E5FD6",
    spark="#FFD23F", z="#8C9EE0", sweat="#8FD3FF", bubble="#C9F0FF",
)
OW = 6


class Svg:
    def __init__(self):
        self.defs, self.n = [], 0

    def uid(self, p):
        self.n += 1
        return f"{p}{self.n}"

    def shaded(self, d, base, shade, off=(-7, -9), hl=None, ow=OW):
        cid = self.uid("c")
        self.defs.append(f'<clipPath id="{cid}"><path d="{d}"/></clipPath>')
        s = f'<path d="{d}" fill="{shade}"/><g clip-path="url(#{cid})">'
        s += f'<path d="{d}" fill="{base}" transform="translate({off[0]} {off[1]})"/>'
        for (x, y, rx, ry, rot, col, op) in (hl or []):
            s += (f'<ellipse cx="{x}" cy="{y}" rx="{rx}" ry="{ry}" fill="{col}" opacity="{op}" '
                  f'transform="rotate({rot} {x} {y})"/>')
        s += '</g>'
        s += (f'<path d="{d}" fill="none" stroke="{C["line"]}" stroke-width="{ow}" '
              f'stroke-linejoin="round" stroke-linecap="round"/>')
        return s

    def render(self, inner, bg=""):
        defs = (
            '<linearGradient id="eyeG" x1="0" y1="0" x2="0" y2="1">'
            f'<stop offset="0.45" stop-color="{C["eye_top"]}"/><stop offset="1" stop-color="{C["eye_bot"]}"/></linearGradient>'
            '<radialGradient id="chkG"><stop offset="0" stop-color="#FF5E8C" stop-opacity="0.8"/>'
            '<stop offset="1" stop-color="#FF5E8C" stop-opacity="0"/></radialGradient>'
            + "".join(self.defs))
        return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">'
                f'<defs>{defs}</defs>{bg}{inner}</svg>\n')


def f(v):
    return f"{v:.1f}"


# ---------------- shapes ----------------
HEAD = "M38 116 C38 70 78 48 128 48 C178 48 218 70 218 116 C218 162 180 186 128 186 C76 186 38 162 38 116 Z"
BODY = "M82 240 C72 200 92 172 128 172 C164 172 184 200 174 240 Q128 250 82 240 Z"
EYES_X, EYE_Y = (86, 170), 112

# gills: (base, tip, width) for the left side; right side mirrored
GILLS_L = [((62, 86), (28, 48), 25), ((50, 112), (16, 102), 25), ((58, 140), (26, 164), 23)]


def leaf(bx, by, tx, ty, w):
    dx, dy = tx - bx, ty - by
    L = math.hypot(dx, dy)
    ux, uy = dx / L, dy / L
    nx, ny = -uy, ux
    p1 = (bx + nx * w * .35, by + ny * w * .35)
    p2 = (bx - nx * w * .35, by - ny * w * .35)
    a1 = (p1[0] + dx * .55 + nx * w * .55, p1[1] + dy * .55 + ny * w * .55)
    b1 = (tx + nx * w * .5 - ux * w * .1, ty + ny * w * .5 - uy * w * .1)
    a2 = (tx - nx * w * .5 - ux * w * .1, ty - ny * w * .5 - uy * w * .1)
    b2 = (p2[0] + dx * .55 - nx * w * .55, p2[1] + dy * .55 - ny * w * .55)
    tip_out = (tx + ux * w * .18, ty + uy * w * .18)
    return (f"M{f(p1[0])} {f(p1[1])} C{f(a1[0])} {f(a1[1])} {f(b1[0])} {f(b1[1])} {f(tip_out[0])} {f(tip_out[1])} "
            f"C{f(a2[0])} {f(a2[1])} {f(b2[0])} {f(b2[1])} {f(p2[0])} {f(p2[1])} Z")


def gills(svg):
    s = ""
    for side in (1, -1):
        for (b, t, w) in GILLS_L:
            bx, by, tx, ty = b[0], b[1], t[0], t[1]
            if side == -1:
                bx, tx = 256 - bx, 256 - tx
            s += svg.shaded(leaf(bx, by, tx, ty, w), C["gill"], C["gill_shade"], off=(-3 * side, -4), ow=5.5)
            # vein highlight
            mx, my = bx + (tx - bx) * .7, by + (ty - by) * .7
            s += (f'<path d="M{f(bx + (tx - bx) * .15)} {f(by + (ty - by) * .15)} L{f(mx)} {f(my)}" '
                  f'stroke="{C["gill_light"]}" stroke-width="4" stroke-linecap="round"/>')
    return s


def head(svg):
    s = svg.shaded(HEAD, C["skin"], C["shade"], off=(-8, -10),
                   hl=[(84, 74, 30, 13, -15, C["light"], .95), (68, 82, 7, 4, -20, C["gloss"], .95)])
    # freckles
    for (x, y, r) in ((50, 126, 3), (56, 118, 2.4), (206, 126, 3), (200, 118, 2.4)):
        s += f'<circle cx="{x}" cy="{y}" r="{r}" fill="{C["spot"]}"/>'
    # cheeks
    for x in (66, 190):
        s += f'<ellipse cx="{x}" cy="{138}" rx="19" ry="12" fill="url(#chkG)"/>'
        s += f'<ellipse cx="{x - 4}" cy="135" rx="3" ry="2" fill="#fff" opacity=".85"/>'
    return s


HAT_L, HAT_R, HAT_Y, HAT_TOP, HAT_SAG = 44, 212, 66, 4, 16


def strap():
    """Quai non: ribbon from inside the brim, down both sides of the face, under the chin."""
    d = "M62 78 C44 112 50 162 94 180 Q128 191 162 180 C206 162 212 112 194 78"
    return (f'<path d="{d}" stroke="{C["line"]}" stroke-width="6.5" stroke-linecap="round" fill="none"/>'
            f'<path d="{d}" stroke="#FFF4DC" stroke-width="3" stroke-linecap="round" fill="none"/>'
            # small knot under the chin
            f'<ellipse cx="128" cy="186" rx="5.5" ry="4" fill="#FFF4DC" stroke="{C["line"]}" stroke-width="3"/>')


def hat(svg):
    """Non la (Vietnamese conical hat): straight, symmetric cone; light from the left so the
    left half is bright and the right half shaded, split along the centre ridge."""
    straw, straw_shade, straw_light, ring = "#F6DB94", "#E2BC6C", "#FFF3CC", "#C99A45"
    L, R, Y, T, S = HAT_L, HAT_R, HAT_Y, HAT_TOP, HAT_SAG
    cone = f"M{L} {Y} Q128 {Y + S * 2} {R} {Y} L130 {T + 2} Q128 {T} 126 {T + 2} Z"
    cid = svg.uid("h")
    svg.defs.append(f'<clipPath id="{cid}"><path d="{cone}"/></clipPath>')

    s = f'<ellipse cx="128" cy="{Y + 8}" rx="70" ry="9" fill="#E07F9C" opacity=".45"/>'  # shadow on head
    s += f'<path d="{cone}" fill="{straw}"/>'
    s += f'<g clip-path="url(#{cid})">'
    # right half in shade (split exactly along the ridge -> symmetric silhouette)
    s += f'<path d="M128 {T - 4} L{R + 10} {Y} L{R + 10} {Y + S * 2 + 6} L128 {Y + S * 2 + 6} Z" fill="{straw_shade}"/>'
    # soft highlight stripe on the lit half
    s += f'<path d="M126 {T + 8} L{L + 30} {Y + 4} L{L + 50} {Y + 8} Z" fill="{straw_light}" opacity=".9"/>'
    # rings (nan non), evenly spaced and mirrored
    for t in (0.25, 0.48, 0.70, 0.88):
        y = Y - (Y - T) * (1 - t)
        hw = (R - L) / 2 * t
        sag = S * 2 * t * 0.5
        s += (f'<path d="M{128 - hw:.1f} {y:.1f} Q128 {y + sag:.1f} {128 + hw:.1f} {y:.1f}" '
              f'stroke="{ring}" stroke-width="2.2" stroke-linecap="round" fill="none" opacity=".9"/>')
    s += '</g>'
    # outline + brim edge (thicker so it reads as the rim)
    s += (f'<path d="{cone}" fill="none" stroke="{C["line"]}" stroke-width="5.5" stroke-linejoin="round"/>'
          f'<path d="M{L} {Y} Q128 {Y + S * 2} {R} {Y}" stroke="{C["line"]}" stroke-width="7" '
          f'stroke-linecap="round" fill="none"/>')
    return s


def eyes(svg, kind):
    s, y = "", EYE_Y
    for x in EYES_X:
        if kind in ("open", "tired"):
            eye = f'<ellipse cx="{x}" cy="{y}" rx="15" ry="17" fill="url(#eyeG)"/>'
            hi = (f'<ellipse cx="{x + 5}" cy="{y - 7}" rx="6" ry="7" fill="#fff"/>'
                  f'<circle cx="{x - 5}" cy="{y + 8}" r="3.2" fill="#fff"/>'
                  f'<circle cx="{x + 8}" cy="{y + 4}" r="1.6" fill="#fff" opacity=".9"/>')
            if kind == "open":
                s += eye + hi
            else:
                cid = svg.uid("e")
                svg.defs.append(f'<clipPath id="{cid}"><ellipse cx="{x}" cy="{y}" rx="15" ry="17"/></clipPath>')
                s += (f'<g clip-path="url(#{cid})">{eye}'
                      f'<circle cx="{x - 4}" cy="{y + 9}" r="3" fill="#fff"/><circle cx="{x + 5}" cy="{y + 4}" r="4" fill="#fff"/></g>'
                      f'<rect x="{x - 18}" y="{y - 20}" width="36" height="20" fill="{C["skin"]}"/>'
                      f'<path d="M{x - 17} {y} Q{x} {y + 3} {x + 17} {y}" stroke="{C["line"]}" stroke-width="5" '
                      f'stroke-linecap="round" fill="none"/>')
        elif kind == "closed":
            s += (f'<path d="M{x - 13} {y + 2} Q{x} {y + 12} {x + 13} {y + 2}" stroke="{C["line"]}" '
                  f'stroke-width="5.5" stroke-linecap="round" fill="none"/>')
        elif kind == "happy":
            s += (f'<path d="M{x - 13} {y + 6} Q{x} {y - 11} {x + 13} {y + 6}" stroke="{C["line"]}" '
                  f'stroke-width="6" stroke-linecap="round" fill="none"/>')
    return s


def mouth(svg, kind):
    lw = f'stroke="{C["line"]}" stroke-width="4.5" stroke-linecap="round" stroke-linejoin="round" fill="none"'
    s = (f'<circle cx="120" cy="128" r="1.8" fill="{C["line"]}"/>'
         f'<circle cx="136" cy="128" r="1.8" fill="{C["line"]}"/>')
    if kind == "smile":  # iconic wide axolotl smile
        s += f'<path d="M100 138 Q128 158 156 138" {lw}/>'
    elif kind == "open":
        md = "M102 138 Q128 146 154 138 Q150 166 128 166 Q106 166 102 138 Z"
        cid = svg.uid("m")
        svg.defs.append(f'<clipPath id="{cid}"><path d="{md}"/></clipPath>')
        s += (f'<path d="{md}" fill="{C["mouth"]}"/>'
              f'<g clip-path="url(#{cid})"><ellipse cx="128" cy="167" rx="15" ry="10" fill="{C["tongue"]}"/></g>'
              f'<path d="{md}" stroke="{C["line"]}" stroke-width="4" stroke-linejoin="round" fill="none"/>')
    elif kind == "wavy":
        s += f'<path d="M108 148 Q114 142 120 148 Q128 154 136 148 Q142 142 148 148" {lw}/>'
    elif kind == "yawn":
        s += (f'<ellipse cx="128" cy="150" rx="9" ry="10" fill="{C["mouth"]}" stroke="{C["line"]}" stroke-width="3.5"/>'
              f'<ellipse cx="128" cy="155" rx="5.5" ry="3.5" fill="{C["tongue"]}"/>')
    return s


def nub(svg, x, y, rot):
    d = (f"M{x} {y - 16} Q{x + 12} {y - 16} {x + 12} {y} Q{x + 12} {y + 15} {x} {y + 15} "
         f"Q{x - 12} {y + 15} {x - 12} {y} Q{x - 12} {y - 16} {x} {y - 16} Z")
    toes = (f'<path d="M{x - 5} {y + 9} L{x - 5} {y + 14} M{x + 1} {y + 10} L{x + 1} {y + 15} M{x + 7} {y + 8} L{x + 7} {y + 13}" '
            f'stroke="{C["line"]}" stroke-width="2.2" stroke-linecap="round"/>')
    return f'<g transform="rotate({rot} {x} {y})">' + svg.shaded(d, C["skin"], C["shade"], off=(-3, -3), ow=5) + toes + '</g>'


def tail(svg):
    d = ("M164 222 C196 232 226 222 238 196 C244 182 240 170 232 170 "
         "C226 186 210 204 176 204 Z")
    fin = ("M176 204 C206 202 226 186 232 170 C238 160 248 168 246 184 "
           "C242 214 214 236 172 230 Z")
    s = svg.shaded(fin, C["light"], C["skin"], off=(-3, -3), ow=5)
    s += svg.shaded(d, C["skin"], C["shade"], off=(-4, -4), ow=5.5)
    return s


def body(svg, arms):
    s = svg.shaded(BODY, C["skin"], C["shade"], off=(-7, -6), hl=[(100, 194, 10, 5, -30, C["light"], .9)])
    s += f'<ellipse cx="128" cy="218" rx="31" ry="22" fill="{C["belly"]}"/>'
    s += f'<path d="M100 226 Q128 244 156 226 Q154 238 128 240 Q102 238 100 226 Z" fill="{C["belly_shade"]}"/>'
    s += (f'<path d="M100 178 L124 210 M156 178 L132 210" stroke="{C["blue"]}" stroke-width="6" stroke-linecap="round"/>'
          f'<rect x="113" y="204" width="30" height="22" rx="5" fill="#fff" stroke="{C["line"]}" stroke-width="3.5"/>'
          f'<rect x="118" y="210" width="9" height="9" rx="2" fill="{C["blue"]}"/>'
          f'<path d="M131 212 L138 212 M131 217 L136 217" stroke="{C["blue_dark"]}" stroke-width="2.5" stroke-linecap="round"/>')
    if arms == "rest":
        s += nub(svg, 96, 212, -20) + nub(svg, 160, 212, 20)
    elif arms == "droop":
        s += nub(svg, 90, 222, -42) + nub(svg, 166, 222, 42)
    for x in (102, 154):
        s += svg.shaded(f"M{x - 20} 240 Q{x - 20} 229 {x} 229 Q{x + 20} 229 {x + 20} 240 Q{x} 250 {x - 20} 240 Z",
                        C["skin"], C["shade"], off=(-3, -3), ow=5)
        s += (f'<path d="M{x - 7} 238 L{x - 7} 243 M{x} 238 L{x} 244 M{x + 7} 238 L{x + 7} 243" '
              f'stroke="{C["line"]}" stroke-width="2.2" stroke-linecap="round"/>')
    return s


def arms_up():
    s = ""
    for (x1, y1, x2, y2) in ((96, 196, 40, 172), (160, 196, 216, 172)):
        s += f'<path d="M{x1} {y1} L{x2} {y2}" stroke="{C["line"]}" stroke-width="32" stroke-linecap="round"/>'
        s += f'<path d="M{x1} {y1} L{x2} {y2}" stroke="{C["skin"]}" stroke-width="21" stroke-linecap="round"/>'
    return s


def star(x, y, sc=1.0):
    return (f'<path transform="translate({x} {y}) scale({sc})" '
            f'd="M0 -13 Q2.5 -2.5 13 0 Q2.5 2.5 0 13 Q-2.5 2.5 -13 0 Q-2.5 -2.5 0 -13 Z" fill="{C["spark"]}" '
            f'stroke="{C["line"]}" stroke-width="2.5" stroke-linejoin="round"/>')


def bub(x, y, r):
    return (f'<circle cx="{x}" cy="{y}" r="{r}" fill="{C["bubble"]}" opacity=".9" stroke="{C["line"]}" stroke-width="2.5"/>'
            f'<circle cx="{x - r * .35}" cy="{y - r * .35}" r="{max(1.5, r * .3)}" fill="#fff"/>')


def zzz():
    font = 'font-family="Arial Rounded MT Bold, Arial, sans-serif" font-weight="900"'
    return "".join(
        f'<text x="{x}" y="{y}" font-size="{sz}" {font} fill="{C["z"]}" stroke="{C["line"]}" stroke-width="2.5" paint-order="stroke">z</text>'
        for (x, y, sz) in ((178, 46, 22), (196, 30, 28), (216, 14, 32)))


def sweat():
    return (f'<path d="M214 66 Q225 84 214 92 Q203 84 214 66 Z" fill="{C["sweat"]}" stroke="{C["line"]}" stroke-width="3"/>'
            f'<ellipse cx="211" cy="82" rx="2" ry="3.5" fill="#fff"/>')


def shadow():
    return '<ellipse cx="128" cy="248" rx="72" ry="6" fill="#5A2233" opacity=".12"/>'


STATES = {
    "mascot_fresh": ("", "open", "smile", "rest", lambda: bub(236, 40, 8) + bub(222, 20, 5)),
    "mascot_slouch": ("translate(0 10) rotate(-8 128 180)", "tired", "wavy", "droop", sweat),
    "mascot_sleepy": ("translate(2 20) rotate(-14 128 190)", "closed", "smile", "droop", zzz),
    "mascot_stretch": ("translate(0 4)", "happy", "open", "up",
                       lambda: star(18, 30, .8) + star(240, 34, .75) + bub(22, 150, 6) + bub(236, 146, 5)),
    "mascot_proud": ("", "happy", "open", "rest",
                     lambda: star(26, 34, 1.0) + star(232, 30, .9) + star(14, 186, .6) + star(244, 190, .7)),
}

for name, (ht, e, m, arms, extra) in STATES.items():
    svg = Svg()
    inner = shadow() + tail(svg)
    if arms == "up":
        inner += arms_up()
    inner += body(svg, arms)
    face = gills(svg) + head(svg) + eyes(svg, e) + mouth(svg, m) + strap() + hat(svg)
    if name == "mascot_sleepy":
        face += bub(150, 160, 10)
    inner += f'<g transform="{ht}">{face}</g>' + extra()
    with open(f"{OUT}/{name}.svg", "w") as fp:
        fp.write(svg.render(inner))

# app icon (full) + adaptive foreground (transparent, safe zone)
for fname, bg, tr in (
    ("app_icon", '<defs><radialGradient id="bgG" cx=".5" cy=".42" r=".7"><stop offset="0" stop-color="#E9FBFF"/>'
                 '<stop offset="1" stop-color="#9EDCF2"/></radialGradient></defs>'
                 '<rect width="256" height="256" rx="58" fill="url(#bgG)"/>', "translate(18 26) scale(.86)"),
    ("app_icon_foreground", "", "translate(46 50) scale(.64)"),
):
    svg = Svg()
    face = gills(svg) + head(svg) + eyes(svg, "open") + mouth(svg, "smile") + strap() + hat(svg)
    extra = (bub(214, 210, 9) + bub(232, 186, 5)) if bg else ""
    with open(f"{OUT}/{fname}.svg", "w") as fp:
        fp.write(svg.render(f'<g transform="{tr}">{face}</g>' + extra, bg))

print("ok:", sorted(os.listdir(OUT)))
