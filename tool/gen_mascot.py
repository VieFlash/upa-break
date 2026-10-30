"""Original office-axolotl mascot ("Upa") - sticker style: thick outline, 2-tone cel shading,
glossy highlights, sparkly eyes. Run: python3 gen_axolotl.py [out_dir]"""
import math
import os
import sys

OUT = sys.argv[1] if len(sys.argv) > 1 and __name__ == "__main__" else "assets/mascot"

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
    spark="#FFD23F", bell="#FFD23F", bell_shade="#E5A91C", bell_light="#FFF1A8", z="#8C9EE0", sweat="#8FD3FF", bubble="#C9F0FF",
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
    elif arms == "bell":  # the other arm is drawn by bell()
        s += nub(svg, 160, 212, 20)
    for x in (102, 154):
        s += svg.shaded(f"M{x - 20} 240 Q{x - 20} 229 {x} 229 Q{x + 20} 229 {x + 20} 240 Q{x} 250 {x - 20} 240 Z",
                        C["skin"], C["shade"], off=(-3, -3), ow=5)
        s += (f'<path d="M{x - 7} 238 L{x - 7} 243 M{x} 238 L{x} 244 M{x + 7} 238 L{x + 7} 243" '
              f'stroke="{C["line"]}" stroke-width="2.2" stroke-linecap="round"/>')
    return s


def capsule(x1, y1, x2, y2, r):
    L = math.hypot(x2 - x1, y2 - y1)
    nx, ny = -(y2 - y1) / L * r, (x2 - x1) / L * r
    return (f"M{f(x1 + nx)} {f(y1 + ny)} L{f(x2 + nx)} {f(y2 + ny)} A{r} {r} 0 0 0 {f(x2 - nx)} {f(y2 - ny)} "
            f"L{f(x1 - nx)} {f(y1 - ny)} A{r} {r} 0 0 0 {f(x1 + nx)} {f(y1 + ny)} Z")


def arm(svg, x1, y1, x2, y2):
    """Short raised arm ending in a round paw at (x2, y2)."""
    return (svg.shaded(capsule(x1, y1, x2, y2, 11), C["skin"], C["shade"], off=(-3, -4), ow=5.5)
            + svg.shaded(f"M{x2 - 13} {y2} A13 13 0 1 1 {x2 + 13} {y2} A13 13 0 1 1 {x2 - 13} {y2} Z",
                         C["skin"], C["shade"], off=(-3, -4), ow=5.5,
                         hl=[(x2 - 4, y2 - 6, 4, 2.5, -30, C["light"], .9)]))


BELL_PAW = (68, 180)


