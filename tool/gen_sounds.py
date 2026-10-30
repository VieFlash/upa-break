"""Âm thanh phiên giãn cơ (T2.3), sinh bằng code giống hình minh họa -> assets/sounds/*.wav.

- tick.wav : tiếng "tách" gỗ nhẹ, ngắn (đếm 3 giây cuối)
- chime.wav: chuông 2 nốt êm, tắt dần (xong một bài)

Mono 16-bit 22.05 kHz, biên độ thấp sẵn (app còn hạ âm lượng thêm) để không gây ồn nơi công sở.
Chạy từ gốc project:  python3 tool/gen_sounds.py
"""
import math
import os
import struct
import wave

OUT = "assets/sounds"
RATE = 22050


def write(name, samples):
    os.makedirs(OUT, exist_ok=True)
    with wave.open(f"{OUT}/{name}", "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b"".join(struct.pack("<h", int(max(-1, min(1, s)) * 32767)) for s in samples))


def tick():
    """Gõ gỗ: vài hài bậc cao tắt rất nhanh + một chút tiếng ồn ở đầu, dài ~40 ms."""
    n = int(RATE * .04)
    out = []
    seed = 1
    for i in range(n):
        t = i / RATE
        env = math.exp(-t * 140)
        seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF
        noise = (seed / 0x7FFFFFFF * 2 - 1) * math.exp(-t * 900)
        tone = math.sin(2 * math.pi * 1650 * t) * .6 + math.sin(2 * math.pi * 2480 * t) * .3
        out.append((tone * env + noise * .25) * .5)
    return out


def chime():
    """Chuông 2 nốt (Đô6 rồi Mi6 sau 0.12 s), mỗi nốt có hài kiểu chuông, tắt dần ~1.2 s, vào/ra mềm."""
    n = int(RATE * 1.3)
    notes = [(1046.5, 0.0), (1318.5, .12)]
    partials = [(1, 1.0, 3.2), (2.76, .35, 5.5), (5.4, .12, 9.0)]  # (bội tần, biên độ, tốc độ tắt)
    out = []
    for i in range(n):
        t = i / RATE
        v = 0.0
        for f0, start in notes:
            u = t - start
            if u < 0:
                continue
            attack = min(1.0, u / .006)
            for mult, amp, decay in partials:
                v += math.sin(2 * math.pi * f0 * mult * u) * amp * math.exp(-u * decay) * attack
        fade = min(1.0, (n - i) / (RATE * .05))  # ra mềm, tránh tiếng "bụp" cuối file
        out.append(v * .32 * fade)
    return out


if __name__ == "__main__":
    write("tick.wav", tick())
    write("chime.wav", chime())
    print("ok:", {f: os.path.getsize(f"{OUT}/{f}") for f in sorted(os.listdir(OUT))})
