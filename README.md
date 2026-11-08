# Hyprland config

Личная конфигурация Hyprland (проверено на **Hyprland 0.57.1**). Основной конфиг написан на **Lua** (`hyprland.lua`), обои — через `hyprpaper`.

## Файлы

| Файл | Назначение |
| --- | --- |
| `hyprland.lua` | Основной конфиг: мониторы, переменные окружения, автозапуск, ввод, оформление, бинды, правила окон |
| `hyprpaper.conf` | Обои для всех мониторов (`hyprpaper`) |

## Мониторы

| Выход | Режим | Позиция | Масштаб |
| --- | --- | --- | --- |
| `HDMI-A-1` | `1920x1080@60` | `0x0` | 1 |
| `DP-1` | `1920x1080@75` | `1920x0` | 1 |

## Окружение

- `LIBVA_DRIVER_NAME=nvidia`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`, `NVD_BACKEND=direct` — аппаратное ускорение и корректная работа на NVIDIA.
- `XCURSOR_SIZE=24` — размер курсора.

## Автозапуск

При старте Hyprland (`hyprland.start`) запускаются:

- `systemctl --user start hyprpolkitagent` — агент аутентификации Polkit;
- `mako` — демон уведомлений;
- `hyprpaper` — обои;
- `eww --config ~/.config/eww open bar` — виджеты.

## Ввод

- Раскладки: `us,ru`, переключение — `Win+Space` (`grp:win_space_toggle`).
- NumLock включён по умолчанию.
- Мышь: чувствительность `-0.2`, профиль ускорения `flat` (без акселерации).

## Оформление

- Толщина границ — 2, внутренние отступы — 5, внешние — 10.
- Активная граница — `rgb(bd93f9)`, неактивная — `rgb(392b4d)`.
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
| `SUPER + 1..0` | Перейти на воркспейс 1..10 |
| `SUPER + SHIFT + 1..0` | Переместить окно на воркспейс 1..10 |
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

`hyprland`, `hyprpaper`, `hyprlock`, `kitty`, `wofi`, `mako`, `eww`, `hyprpolkitagent` (через systemd-пользовательский сервис).
