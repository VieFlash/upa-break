---
name: upa-mascot
description: Vẽ hoặc chỉnh mascot Upa (kỳ nhông văn phòng đội nón lá) và mọi hình minh họa cùng phong cách sticker cho app Upa Break - trạng thái mới, trang phục, bạn đồng hành, hình bài tập, cảnh nền, icon. Dùng khi task cần tạo/sửa SVG trong assets/mascot hoặc asset minh họa mới.
---

# Upa mascot – hướng dẫn phong cách và quy trình

Mọi hình đều **sinh bằng code** từ `tool/gen_mascot.py` (Python, xuất SVG). Không vẽ tay SVG riêng lẻ,
không dùng ảnh tải từ mạng, không dùng ảnh AI. Thêm hình mới = thêm hàm/trạng thái vào script rồi chạy lại.

## 1. Quy trình bắt buộc

1. Đọc `tool/gen_mascot.py` (các hàm: `Svg.shaded`, `leaf`, `gills`, `head`, `eyes`, `mouth`, `nub`,
   `tail`, `body`, `capsule`, `circle_d`, `blob`, `arm`, `v_sign`, `sign`, `strap`, `hat`, `star`, `bub`, `zzz`, `sweat`, `shadow`, dict `STATES`).
2. Sửa/thêm code. Tái sử dụng hàm có sẵn trước khi viết hàm mới.
3. Sinh lại: `python3 tool/gen_mascot.py` (ghi vào `assets/mascot/`).
4. Render và **tự xem ảnh**: `python3 tool/render_mascot.py` → mở `build/mascot_preview.png` bằng công cụ đọc ảnh.
   Chi tiết nhỏ: `python3 tool/render_mascot.py --zoom <tên_file_không_đuôi>`.
5. Đối chiếu checklist mục 6. Sai thì sửa và lặp lại bước 3–5 (thường cần 2–3 vòng).
6. Khi ổn: `python3 tool/render_mascot.py --export` nếu cần PNG (icon launcher, ảnh thông báo, store).
7. Không đổi tên file đang được code dùng (`mascot_fresh|slouch|sleepy|stretch|proud|bell.svg`,
   `app_icon.svg`, `app_icon_foreground.svg`) trừ khi cập nhật luôn `lib/ui/widgets/mascot.dart`.

## 2. Khung hình

- `viewBox="0 0 256 256"`, nền trong suốt (trừ `app_icon.svg`).
- Lề an toàn: không có nét nào chạm mép; giữ ≥ 4px từ mép (kể cả sao, bong bóng, "zzz", đỉnh nón).
- Bóng đổ dưới chân: ellipse tại y≈248, opacity .12.
- Adaptive icon foreground: nội dung nằm trong vùng giữa ~66% (lề 17% mỗi cạnh).

## 3. Phong cách sticker (giữ đúng các con số)

