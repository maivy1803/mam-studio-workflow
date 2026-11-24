# Code Blender cho storyboard (MCP blender)

Chạy qua `mcp__blender__execute_blender_code`. Chia nhỏ từng bước và in ra kết quả. Mỗi lần gọi là một môi trường Python mới, nên mỗi bước phải tự khai báo lại hàm phụ của nó.

## Mục lục
1. Mở file set an toàn, lưu bản sao
2. Hàm khối cơ bản và vật liệu
3. Hình nộm nhân vật
4. Bảng panel: camera và vị trí
5. Render khung blockout
6. Kiểm tra nhanh bằng `look`

---

## 1. Mở file set an toàn, lưu bản sao

**Bước 1a**: chỉ đọc trạng thái.
```python
import bpy
print("file:", bpy.data.filepath)
print("is_dirty:", bpy.data.is_dirty)
```
Nếu `is_dirty` là True và file đang mở không phải file của tập này thì dừng và hỏi người dùng.

**Bước 1b**: mở file set. Đây là một lệnh riêng: sau `open_mainfile`, các lệnh tiếp theo trong cùng script có thể chạy trên dữ liệu cũ.
```python
import bpy
bpy.ops.wm.open_mainfile(filepath=r"E:\...\Halo_Cub\<tap>\03_moi_truong\3.1_blockout_moi_truong.blend")
```

**Bước 1c**: lưu thành bản sao trong thư mục storyboard, để file set giữ sạch.
```python
import bpy, os
d = r"E:\...\Halo_Cub\<tap>\03_moi_truong\storyboard"
os.makedirs(os.path.join(d, "blockout"), exist_ok=True)
bpy.ops.wm.save_as_mainfile(filepath=os.path.join(d, "storyboard_<tap>.blend"))
print(bpy.data.filepath)
```

---

## 2. Hàm khối cơ bản và vật liệu

```python
import bpy, bmesh, math
from mathutils import Matrix, Vector

def _lin(c): return c/12.92 if c <= 0.04045 else ((c+0.055)/1.055)**2.4
def mat(name, hexv):
    m = bpy.data.materials.get(name) or bpy.data.materials.new(name)
    try: m.use_nodes = True
    except Exception: pass
    h = hexv.lstrip('#'); rgb = tuple(_lin(int(h[i:i+2], 16)/255) for i in (0, 2, 4))
    m.diffuse_color = (*rgb, 1)                     # mau viewport
    b = next(n for n in m.node_tree.nodes if n.type == 'BSDF_PRINCIPLED')   # tim node theo type
    b.inputs['Base Color'].default_value = (*rgb, 1)
    return m

def coll(name, parent=None):
    c = bpy.data.collections.get(name)
    if not c:
        c = bpy.data.collections.new(name)
        (parent or bpy.context.scene.collection).children.link(c)
    return c
```

---

## 3. Hình nộm nhân vật

Thân trụ, đầu cầu và chóp nón chỉ hướng nhìn theo **+Y cục bộ**. Gốc đặt ở chân, giữa thân. Chiều cao `h` lấy từ khóa của Session nhân vật.

```python
def standin(name, h, hexv, c):
    old = bpy.data.objects.get(name)
    if old: bpy.data.objects.remove(old, do_unlink=True)
    bm = bmesh.new()
    rb, hb = h*0.20, h*0.62                                   # than
    bmesh.ops.create_cone(bm, cap_ends=True, segments=20, radius1=rb, radius2=rb*0.85, depth=hb,
                          matrix=Matrix.Translation((0, 0, hb/2)))
    rh = h*0.19                                               # dau
    bmesh.ops.create_icosphere(bm, subdivisions=2, radius=rh, matrix=Matrix.Translation((0, 0, h - rh)))
    # chop non chi huong nhin (+Y), ngang tam mat
    bmesh.ops.create_cone(bm, cap_ends=True, segments=12, radius1=rh*0.35, radius2=0.0, depth=rh*0.9,
                          matrix=Matrix.Translation((0, rh*1.2, h - rh)) @ Matrix.Rotation(math.radians(-90), 4, 'X'))
    me = bpy.data.meshes.new(name); bm.to_mesh(me); bm.free()
    o = bpy.data.objects.new(name, me); c.objects.link(o)
    me.materials.append(mat("MAT_SB_" + name, hexv))
    return o

def place(o, x, y, facing_deg):
    """facing_deg: huong nhin tinh tu truc +X the gioi (0 = nhin sang +X, 90 = nhin ve +Y)."""
    o.location = (x, y, 0.0)
    o.rotation_euler = (0, 0, math.radians(facing_deg - 90))  # vi chop non huong +Y cuc bo

cSB = coll("COL_STORYBOARD")
STANDIN = {
    # ten: (chieu cao m, mau). Chon mau CHUA khoi nao trong set dung.
    "SB_BO":  (1.60, "#FF2DA6"),   # VD: chieu cao lay tu khoa #2
    "SB_VIT": (0.90, "#FFD60A"),
}
for n, (h, col) in STANDIN.items():
    standin(n, h, col, cSB)
```