def bell(svg, paw=BELL_PAW, sc=1.25):
    """Bell hanging on a short cord from a short arm (Upa asking to send reminders).
    The bell is drawn IN FRONT of the arm; the cord runs up into the paw, with a little thumb over it
    so the paw reads as gripping. Drawn on the viewer's left where there is no tail."""
    px, py = paw
    ox, oy = px, py + 17  # top of the dome, hanging below the paw
    # arm + paw first, then the cord out of the fist, a thumb over the cord, then the bell in front
    s = arm(svg, 96, 198, px, py)
    cord = f"M{px - 3} {py - 2} Q{px - 4} {py + 9} {ox} {oy + 1} M{px + 3} {py - 2} Q{px + 4} {py + 9} {ox} {oy + 1}"
    s += (f'<path d="{cord}" stroke="{C["line"]}" stroke-width="6" stroke-linecap="round" fill="none"/>'
          f'<path d="{cord}" stroke="{C["blue"]}" stroke-width="2.6" stroke-linecap="round" fill="none"/>')
    s += svg.shaded(circle_d(px + 4, py + 4, 7, 5), C["skin"], C["shade"], off=(-1.5, -1.5), ow=3)  # thumb
    dome = (f"M{f(ox - 5 * sc)} {f(oy + 2 * sc)} C{f(ox - 12 * sc)} {f(oy + 3 * sc)} {f(ox - 14 * sc)} {f(oy + 10 * sc)} "
            f"{f(ox - 14 * sc)} {f(oy + 18 * sc)} C{f(ox - 14 * sc)} {f(oy + 24 * sc)} {f(ox - 17 * sc)} {f(oy + 27 * sc)} "
            f"{f(ox - 19 * sc)} {f(oy + 30 * sc)} L{f(ox + 19 * sc)} {f(oy + 30 * sc)} "
            f"C{f(ox + 17 * sc)} {f(oy + 27 * sc)} {f(ox + 14 * sc)} {f(oy + 24 * sc)} {f(ox + 14 * sc)} {f(oy + 18 * sc)} "
            f"C{f(ox + 14 * sc)} {f(oy + 10 * sc)} {f(ox + 12 * sc)} {f(oy + 3 * sc)} {f(ox + 5 * sc)} {f(oy + 2 * sc)} Z")
    s += svg.shaded(circle_d(ox, oy + 33 * sc, 4.5 * sc), C["bell_shade"], C["bell_shade"], off=(0, 0), ow=3.5)  # clapper
    s += svg.shaded(dome, C["bell"], C["bell_shade"], off=(-3, -3), ow=4.5,
                    hl=[(ox - 7 * sc, oy + 13 * sc, 2.5 * sc, 7 * sc, 12, C["bell_light"], .95)])
    s += svg.shaded(circle_d(ox, oy + 30 * sc, 20 * sc, 4.5 * sc), C["bell"], C["bell_shade"], off=(-2, -1.5), ow=4.5)  # lip
    s += svg.shaded(circle_d(ox, oy + 1, 4.5), C["bell_shade"], C["bell_shade"], off=(0, 0), ow=3)  # top knob
    return s


def ding(x, y, sc=1.0, toward=-90):
    """'Ding!' marks: three short strokes fanning out from (x, y) around direction [toward] (degrees)."""
    s = ""
    for ang in (-40, 0, 40):
        r = math.radians(toward + ang)
        x1, y1 = x + math.cos(r) * 6 * sc, y + math.sin(r) * 6 * sc
        x2, y2 = x + math.cos(r) * 14 * sc, y + math.sin(r) * 14 * sc
        d = f"M{f(x1)} {f(y1)} L{f(x2)} {f(y2)}"
        s += (f'<path d="{d}" stroke="{C["line"]}" stroke-width="{f(6 * sc)}" stroke-linecap="round"/>'
              f'<path d="{d}" stroke="{C["spark"]}" stroke-width="{f(2.6 * sc)}" stroke-linecap="round"/>')
    return s


def circle_d(x, y, rx, ry=None):
    ry = ry or rx
    return f"M{x - rx} {y} A{rx} {ry} 0 1 1 {x + rx} {y} A{rx} {ry} 0 1 1 {x - rx} {y} Z"


def blob(svg, parts, ow=2.8):
    """Overlapping shapes drawn as ONE sticker blob: a shared outline underneath (only its outer half
    shows), then each part cel-shaded in order, so later parts hide the seams of earlier ones."""
    s = "".join(f'<path d="{d}" fill="{C["line"]}" stroke="{C["line"]}" stroke-width="{ow * 2}" '
                f'stroke-linejoin="round"/>' for d, _ in parts)
    for d, hl in parts:
        cid = svg.uid("c")
        svg.defs.append(f'<clipPath id="{cid}"><path d="{d}"/></clipPath>')
        s += (f'<path d="{d}" fill="{C["shade"]}"/><g clip-path="url(#{cid})">'
              f'<path d="{d}" fill="{C["skin"]}" transform="translate(-2.5 -3)"/>')
        for (x, y, rx, ry, rot) in hl:
            s += (f'<ellipse cx="{x}" cy="{y}" rx="{rx}" ry="{ry}" fill="{C["light"]}" opacity=".95" '
                  f'transform="rotate({rot} {x} {y})"/>')
        s += '</g>'
    return s


