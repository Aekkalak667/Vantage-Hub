# Vantage Hub

Vantage Hub เป็น Roblox Lua script hub แบบ **single-file per game** สำหรับตัวรันที่รันได้ทีละไฟล์เดียว

## ใช้งานไฟล์ไหน

สำหรับเกม **Survive the Apocalypse** ให้รันไฟล์นี้ไฟล์เดียว:

```text
src/games/SurviveTheApocalypse/Final_Injectable.lua
```

ไฟล์นี้ self-contained แล้ว ไม่ต้องใช้ไฟล์อื่นประกอบ

## มีอะไรในไฟล์เดียว

`Final_Injectable.lua` รวมทุกอย่างไว้ในไฟล์เดียว:

- Embedded UI Library
- UI theme แบบ Silent Luxury / Obsidian Gold
- ระบบลบ UI เก่าก่อนสร้างใหม่ กันเมนูซ้อนตอนรันซ้ำ
- Game logic ของ Survive the Apocalypse
- UI tabs, toggles, sliders และ buttons
- Cleanup / stop features

## ฟังก์ชันใน Survive the Apocalypse

### Combat

- `Kill Aura` — โจมตีซอมบี้ใกล้ตัวอัตโนมัติ
- `Aura Range` — ปรับระยะโจมตี
- `Attack Delay x0.1s` — ปรับดีเลย์โจมตี เช่น 1 = 0.1 วินาที, 20 = 2 วินาที

### Visuals

- `Zombie ESP` — แสดงตำแหน่งและระยะของซอมบี้
- `Item ESP` — แสดงตำแหน่งและระยะของไอเทม
- `Auto Spectate` — สลับกล้องไปมอง Humanoid อื่นอัตโนมัติ
- `Clear ESP` — ปิด ESP และล้าง object ที่สร้างไว้

### Movement

- `Smooth Fly / Noclip` — ปรับความสูงและเดินผ่านสิ่งกีดขวางแบบนุ่ม
- `Height Offset` — ปรับความสูงของระบบ Movement

### Settings

- `Stop All Features` — ปิดทุกฟังก์ชันและคืนค่าที่จำเป็น
- `Destroy UI` — ปิดทุกฟังก์ชันและลบ UI

## โครงสร้าง repo ปัจจุบัน

```text
.
├── README.md
└── src/
    └── games/
        └── SurviveTheApocalypse/
            └── Final_Injectable.lua
```

## แนวทางเพิ่มเกมใหม่

เพราะตัวรันรันได้แค่ไฟล์เดียวต่อเกม เกมใหม่ควรมีไฟล์แบบนี้:

```text
src/games/<GameName>/Final_Injectable.lua
```

ข้อกำหนดของไฟล์เกม:

- ต้อง self-contained
- ต้องมี UI library ฝังในไฟล์ หรือสร้าง UI เองในไฟล์เดียว
- ต้องมี logic ของเกมนั้นในไฟล์เดียว
- ไม่ควรพึ่ง `HttpGet`, `loadstring`, Roact หรือ module `require` ภายนอก
- ต้องมี cleanup สำหรับปิด event, task loop, ESP object, camera subject หรือ object อื่นที่สร้างไว้

## หมายเหตุ

ใช้เฉพาะใน environment ที่คุณมีสิทธิ์ทดสอบ เช่น private place, development place หรือ Roblox Studio test session และควรเคารพกฎของเกม/แพลตฟอร์มที่เกี่ยวข้อง