Nếu nhân vật cầm đạo cụ hay đang cúi (ví dụ "cúi nhai, cánh che mỏ"), không cần tạc dáng. Ghi động tác vào prompt Flow là đủ. Hình nộm chỉ cần đúng **vị trí, chiều cao và hướng**.

---

## 4. Bảng panel: camera và vị trí

```python
def aim(o, loc, target):
    o.location = loc
    o.rotation_euler = (Vector(target) - Vector(loc)).to_track_quat('-Z', 'Y').to_euler()

def cam(name, lens, c):
    o = bpy.data.objects.get(name)
    if not o:
        cd = bpy.data.cameras.new(name); cd.sensor_width = 36; cd.clip_end = 200
        o = bpy.data.objects.new(name, cd); c.objects.link(o)
    o.data.lens = lens
    return o

# panel -> camera (vi tri, diem nhin, tieu cu) + hinh nom (x, y, huong); thieu ten = an trong panel do
PANELS = {
    "S01a": {"cam": ((2.6, 1.2, 1.4), (1.6, 3.6, 1.0), 28),
             "SB_BO": (2.2, 2.6, 110), "SB_VIT": (1.05, 4.0, 200)},
    "S03":  {"cam": ((0.95, 4.1, 1.3), (1.25, 3.3, 1.35), 65),
             "SB_BO": (1.25, 3.3, 101), "SB_VIT": (1.05, 4.0, 200)},
    # ...
}
for pid, d in PANELS.items():
    loc, tgt, lens = d["cam"]
    aim(cam("CAM_SB_" + pid, lens, cSB), loc, tgt)
print(sorted(o.name for o in cSB.objects))
```

Cách đặt camera nhanh:
- **Cận một nhân vật**: camera ngang tầm mắt, gần vị trí nhân vật kia (góc ngược). Điểm nhìn là đầu nhân vật chính.
- **Qua vai**: camera sau lưng và lệch vai người kia khoảng 0.3–0.5 m, cao ngang vai. Điểm nhìn là người hoặc vật chính.
- **Toàn cảnh**: camera xa, nhìn bao quát, 18–24 mm.

---

## 5. Render khung blockout

```python
import bpy, os, math
sc = bpy.context.scene
OUT = r"E:\...\storyboard\blockout"
prev_engine, prev_cam = sc.render.engine, sc.camera
sc.render.resolution_x, sc.render.resolution_y, sc.render.resolution_percentage = 1920, 1080, 100
sc.render.image_settings.file_format = 'PNG'

# an dau san, chu, duong di: Flow se ve chung thanh tham/vach son
hidden = []
for c in bpy.data.collections:
    if c.name.startswith("COL_MARK") and not c.hide_render:
        c.hide_render = True; hidden.append(c)
for o in bpy.data.objects:
    if o.name.startswith("TXT_") and not o.hide_render:
        o.hide_render = True; hidden.append(o)

def set_panel(d):
    for n in STANDIN:                       # STANDIN, PANELS khai bao lai o day neu la lan goi moi
        o = bpy.data.objects[n]
        if n in d:
            x, y, f = d[n]; o.location = (x, y, 0); o.rotation_euler = (0, 0, math.radians(f - 90))
            o.hide_render = False
        else:
            o.hide_render = True

for pid, d in PANELS.items():
    set_panel(d)
    sc.camera = bpy.data.objects["CAM_SB_" + pid]
    sc.render.filepath = os.path.join(OUT, f"SB_{pid}_blockout.png")
    bpy.ops.render.render(write_still=True)
    print("wrote", pid)

for h in hidden: h.hide_render = False
try: sc.render.engine = prev_engine
except TypeError: pass
sc.camera = prev_cam
bpy.ops.wm.save_mainfile()
```

Engine: nếu muốn ảnh Workbench thì gán trong `try/except TypeError`; lỗi trả về sẽ liệt kê các engine hợp lệ. Không gán được thì cứ để EEVEE: world sáng đều cho ảnh màu phẳng, đủ để Flow đọc khối.

---

## 6. Kiểm tra nhanh bằng `look`

```
mcp__blender__look(mode="camera", shading="solid", max_size=768)
```
Hoặc Read thẳng file PNG vừa render. Kiểm tra: cỡ cảnh, mặt nằm trong dải 9:16 ở giữa, khoảng trống cạnh đầu cho phụ đề, không có khối nào che mặt.