def v_sign(svg, x1=96, y1=198, px=70, py=186, tilt=-12):
    """Short arm (same length as the sign-holding one) with a small paw making a V:
    two tiny fingers peeking above a round paw, thumb folded across it."""
    s = svg.shaded(capsule(x1, y1, px, py, 10), C["skin"], C["shade"], off=(-3, -4), ow=5.5)
    s += f'<g transform="translate({px} {py}) rotate({tilt})">'
    s += blob(svg, [
        (capsule(-3.5, -5, -5.5, -9.5, 3.2), []),     # index: tip peeks ~2-3px above the paw
        (capsule(3, -5.5, 4.8, -10, 3.2), []),        # middle
        (circle_d(0, 1, 10, 9.5), [(-4.5, -3.5, 3, 2, -30)]),       # palm last: hides finger bases
    ], ow=2.5)
    # folded thumb crease
    s += f'<path d="M-7 3.5 Q-2 8.5 6 4.5" stroke="{C["line"]}" stroke-width="2.3" stroke-linecap="round" fill="none"/>'
    return s + '</g>'


def sign(svg, text="HAPPY"):
    """Picket sign: board on a wooden stick, held up beside the hat by the other short arm."""
    board, board_shade, board_light = "#FFF6E2", "#F1D9AE", "#FFFFFF"
    wood, wood_shade, wood_light = "#D9A066", "#B47A40", "#F0C690"
    cx, cy, w, h = 214, 33, 66, 38
    hx, hy = 186, 186  # paw gripping the stick
    stick = capsule(hx - 2, hy + 18, cx - 1, cy, 4)
    s = svg.shaded(stick, wood, wood_shade, off=(-2, -2), ow=4.5, hl=[(cx - 3, cy + 40, 1.5, 30, 6, wood_light, .9)])
    d = (f"M{cx - w / 2 + 7} {cy - h / 2} L{cx + w / 2 - 7} {cy - h / 2} Q{cx + w / 2} {cy - h / 2} {cx + w / 2} {cy - h / 2 + 7} "
         f"L{cx + w / 2} {cy + h / 2 - 7} Q{cx + w / 2} {cy + h / 2} {cx + w / 2 - 7} {cy + h / 2} "
         f"L{cx - w / 2 + 7} {cy + h / 2} Q{cx - w / 2} {cy + h / 2} {cx - w / 2} {cy + h / 2 - 7} "
         f"L{cx - w / 2} {cy - h / 2 + 7} Q{cx - w / 2} {cy - h / 2} {cx - w / 2 + 7} {cy - h / 2} Z")
    s += f'<g transform="rotate(6 {cx} {cy})">'
    s += svg.shaded(d, board, board_shade, off=(-4, -4), ow=4.5, hl=[(cx - 20, cy - 12, 10, 2.5, 0, board_light, .9)])
    s += (f'<text x="{cx}" y="{cy + 6}" text-anchor="middle" font-size="16" '
          f'font-family="Arial Rounded MT Bold, Arial, sans-serif" font-weight="900" fill="{C["gill"]}" '
          f'stroke="{C["line"]}" stroke-width="2.2" stroke-linejoin="round" paint-order="stroke">{text}</text>')
    s += '</g>'
    return s + arm(svg, 160, 198, hx, hy)


def star(x, y, sc=1.0):
    return (f'<path transform="translate({x} {y}) scale({sc})" '
            f'd="M0 -13 Q2.5 -2.5 13 0 Q2.5 2.5 0 13 Q-2.5 2.5 -13 0 Q-2.5 -2.5 0 -13 Z" fill="{C["spark"]}" '
            f'stroke="{C["line"]}" stroke-width="2.5" stroke-linejoin="round"/>')


def bub(x, y, r):
    return (f'<circle cx="{x}" cy="{y}" r="{r}" fill="{C["bubble"]}" opacity=".9" stroke="{C["line"]}" stroke-width="2.5"/>'
            f'<circle cx="{x - r * .35}" cy="{y - r * .35}" r="{max(1.5, r * .3)}" fill="#fff"/>')


