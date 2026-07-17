# Podman Brave Sandbox 🛡️

Un motor de contenerización avanzado para ejecutar instancias de Brave Browser totalmente aisladas utilizando Podman sin privilegios (rootless) en entornos Wayland nativos.

Diseñado específicamente para aislar entornos críticos, como billeteras de criptomonedas (Web3, DeFi) o navegación a través de redes proxy (Tor/VPN), eliminando el factor humano mediante orquestación estricta.

## ✨ Características de Seguridad (El Aislamiento)

- **Zero-Host Network:** No utiliza `--net=host`. Cada instancia vive en su propio *namespace* de red (`slirp4netns`) o se ancla directamente al *namespace* de contenedores VPN/Proxy de terceros.
- **Zero-Host Filesystem:** Bloquea por completo el acceso a tu `/home` real. El perfil del navegador se inyecta mediante volúmenes montados de forma estricta.
- **Wayland Nativo:** Renderizado directo mediante `/dev/dri` y el socket `WAYLAND_DISPLAY`. Sin dependencias de X11 ni Xwayland.
- **Sandboxing Bidireccional:** El contenedor aísla el navegador del sistema anfitrión, y las directivas de `seccomp` ajustadas permiten que el propio *sandbox* de Chromium proteja el contenedor contra páginas web o extensiones maliciosas.

## ⚙️ Requisitos del Sistema

- Linux con entorno gráfico **Wayland** (Sway, Hyprland, GNOME Wayland, etc.).
- `podman` instalado y configurado para uso rootless.

## 🚀 Instalación (Standalone)

### 1. Construir la Imagen Base
La imagen utiliza Fedora Linux y preinstala Brave junto con las dependencias gráficas y de audio necesarias.

```bash
# En la raíz de este repositorio
podman build -t localhost/fedora-brave:latest -f Containerfile .

```

### 2. Enlazar el Binario

Haz que el motor esté disponible en tu sistema:

```bash
chmod +x MI_brave
ln -s "$(pwd)/MI_brave" ~/.local/bin/MI_brave

```

## 🎮 Uso Básico

El script `MI_brave` es un orquestador agnóstico. Puedes llamarlo directamente pasando los parámetros necesarios:

```bash
MI_brave -c my-wallet-box -p ~/Ruta/Segura/Perfil -n normal [https://app.uniswap.org](https://app.uniswap.org)

```

**Parámetros disponibles:**

* `-c, --container`: Nombre del contenedor Podman.
* `-p, --profile`: Ruta absoluta donde se guardará la persistencia del navegador.
* `-n, --network`: Tipo de red (`normal`, `tor`, `vpn`).
* `--usb`: Habilita el mapeo de `/dev/bus/usb` (necesario para Trezor, Ledger, etc.).

## 🏗️ Integración Experta (GNU Stow / Dotfiles)

**Aquesta part la implemento en el repositori `dotfiles`**

Este motor está diseñado para **separar la lógica de la configuración**. Se recomienda encarecidamente no llamar a `MI_brave` manualmente para evitar errores operativos.

La mejor práctica es crear **scripts envoltorio (wrappers)** y archivos `.desktop` en tu repositorio personal de *dotfiles* gestionado por GNU Stow.

**Ejemplo de un script envoltorio (`~/.local/bin/brave-defi`):**

```bash
#!/usr/bin/env bash
# Inyecta tu configuración rígida en el motor
exec MI_brave -c brave-defi-box -p "$HOME/CryptoWallets/Defi" -n normal "$@"

```

**Ejemplo de integración con Rofi/Sway (`~/.local/share/applications/brave-defi.desktop`):**

```ini
[Desktop Entry]
Version=1.0
Name=Brave DeFi Wallet
Exec=brave-defi %U
Icon=brave-browser
Terminal=false
Type=Application
Categories=Network;Crypto;

```

## 🐛 Diagnóstico y Logs

El orquestador lanza los contenedores en modo *detached* (`-d`) para no bloquear tu terminal. Si una instancia falla al arrancar o el renderizado gráfico presenta problemas, consulta los logs nativos de Podman:

```bash
podman logs -f <nombre-del-contenedor>

```
