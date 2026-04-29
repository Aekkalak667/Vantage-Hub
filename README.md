# Vantage Hub UI Template

Vantage Hub เป็นเทมเพลต UI สำหรับ Roblox Lua ที่ออกแบบให้คนอื่นนำไปใช้ต่อได้ง่าย โดยเน้นไฟล์เดียวจบ เหมาะสำหรับงานที่ต้องการเมนูแบบ Hub พร้อม tabs, toggles, sliders, buttons และปุ่มลอยเปิด/ปิด UI

> เป้าหมายของ repo นี้คือ **UI Template** ไม่ใช่เอกสารสคริปต์ของเกมใดเกมหนึ่ง

## จุดเด่น

- ใช้งานง่ายแบบ copy/paste
- เหมาะกับ runner ที่รันได้ทีละไฟล์เดียว
- ไม่ต้องพึ่ง Roact หรือ module ภายนอก
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

## ไฟล์หลักของเทมเพลต

```text
src/games/SurviveTheApocalypse/Final_Injectable.lua
```

ตอนนี้ UI template ถูกฝังอยู่ในไฟล์นี้ช่วงบนของไฟล์ ภายใต้หัวข้อ:

```lua
-- [ EMBEDDED UI LIBRARY ]
```

ให้คัดลอกส่วน `Library` ไปใช้ในไฟล์ของคุณ หรือใช้ไฟล์นี้เป็นตัวอย่างการวาง UI library + โค้ดของคุณไว้ในไฟล์เดียว

## วิธีใช้งานแบบเร็ว

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
local CombatTab = Window:CreateTab("Combat")
local VisualTab = Window:CreateTab("Visual")
local SettingsTab = Window:CreateTab("Settings")
```

### `Tab:CreateToggle(title, desc, default, callback)`

สร้าง toggle เปิด/ปิด

```lua
CombatTab:CreateToggle("Auto Farm", "เปิด/ปิด Auto Farm", false, function(enabled)
    print(enabled)
end)
```

### `Tab:CreateSlider(title, min, max, default, callback)`

สร้าง slider สำหรับปรับค่าเป็นตัวเลข

```lua
CombatTab:CreateSlider("Range", 1, 100, 25, function(value)
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

## โครงสร้างที่แนะนำสำหรับคนเอาไปใช้

ถ้าคุณต้องการทำไฟล์เดียวจบ ให้จัดไฟล์ประมาณนี้:

```lua
-- Services
-- UI Library
-- Your Logic
-- UI Wiring
```

ตัวอย่าง:

```lua
-- 1. Services
local Players = game:GetService("Players")

-- 2. UI Library
local Library = {}
function Library:CreateWindow(hubName, gameName)
    -- วาง UI template ตรงนี้
end

-- 3. Your Logic
local function doSomething(state)
    print("State:", state)
end

-- 4. UI Wiring
local Window = Library:CreateWindow("Vantage Hub", "My Project")
local Main = Window:CreateTab("Main")

Main:CreateToggle("Enable", "เปิดระบบ", false, doSomething)
```

## สิ่งที่ควรรักษาไว้เวลาแก้เทมเพลต

- ให้ UI library อยู่ในไฟล์เดียวกับสคริปต์ที่ต้องรัน ถ้า runner ใช้ได้แค่ไฟล์เดียว
- อย่าแยกเป็น `require` ถ้า environment ของคุณโหลด module ไม่ได้
- อย่าใช้ `HttpGet` หรือ `loadstring` ถ้าต้องการไฟล์เดียวจบจริง ๆ
- ควรมี cleanup กัน UI ซ้อนเมื่อรันซ้ำ
- ควรมีปุ่มลอยเปิด/ปิด UI เพื่อไม่ให้หน้าต่างหลักบังจอถาวร
- ถ้าเพิ่ม element ใหม่ ควรทำให้เรียกใช้ผ่าน pattern เดียวกับ `CreateToggle`, `CreateSlider`, `CreateButton`

## โครงสร้าง repo ปัจจุบัน

```text
.
├── README.md
└── src/
    └── games/
        └── SurviveTheApocalypse/
            └── Final_Injectable.lua
```

## แนวทางพัฒนาต่อ

- แยกตัวอย่าง UI-only template ให้เห็นชัดขึ้น
- เพิ่ม element ใหม่ เช่น dropdown, textbox, keybind, color picker
- เพิ่มตัวอย่างธีมหลายแบบ
- เพิ่มไฟล์ตัวอย่างแบบ minimal ที่ไม่มี logic เฉพาะเกม

## หมายเหตุ

Repo นี้ตั้งใจเป็นเทมเพลต UI สำหรับให้คนอื่นนำไปต่อยอด ควรใช้งานใน environment ที่คุณมีสิทธิ์ทดสอบ เช่น private place, development place หรือ Roblox Studio test session