def z_glyph(x, y, sz):
    """One 'z' drawn as a path (no font dependency), top-left at (x, y), sz x sz box."""
    d = (f"M{f(x + sz * .2)} {f(y + sz * .22)} L{f(x + sz * .8)} {f(y + sz * .22)} "
         f"L{f(x + sz * .2)} {f(y + sz * .78)} L{f(x + sz * .8)} {f(y + sz * .78)}")
    return (f'<path d="{d}" stroke="{C["line"]}" stroke-width="{f(sz * .3)}" stroke-linecap="round" '
            f'stroke-linejoin="round" fill="none"/>'
            f'<path d="{d}" stroke="{C["z"]}" stroke-width="{f(sz * .14)}" stroke-linecap="round" '
            f'stroke-linejoin="round" fill="none"/>')


Z_RIG = dict(start=(184, 42), end=(222, 6), size=24)  # animated z path (top-left of the z box)


def zzz():
    return "".join(z_glyph(x, y, sz) for (x, y, sz) in ((182, 36, 18), (200, 20, 22), (222, 4, 26)))


def sweat():
    return (f'<path d="M214 66 Q225 84 214 92 Q203 84 214 66 Z" fill="{C["sweat"]}" stroke="{C["line"]}" stroke-width="3"/>'
            f'<ellipse cx="211" cy="82" rx="2" ry="3.5" fill="#fff"/>')


def shadow():
    return '<ellipse cx="128" cy="248" rx="72" ry="6" fill="#5A2233" opacity=".12"/>'


# effects: (kind, *args); kept as data so the rig can export each one as its own animated layer
FX = dict(bub=bub, star=star, ding=ding, sweat=lambda: sweat(), zzz=lambda: zzz())
SWEAT_AT = (214, 79)

STATES = {
    "mascot_fresh": ("", "open", "smile", "rest", [("bub", 236, 40, 8), ("bub", 222, 20, 5)]),
    "mascot_slouch": ("translate(6 10) rotate(-8 128 180)", "tired", "wavy", "droop", [("sweat",)]),
    "mascot_sleepy": ("translate(12 18) rotate(-11 128 190)", "closed", "smile", "droop", [("zzz",)]),
    "mascot_stretch": ("translate(0 4)", "happy", "open", "sign",
                       [("star", 22, 34, .8), ("star", 28, 210, .55), ("bub", 40, 188, 4.5)]),
    "mascot_bell": ("", "open", "smile", "bell", [("ding", 38, 214, .9, -150), ("ding", 100, 222, .7, -30)]),
    "mascot_proud": ("", "happy", "open", "rest",
                     [("star", 26, 34, 1.0), ("star", 232, 30, .9), ("star", 14, 186, .6), ("star", 240, 190, .7)]),
}
SNOT = {"mascot_sleepy": (145, 138, 9)}  # snot bubble hanging from the right nostril (136, 128)
BLINK = ("open",)                        # eye kinds that get their own layer so the rig can blink them


def parts(name):
    """Ordered layers of one state (all in the same 256 frame). The static SVG is all of them stacked;
    the rig exports each as its own file. Head-attached layers carry the head transform."""
    ht, e, m, arms, fx = STATES[name]
    g = lambda inner: f'<g transform="{ht}">{inner}</g>'
    P = {
        "shadow": lambda svg: shadow(),
        "body": lambda svg: tail(svg) + body(svg, arms),
        "head": lambda svg: g(gills(svg) + head(svg) + ("" if e in BLINK else eyes(svg, e))
                              + mouth(svg, m) + strap() + hat(svg)),
    }
    if e in BLINK:
        P["eyes"] = lambda svg: g(eyes(svg, e))
    if name in SNOT:
        P["bubble"] = lambda svg: g(bub(*SNOT[name]))
    if arms == "sign":
        P["vhand"] = lambda svg: v_sign(svg)
        P["sign"] = lambda svg: sign(svg)
    if arms == "bell":
        P["bell"] = lambda svg: bell(svg)
    for i, (kind, *a) in enumerate(fx):
        P[f"fx{i}" if kind != "zzz" else "zzz"] = (lambda k, a: lambda svg: FX[k](*a))(kind, a)
    return P


