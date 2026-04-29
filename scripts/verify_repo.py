from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

required_files = [
    'src/ui/VantageUILibrary.lua',
    'src/templates/UI_Only_Template.lua',
    'src/games/SurviveTheApocalypse/GameLogic.lua',
    'src/games/SurviveTheApocalypse/GameUI.lua',
    'src/games/SurviveTheApocalypse/Final_Injectable.lua',
    'scripts/build_game.py',
]

for rel in required_files:
    assert (ROOT / rel).exists(), f'Missing required file: {rel}'

ui = (ROOT / 'src/ui/VantageUILibrary.lua').read_text(encoding='utf-8')
template = (ROOT / 'src/templates/UI_Only_Template.lua').read_text(encoding='utf-8')
logic = (ROOT / 'src/games/SurviveTheApocalypse/GameLogic.lua').read_text(encoding='utf-8')
game_ui = (ROOT / 'src/games/SurviveTheApocalypse/GameUI.lua').read_text(encoding='utf-8')
final = (ROOT / 'src/games/SurviveTheApocalypse/Final_Injectable.lua').read_text(encoding='utf-8')
readme = (ROOT / 'README.md').read_text(encoding='utf-8')

ui_tokens = [
    'function Library:CreateWindow',
    'function Pages:CreateTab',
    'function Elements:CreateToggle',
    'function Elements:CreateSlider',
    'function Elements:CreateButton',
    'FloatingToggleButton',
]
for token in ui_tokens:
    assert token in ui, f'UI library missing: {token}'
    assert token in template, f'UI-only template missing: {token}'
    assert token in final, f'Final artifact missing UI token: {token}'

logic_tokens = [
    'local Logic = {}',
    'function Logic.ToggleKillAura',
    'function Logic.ToggleZombieESP',
    'function Logic.ToggleItemESP',
    'function Logic.ToggleHeightModifier',
    'function Logic.ToggleAutoSpectate',
    'function Logic.Cleanup',
]
for token in logic_tokens:
    assert token in logic, f'GameLogic missing: {token}'
    assert token in final, f'Final artifact missing logic token: {token}'

ui_wiring_tokens = [
    'local function BuildUI(Library, Logic)',
    'Library:CreateWindow',
    'CreateTab',
    'CreateToggle',
    'CreateSlider',
    'CreateButton',
]
for token in ui_wiring_tokens:
    assert token in game_ui, f'GameUI missing: {token}'
    assert token in final, f'Final artifact missing UI wiring token: {token}'

assert 'return Library' in ui, 'UI source should return Library'
assert 'return Logic' in logic, 'GameLogic source should return Logic'
assert 'return BuildUI' in game_ui, 'GameUI source should return BuildUI'

for forbidden in ['HttpGet', 'loadstring(', 'require(']:
    assert forbidden not in final, f'Final artifact has forbidden runtime dependency: {forbidden}'

for game_feature in ['Kill Aura', 'Zombie ESP', 'Item ESP', 'Auto Spectate', 'Smooth Fly']:
    assert game_feature not in readme, f'README should not document game feature: {game_feature}'

assert 'src/ui/VantageUILibrary.lua' in readme, 'README should document UI source file'
assert 'scripts/build_game.py' in readme, 'README should document build script'
assert readme.count('```') % 2 == 0, 'README code fences are not balanced'

print('Vantage Hub architecture checks passed.')
print(f'UI library lines={len(ui.splitlines())}')
print(f'UI-only template lines={len(template.splitlines())}')
print(f'GameLogic lines={len(logic.splitlines())}')
print(f'GameUI lines={len(game_ui.splitlines())}')
print(f'Final_Injectable lines={len(final.splitlines())}')
print(f'README lines={len(readme.splitlines())}')
