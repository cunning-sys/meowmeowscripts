### [Blox Fruits Autofarm](https://www.roblox.com/games/2753915549/Blox-Fruits)

```lua
getgenv().Banana = {
   AutoFarm = {
       Enabled = false, -- true / false to enable autofarm
       FastMode = true, -- disable this if ur loosing fps
       DoTick = false, -- enable this if ur in first sea if u want
       AntiAFK = true, -- leave it on bruh
       Clump = true, -- disable this if ur not getting much progress
       AutomateStats = false, -- if u want it to auto stat
       AutoStats = {
           ['Melee'] = false,
           ['Defense'] = false,
           ['Sword'] = false,
           ['Gun'] = false,
           ['Demon Fruit'] = false, -- devil fruit
       },
       EquipTool = false, -- auto equip weapon
       Tool = "", -- ex: Ice-Ice / Electro
       Mode = "Questline", -- Questline or Chests
       AttackMode = "Function", -- leave it like this
       AutoBuso = false, -- auto haki
   }
};if Loaded then return end;getgenv().Loaded=true;
local Status, Script = pcall(game.HttpGet, game, 'https://raw.githubusercontent.com/cunning-sys/meowmeowscripts/main/bananaautofarm.lua');
if Status then
   loadstring(Script)();
else
   game:GetService('Players').LocalPlayer:Kick('Failed to connect to github');
end
```

### [Blade Ball Auto-Parry](https://www.roblox.com/games/13772394625) | [V3rmillion Thread](https://v3rmillion.net/showthread.php?tid=1216762)

```lua
shared.config = {
    adjustment = 3.7, -- // Keep this between 3 to 4 \\ --
    hit_range = 0.5, -- // You can mess around with this \\ --

    mode = 'Hold', -- // Hold , Toggle , Always \\ --
    deflect_type = 'Remote', -- // Key Press , Remote \\ --
    notifications = true,
    keybind = Enum.KeyCode.E
}

loadstring(game:HttpGet(('https://raw.githubusercontent.com/cunning-sys/meowmeowscripts/main/bladeball.lua'),true))()
```

### [Follow Players w/ Blade Ball Support](https://www.roblox.com/games/13772394625) | [Source](https://raw.githubusercontent.com/cunning-sys/meowmeowscripts/main/aifollow.lua)

```lua
shared.config = {
	enabled = true,
	auto_jump = true,
	position = 'Behind', -- Behind , Front , Normal
	position_offset = 5, -- Only works if position is Behind or Front
	player_detection = 'Closest', -- Closest , Farthest , Ball Target
	serverhop = {
		enabled = false,
		player_threshold = 3,
		ping_check = false,
		ping_threshold = 200,
		load_time = 10 -- Time before it starts checking ping
	},
	bladeball = {
		local_alive_check = true,
		alive_check = true,
		invisible_check = true
	}
}

loadstring(game:HttpGet(('https://raw.githubusercontent.com/cunning-sys/meowmeowscripts/main/aifollow.lua'),true))()
```
