# Vantage Hub UI Template

Vantage Hub เป็นเทมเพลต UI สำหรับ Roblox Lua ที่ออกแบบให้คนอื่นนำไปใช้ต่อได้ง่าย โดยแยก **UI template กลาง** ออกจากโค้ดเฉพาะเกม แต่ยัง build ออกมาเป็นไฟล์เดียวจบได้สำหรับ runner ที่รันได้ทีละไฟล์เดียว

> เป้าหมายของ repo นี้คือ **UI Template** ไม่ใช่เอกสารสคริปต์ของเกมใดเกมหนึ่ง

## จุดเด่น

- ใช้งานง่ายแบบ copy/paste
- มี UI source กลางให้แก้ที่เดียว
- รองรับ per-game folder สำหรับแยกโค้ดแต่ละเกม
- สร้างไฟล์รันจริงแบบ self-contained ได้ด้วย build script
- ไม่ต้องพึ่ง Roact หรือ module ภายนอกตอนใช้ไฟล์ final
- มีระบบลบ UI เก่าก่อนสร้างใหม่ กันเมนูซ้อนเมื่อรันซ้ำ
- มีปุ่มลอยสำหรับซ่อน/เปิด UI กลับมา
- มีหน้าต่างหลักแบบลากได้
- มี sidebar สำหรับแบ่ง tab
- มี element พื้นฐานพร้อมใช้:
  - Toggle
  - Slider
  - Button
- ธีม Silent Luxury / Obsidian Gold
- โครงสร้างอ่านง่าย แก้ต่อได้ง่าย

## โครงสร้าง repo

```text
.
├── README.md
├── scripts/
│   ├── build_game.py
│   └── verify_repo.py
└── src/
    ├── ui/
    │   └── VantageUILibrary.lua
    ├── templates/
    │   └── UI_Only_Template.lua
    └── games/
        └── SurviveTheApocalypse/
            ├── GameLogic.lua
            ├── GameUI.lua
            └── Final_Injectable.lua
```

## ไฟล์สำคัญ

| Path | ใช้ทำอะไร |
| --- | --- |
| `src/ui/VantageUILibrary.lua` | UI template กลาง แก้ UI หลักที่ไฟล์นี้ |
| `src/templates/UI_Only_Template.lua` | ตัวอย่าง UI-only แบบไฟล์เดียว สำหรับคนที่อยาก copy ไปใช้เร็ว ๆ |
| `src/games/<GameName>/GameLogic.lua` | logic เฉพาะของเกมนั้น |
| `src/games/<GameName>/GameUI.lua` | การผูก UI tabs/buttons เข้ากับ logic ของเกมนั้น |
| `src/games/<GameName>/Final_Injectable.lua` | ไฟล์เดียวจบที่เอาไปรันจริง |
| `scripts/build_game.py` | สร้าง `Final_Injectable.lua` จาก UI กลาง + source ของเกม |
| `scripts/verify_repo.py` | ตรวจโครงสร้าง repo และข้อกำหนดสำคัญ |

## วิธีใช้ UI template แบบเร็ว

ถ้าต้องการดูตัวอย่าง UI อย่างเดียว ให้เปิดไฟล์นี้:

```text
src/templates/UI_Only_Template.lua
```

ตัวอย่าง flow พื้นฐาน:

```lua
local Window = Library:CreateWindow("Vantage Hub", "Your Project")

local MainTab = Window:CreateTab("Main")

MainTab:CreateToggle("Example Toggle", "เปิด/ปิดฟังก์ชันตัวอย่าง", false, function(state)
    print("Toggle:", state)
end)

MainTab:CreateSlider("Example Slider", 1, 100, 50, function(value)
    print("Slider:", value)
end)

MainTab:CreateButton("Example Button", function()
    print("Button clicked")
end)
```

## API ที่มีในเทมเพลต

### `Library:CreateWindow(hubName, gameName)`

สร้างหน้าต่างหลักของ UI

```lua
local Window = Library:CreateWindow("Vantage Hub", "My Script")
```

สิ่งที่ได้พร้อมหน้าต่าง:

- Main frame
- Sidebar
- Tab container
- Page container
- Drag window
- Floating toggle button
- Old UI cleanup

### `Window:CreateTab(name)`

สร้าง tab ใหม่ใน sidebar

```lua
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")
```

### `Tab:CreateToggle(title, desc, default, callback)`

สร้าง toggle เปิด/ปิด

```lua
MainTab:CreateToggle("Enable", "เปิด/ปิดระบบ", false, function(enabled)
    print(enabled)
end)
```

### `Tab:CreateSlider(title, min, max, default, callback)`

สร้าง slider สำหรับปรับค่าเป็นตัวเลข

```lua
MainTab:CreateSlider("Range", 1, 100, 25, function(value)
    print(value)
end)
```

### `Tab:CreateButton(title, callback)`

สร้างปุ่มกดหนึ่งครั้ง

```lua
SettingsTab:CreateButton("Destroy UI", function()
    print("Destroy UI")
end)
```

## วิธีเพิ่มเกมใหม่

สร้างโฟลเดอร์ใหม่ใน:

```text
src/games/<GameName>/
```

ในโฟลเดอร์เกมควรมี:

```text
GameLogic.lua
GameUI.lua
Final_Injectable.lua
```

แนวทาง:

1. เขียน logic เฉพาะเกมใน `GameLogic.lua`
2. เขียน tabs/buttons/callbacks ใน `GameUI.lua`
3. build ไฟล์รันจริงด้วยคำสั่ง:

```bash
python3 scripts/build_game.py <GameName>
```

ตัวอย่าง:

```bash
python3 scripts/build_game.py SurviveTheApocalypse
```

ผลลัพธ์คือ:

```text
src/games/<GameName>/Final_Injectable.lua
```

ไฟล์นี้เป็นไฟล์เดียวจบสำหรับ copy/paste/run จริง

## วิธีตรวจ repo

รัน:

```bash
python3 scripts/verify_repo.py
```

ตรวจว่า:

- มี UI template กลาง
- มี UI-only template
- มี source แยกต่อเกม
- `Final_Injectable.lua` ยังมี UI + logic + UI wiring ครบ
- README ยังเป็นเอกสาร UI template ไม่ใช่เอกสารฟีเจอร์เกม
- final file ไม่มี runtime dependency แบบ `HttpGet`, `loadstring`, หรือ `require`

## สิ่งที่ควรรักษาไว้เวลาแก้เทมเพลต

- แก้ UI หลักที่ `src/ui/VantageUILibrary.lua`
- ถ้าแก้ UI แล้วต้อง build final file ใหม่
- อย่าแก้ `Final_Injectable.lua` โดยตรง ยกเว้น hotfix ฉุกเฉิน
- อย่าใช้ `require` ใน final file ถ้า environment รันได้แค่ไฟล์เดียว
- อย่าใช้ `HttpGet` หรือ `loadstring` ถ้าต้องการไฟล์เดียวจบจริง ๆ
- ควรมี cleanup กัน UI ซ้อนเมื่อรันซ้ำ
- ควรมีปุ่มลอยเปิด/ปิด UI เพื่อไม่ให้หน้าต่างหลักบังจอถาวร
- ถ้าเพิ่ม element ใหม่ ควรทำให้เรียกใช้ผ่าน pattern เดียวกับ `CreateToggle`, `CreateSlider`, `CreateButton`

## แนวทางพัฒนาต่อ

- เพิ่ม element ใหม่ เช่น dropdown, textbox, keybind, color picker
- เพิ่มตัวอย่างธีมหลายแบบ
- เพิ่ม generator สำหรับสร้างโฟลเดอร์เกมใหม่อัตโนมัติ
- เพิ่ม UI-only generated final template แยกจากตัวอย่างเกม

## หมายเหตุ

Repo นี้ตั้งใจเป็นเทมเพลต UI สำหรับให้คนอื่นนำไปต่อยอด ควรใช้งานใน environment ที่คุณมีสิทธิ์ทดสอบ เช่น private place, development place หรือ Roblox Studio test session