def main():
    """Sinh mọi SVG (trạng thái, rig, icon) - tách khỏi phần định nghĩa để tool khác import lại hàm vẽ."""
    os.makedirs(OUT, exist_ok=True)
    for name in STATES:
        svg = Svg()
        with open(f"{OUT}/{name}.svg", "w") as fp:
            fp.write(svg.render("".join(draw(svg) for draw in parts(name).values())))


    def apply(tr, x, y):
        """Map a point through a head transform like 'translate(a b) rotate(deg cx cy)' (either part optional)."""
        for op in reversed(tr.replace(")", ")|").split("|")):
            if "(" not in op:
                continue
            kind, args = op.strip().split("(")
            v = list(map(float, args.rstrip(")").split()))
            if kind == "translate":
                x, y = x + v[0], y + v[1]
            elif kind == "rotate":
                r = math.radians(v[0])
                dx, dy = x - v[1], y - v[2]
                x, y = v[1] + dx * math.cos(r) - dy * math.sin(r), v[2] + dx * math.sin(r) + dy * math.cos(r)
        return x, y


    # ---- animation rig: every state split into layers (same 256 frame) and animated in Flutter
    # (lib/ui/widgets/upa_rig.dart). Pivots go to a generated Dart file so code and art stay in sync.
    RIG = f"{OUT}/rig"
    os.makedirs(RIG, exist_ok=True)
    for old in os.listdir(RIG):
        if old.endswith(".svg"):
            os.remove(f"{RIG}/{old}")
    with open(f"{RIG}/z.svg", "w") as fp:
        sz = Z_RIG["size"]
        fp.write(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="-5 -5 {sz + 10} {sz + 10}" '
                 f'width="{sz + 10}" height="{sz + 10}">{z_glyph(0, 0, sz)}</svg>\n')


    def off(p):
        return f"Offset({p[0]:.1f}, {p[1]:.1f})"


    specs = []
    for name in STATES:
        ht, e, m, arms, fx = STATES[name]
        short = name.removeprefix("mascot_")
        layers = []
        for lname, draw in parts(name).items():
            if lname == "zzz":  # animated from z.svg instead
                continue
            svg = Svg()
            with open(f"{RIG}/{short}_{lname}.svg", "w") as fp:
                fp.write(svg.render(draw(svg)))
            layers.append(lname)
        fxs = [f"RigFx('{k}', {off(SWEAT_AT if k == 'sweat' else a[:2])})" for (k, *a) in fx if k != "zzz"]
        specs.append(
            f"  '{short}': RigSpec(\n"
            f"    layers: [{', '.join(repr(l) for l in layers)}],\n"
            f"    neck: {off(apply(ht, 128, 190))},\n"
            f"    eyes: {off(apply(ht, 128, EYE_Y))},\n"
            f"    nose: {off(apply(ht, 137, 129))},\n"
            f"    leftShoulder: Offset(96, 198),\n"
            f"    rightShoulder: Offset(160, 198),\n"
            f"    fx: [{', '.join(fxs)}],\n"
            f"  ),\n")

    with open("lib/ui/widgets/mascot_rig.g.dart", "w") as fp:
        fp.write("// GENERATED by tool/gen_mascot.py - do not edit by hand.\n"
                 "// Coordinates are in the 256x256 mascot frame.\n"
                 "import 'dart:ui';\n\n"
                 "class RigFx {\n  const RigFx(this.kind, this.at);\n  final String kind;\n  final Offset at;\n}\n\n"
                 "class RigSpec {\n"
                 "  const RigSpec({required this.layers, required this.neck, required this.eyes, required this.nose,\n"
                 "      required this.leftShoulder, required this.rightShoulder, required this.fx});\n"
                 "  final List<String> layers; // bottom to top; file = assets/mascot/rig/<state>_<layer>.svg\n"
                 "  final Offset neck, eyes, nose, leftShoulder, rightShoulder;\n"
                 "  final List<RigFx> fx; // layer fx<i> is fx[i]\n"
                 "}\n\n"
                 "const rigSpecs = <String, RigSpec>{\n" + "".join(specs) + "};\n\n"
                 f"const zStart = Offset({Z_RIG['start'][0]}, {Z_RIG['start'][1]});\n"
                 f"const zEnd = Offset({Z_RIG['end'][0]}, {Z_RIG['end'][1]});\n"
                 f"const zSize = {Z_RIG['size']}.0;\n"
                 f"const zPad = 5.0; // z.svg viewBox padding around the glyph\n")

    # ---- app icon + splash sources. assets/icon/*.svg -> PNG 1024 via `tool/render_mascot.py --icons`,
    # then flutter_launcher_icons / flutter_native_splash (config in pubspec.yaml).
    ICON = "assets/icon"
    os.makedirs(ICON, exist_ok=True)
    ICON_BG = ('<defs><radialGradient id="bgG" cx=".5" cy=".42" r=".7"><stop offset="0" stop-color="#E9FBFF"/>'
               '<stop offset="1" stop-color="#9EDCF2"/></radialGradient></defs>')
    FACE_CENTER = (128, 100)  # visual centre of gills + head + hat
    FACE_RADIUS = 118         # farthest outline point from FACE_CENTER (gill tips, incl. stroke)


    def face(svg):
        return gills(svg) + head(svg) + eyes(svg, "open") + mouth(svg, "smile") + strap() + hat(svg)


    def centred(svg, radius):
        """Upa's face scaled so it fits a circle of [radius] around the frame centre."""
        k = radius / FACE_RADIUS
        tx, ty = 128 - FACE_CENTER[0] * k, 128 - FACE_CENTER[1] * k
        return f'<g transform="translate({tx:.2f} {ty:.2f}) scale({k:.4f})">{face(svg)}</g>'


    ICONS = {
        # rounded preview (docs/store mock-ups)
        f"{OUT}/app_icon": (ICON_BG + '<rect width="256" height="256" rx="58" fill="url(#bgG)"/>',
                            lambda svg: f'<g transform="translate(18 26) scale(.86)">{face(svg)}</g>'
                            + bub(214, 210, 9) + bub(232, 186, 5)),
        # iOS + legacy Android: full bleed, no transparency (the OS applies its own mask)
        f"{ICON}/icon_full": (ICON_BG + '<rect width="256" height="256" fill="url(#bgG)"/>',
                              lambda svg: f'<g transform="translate(18 26) scale(.86)">{face(svg)}</g>'
                              + bub(214, 210, 9) + bub(232, 186, 5)),
        # Android adaptive icon (108dp): face inside the 66dp safe circle -> radius 256*66/108/2 = 78, keep margin
        f"{ICON}/icon_background": (ICON_BG + '<rect width="256" height="256" fill="url(#bgG)"/>', lambda svg: ""),
        f"{ICON}/icon_foreground": ("", lambda svg: centred(svg, 77)),
        f"{OUT}/app_icon_foreground": ("", lambda svg: centred(svg, 77)),
        # splash: legacy = face on cream; Android 12+ = icon masked to a circle of 2/3 the image -> radius 85
        f"{ICON}/splash": ("", lambda svg: centred(svg, 124)),
        f"{ICON}/splash_android12": ("", lambda svg: centred(svg, 80)),
    }
    for path, (bg, draw) in ICONS.items():
        svg = Svg()
        with open(f"{path}.svg", "w") as fp:
            fp.write(svg.render(draw(svg), bg))

    print("ok:", sorted(os.listdir(OUT)))


if __name__ == "__main__":
    main()
