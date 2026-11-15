# Hyprland config

Личная конфигурация Hyprland (проверено на **Hyprland 0.57.2**). Основной конфиг написан на **Lua** (`hyprland.lua`), обои — через `hyprpaper`. Воркспейсы разделены по мониторам с помощью Lua-пакета **split-monitor-workspaces**.

## Файлы

| Файл | Назначение |
| --- | --- |
| `hyprland.lua` | Основной конфиг: мониторы, переменные окружения, автозапуск, ввод, оформление, бинды, правила окон |
| `hyprpaper.conf` | Обои для всех мониторов (`hyprpaper`) |
| `plugins/split-monitor-workspaces/` | Lua-пакет `split-monitor-workspaces` — независимые воркспейсы на каждом мониторе |

## Мониторы

| Выход | Режим | Позиция | Масштаб |
| --- | --- | --- | --- |
| `HDMI-A-1` | `1920x1080@60` | `0x0` | 1 |
| `DP-1` | `1920x1080@75` | `1920x0` | 1 |

## Воркспейсы (split-monitor-workspaces)

Вместо глобальных воркспейсов Hyprland используется Lua-пакет
[`split-monitor-workspaces`](https://github.com/zjeffer/split-monitor-workspaces):
на каждом мониторе свой набор из **10 воркспейсов** с независимой нумерацией.

- `HDMI-A-1` → воркспейсы `1–10`
- `DP-1` → воркспейсы `11–20`

Подключение в `hyprland.lua`:

```lua
package.path = package.path .. ";./?.lua;./?/init.lua"
local smw = require("plugins.split-monitor-workspaces")

smw.setup({
    workspace_count = 10,
    monitor_priority = { "HDMI-A-1", "DP-1" },
    enable_persistent_workspaces = true,
    keep_focused = true,
})
```

Установка / обновление пакета:

```bash
# установка (ветка должна соответствовать мажорной версии Hyprland)
mkdir -p ~/.config/hypr/plugins
git clone -b release/0.57.x https://github.com/zjeffer/split-monitor-workspaces \
  ~/.config/hypr/plugins/split-monitor-workspaces

# обновление
git -C ~/.config/hypr/plugins/split-monitor-workspaces pull
```

> C++-версия плагина через `hyprpm` в Hyprland ≥ 0.57 устарела и не используется.

## Окружение

- `LIBVA_DRIVER_NAME=nvidia`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`, `NVD_BACKEND=direct` — аппаратное ускорение и корректная работа на NVIDIA.
- `XCURSOR_SIZE=24` — размер курсора.

## Автозапуск

При старте Hyprland (`hyprland.start`) запускаются:

- `systemctl --user start hyprpolkitagent` — агент аутентификации Polkit;
- `mako` — демон уведомлений;
- `hyprpaper` — обои;
- `eww --config ~/.config/eww open-many bar-left bar-right` — виджеты (два бара).

При старте и при смене фокуса монитора (`monitor.focused`) в `eww` отправляется
переменная `active_monitor` с именем активного монитора.

## Ввод

- Раскладки: `us,ru`, переключение — `Win+Space` (`grp:win_space_toggle`).
- NumLock включён по умолчанию.
- Мышь: чувствительность `-0.2`, профиль ускорения `flat` (без акселерации).

## Оформление

- Толщина границ — 2, внутренние отступы — 5, внешние — 10.
- Активная граница — `rgb(d6acff)`, неактивная — `rgb(392b4d)`.
- Скругление углов — 10.
- Анимации `layersIn` (popin 90%) и `layersOut` (fade).

## Горячие клавиши

Основной модификатор — `SUPER` (`mainMod`).

| Комбинация | Действие |
| --- | --- |
| `SUPER + Q` | Терминал (`kitty`) |
| `SUPER + R` | Меню приложений (`~/.config/wofi/launch.sh`) |
| `SUPER + C` | Закрыть окно |
| `SUPER + L` | Заблокировать экран (`hyprlock`) |
| `SUPER + F` | Полноэкранный режим (toggle) |
| `SUPER + V` | Плавающее окно (toggle) |
| `SUPER + SHIFT + E` | Выйти из Hyprland |
| `SUPER + ←/→/↑/↓` | Перемещение фокуса |
| `SUPER + 1..0` | Воркспейс 1..10 на активном мониторе |
| `SUPER + SHIFT + 1..0` | Переместить окно на воркспейс 1..10 активного монитора (без смены фокуса) |
| `SUPER + ЛКМ` (drag) | Перетаскивание окна |
| `SUPER + ПКМ` (drag) | Ресайз окна |

## Правила окон

Для всех окон (`class = ".*"`) подавляется событие `maximize` — окна не разворачиваются по «максимизации».

## Обои

`hyprpaper.conf`:

- `splash = false`, `ipc = true`;
- изображение `/home/eugene/Images/wallpaper.jpg`, `fit_mode = cover`, применяется ко всем мониторам (`monitor = *`).

## Перезагрузка конфига

```bash
hyprctl reload                # перечитать конфиг
hyprctl configerrors          # показать ошибки, если что-то не применилось
```

`hyprpaper` при изменении настроек обоев:

```bash
hyprctl hyprpaper reload ,/home/eugene/Images/wallpaper.jpg
```

## Зависимости

`hyprland`, `hyprpaper`, `hyprlock`, `kitty`, `wofi`, `mako`, `eww`, `hyprpolkitagent`
(через systemd-пользовательский сервис), а также `git` — для установки Lua-пакета
`split-monitor-workspaces`.
