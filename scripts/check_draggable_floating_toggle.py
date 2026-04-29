from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
paths = [
    ROOT / 'src/ui/VantageUILibrary.lua',
    ROOT / 'src/templates/UI_Only_Template.lua',
    ROOT / 'src/games/SurviveTheApocalypse/Final_Injectable.lua',
]

required = [
    'local floatingDragging, floatingDragInput, floatingDragStart, floatingStartPos',
    'local floatingWasDragged = false',
    'FloatingToggleButton.InputBegan:Connect(function(input)',
    'FloatingToggleButton.InputChanged:Connect(function(input)',
    'if floatingDragging and input == floatingDragInput then',
    'FloatingToggleButton.Position = UDim2.new(',
    'math.abs(delta.X) > 4 or math.abs(delta.Y) > 4',
    'if floatingWasDragged then',
    'floatingWasDragged = false',
]

for path in paths:
    text = path.read_text(encoding='utf-8')
    for token in required:
        assert token in text, f'{path.relative_to(ROOT)} missing draggable floating toggle token: {token}'

print('Draggable floating toggle checks passed.')
for path in paths:
    print(f'{path.relative_to(ROOT)} lines={len(path.read_text(encoding="utf-8").splitlines())}')