| Thành phần | Quy tắc |
|---|---|
| Viền | Màu `C["line"]` (#5A2233, nâu tím đậm). Thân/đầu 6px, chi tiết nhỏ 5–5.5px, đồ vật nhỏ 2.5–3.5px. `stroke-linejoin="round"`, `stroke-linecap="round"` |
| Đổ bóng | Cel-shading 2 tông bằng `svg.shaded(d, base, shade, off=...)`: vẽ shape bằng màu tối, rồi vẽ lại màu gốc lệch về **trên-trái** (`off` âm) bên trong clip ⇒ viền tối ở **dưới-phải**. Ánh sáng luôn từ trên-trái |
| Điểm sáng | Ellipse màu `light` (opacity ~.9) + chấm `gloss` trắng nhỏ ở trên-trái mỗi khối lớn (truyền qua tham số `hl`) |
| Mắt | Ellipse gradient `eyeG` (tối trên, nâu tím dưới) + 3 đốm trắng: lớn trên-phải, vừa dưới-trái, nhỏ phải. Các kiểu: `open`, `tired`, `closed`, `happy` |
| Má | Ellipse gradient mờ `chkG` + một chấm trắng nhỏ |
| Miệng | `smile` (cười rộng đặc trưng axolotl), `open` (có lưỡi, clip), `wavy` (mệt), `yawn` |
| Hình khối | Tròn, mũm mĩm, không góc nhọn (trừ đỉnh nón bo nhẹ). Đầu chiếm ~70% chiều cao, thân nhỏ ngồi |
| Hiệu ứng | Sao 4 cánh vàng `star()`, bong bóng nước `bub()`, giọt mồ hôi `sweat()`, chữ `zzz()` — đều có viền |

## 4. Bảng màu (dict `C`)

- Da: `skin` #FFC4D2, `shade` #F49AB2, `light` #FFE4EB · Bụng: `belly` #FFE8EE
- Mang: `gill` #FF5F8A, `gill_shade` #DD3D6B, `gill_light` #FFA3BD
- Mắt: `eye_top` #2B1420 → `eye_bot` #6E3A52 · Miệng `mouth` #8A2A3E, lưỡi `tongue` #FF7A96
- Nón lá: rơm #F6DB94 / tối #E2BC6C / sáng #FFF3CC / nan #C99A45 · Quai #FFF4DC
- Thẻ nhân viên: `blue` #4F86FF · Sao `spark` #FFD23F · Bong bóng `bubble` #C9F0FF
- Màu mới phải theo cùng cách: base + shade (đậm hơn ~15–20%) + light (nhạt hơn), cùng viền `C["line"]`.

## 5. Nhận diện nhân vật Upa (không được làm mất)

- Kỳ nhông hồng, đầu rộng dẹt, **6 mang dạng lá tròn có gân sáng** (3 mỗi bên), đốm tàn nhang cạnh má.
- **Nón lá** thẳng, đối xứng qua trục giữa (nửa trái sáng, nửa phải tối, các vòng nan cách đều)
  + **quai nón** màu kem vòng hai bên má xuống dưới cằm, nút thắt ở cằm.
- **Thẻ nhân viên** dây xanh trên ngực; dáng **ngồi**; đuôi có vây nhạt màu.
- Nón, quai và mặt nằm trong nhóm đầu ⇒ khi đầu nghiêng (`STATES[...][0]` transform) thì nghiêng theo.
- Đây là nhân vật nguyên bản: không sao chép thiết kế mascot của app/thương hiệu khác (vd: kỳ nhông của Glubbo),
  không vẽ nhân vật có bản quyền.

## 6. Checklist trước khi coi là xong

- [ ] Không có gì bị cắt ở mép khung (xem đường viền xám trong preview).
- [ ] Viền đủ dày, liền mạch; không có khe hở hay nét mảnh lạc lõng.
- [ ] Bóng nằm dưới-phải, sáng trên-trái trên **mọi** khối.
- [ ] Nón đối xứng; quai không che mắt.
- [ ] Đọc được cảm xúc ở 64px (thu nhỏ preview mà vẫn nhận ra).
- [ ] Cùng tỉ lệ đầu/thân, cùng vị trí mắt với các trạng thái khác (trừ khi task yêu cầu khác).
- [ ] Màu mới tuân theo mục 4.

## 7. Công thức cho các loại việc thường gặp

**Thêm trạng thái mới** (vd: `mascot_wave`): thêm 1 dòng vào `STATES`:
`"mascot_wave": (head_transform, eyes_kind, mouth_kind, arms_kind, lambda: extras)`.
Nếu cần tư thế tay mới, thêm nhánh trong `body()` hoặc hàm riêng kiểu `sign()`, rồi map Mood mới
trong `lib/ui/widgets/mascot.dart` + `enum Mood` trong `lib/state/app_state.dart`.

**Trang phục / phụ kiện** (nón len, nón sinh nhật, khăn Tết…): viết hàm như `hat()`/`strap()`,
thêm tham số chọn phụ kiện thay vì hard-code; xuất thêm biến thể có hậu tố (`mascot_fresh_tet.svg`).

**Bạn đồng hành (buddy) mới** (mèo, corgi, gấu trúc, rái cá): tạo script riêng `tool/gen_buddy_<tên>.py`
sao chép lớp `Svg`, `star`, `bub`, `shadow`, bảng hiệu ứng; giữ nguyên quy tắc mục 2–3; đổi hình đầu/tai/đuôi
và bảng màu. Xuất `assets/buddies/<tên>_<trạng thái>.svg` với cùng 5 trạng thái.

**Hình minh họa bài tập** (task T2.2): `tool/gen_exercises.py`, mỗi bài 2–3 khung
`assets/exercises/<exercise_id>_<n>.svg`, cùng viewBox/viền/bóng. Động tác phải đọc được rõ ràng
hơn là dễ thương (ưu tiên đúng tư thế); có thể dùng Upa nhỏ ở góc.

**Cảnh nền / vật dụng** (bàn làm việc, cây, đèn — task T3.1): `tool/gen_scenes.py`, khung 512×288
cho cảnh, 128×128 cho vật dụng; vật dụng dùng chung `shaded()` và màu theo mục 4.

**Hiệu ứng động (rig)**: flutter_svg không chạy animation SVG, nên chuyển động làm bằng lớp tách rời + Flutter.
`parts(name)` trong `gen_mascot.py` định nghĩa các lớp của mỗi trạng thái (shadow, body, head, eyes, bubble,
vhand, sign, fx<i>); hình tĩnh = mọi lớp chồng lên nhau, rig xuất từng lớp ra `assets/mascot/rig/<state>_<lớp>.svg`
và sinh `lib/ui/widgets/mascot_rig.g.dart` (danh sách lớp + pivot: cổ, mắt, mũi, vai, vị trí fx) — không sửa tay.
Hiệu ứng trong `STATES` là dữ liệu `("bub"|"star"|"sweat"|"zzz", *args)` để mỗi cái thành một lớp động.
Chuyển động viết trong `lib/ui/widgets/upa_rig.dart` (`_pose()` theo trạng thái, `_fx()` cho bong bóng/sao/mồ hôi).
Thêm trạng thái/lớp mới: thêm vào `parts()`/`STATES`, chạy lại script, rồi thêm nhánh trong `_pose()`.
Giữ biên độ chuyển động sao cho không lố khung 256 (≥ 4px lề ở mọi khung hình).
