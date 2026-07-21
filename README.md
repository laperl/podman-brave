# Podman Brave Sandbox 🛡️

Un motor de contenerización avanzado para ejecutar instancias de Brave Browser totalmente aisladas utilizando Podman sin privilegios (rootless) en entornos Wayland nativos.

Diseñado específicamente para aislar entornos críticos, como billeteras de criptomonedas (Web3, DeFi) o navegación a través de redes proxy (Tor/VPN), eliminando el factor humano mediante orquestación estricta.

## ✨ Características de Seguridad y Aislamiento

* **Zero-Host Network:** No utiliza `--net=host`. Cada instancia vive en su propio *namespace* de red (`slirp4netns`), en Tor, o se ancla directamente a contenedores VPN de terceros.
* **Auto-Start VPN:** Si se especifica una red VPN, el motor levanta automáticamente el servicio *systemd* del túnel (ej. `vpngluetunpod`) antes de iniciar el navegador.
* **Zero-Host Filesystem:** Bloquea por completo el acceso al `/home` real. El perfil del navegador se inyecta mediante volúmenes montados de forma estricta.
* **Wayland Nativo:** Renderizado directo mediante `/dev/dri` y el socket `WAYLAND_DISPLAY`. Sin dependencias de X11 ni Xwayland.
* **Spoofing de Entorno:** Soporte para inyectar zonas horarias (`TZ`) específicas por contenedor para evitar el *fingerprinting*.

## 📂 Estructura del Repositorio

Este repositorio está diseñado para ser autocontenido y amigable con `GNU Stow`. Separa el código fuente y la configuración de construcción, de los archivos que realmente se instalan en el sistema de tu usuario.

```text
podman-brave/
├── Containerfile             <-- Receta de Podman para construir la imagen base
├── README.md                 <-- Este documento
├── INSTALL.md                <-- Guía paso a paso de instalación
└── deploy-stow/              <-- ¡Directorio mágico para desplegar con Stow!
    └── .local/
        ├── bin/
        │   ├── MI_brave                  <-- Motor orquestador
        │   └── brave-cript-logan-nyk     <-- Wrapper de ejemplo (VPN)
        └── share/
            └── applications/
                └── brave-cript-logan-nyk.desktop <-- Lanzador gráfico
```

## 🚀 Instalación

Por favor, consulta el archivo [INSTALL.md](INSTALL.md) para ver las instrucciones de construcción de la imagen y cómo desplegar los scripts en tu sistema utilizando `stow`.

## 🎮 Parámetros del Motor (`MI_brave`)

Al crear tus propios *wrappers* dentro de `deploy-stow/.local/bin/`, puedes utilizar los siguientes parámetros del motor principal:

* `-c, --container`: Nombre del contenedor Podman (ej. `brave-aislado`).
* `-p, --profile`: Ruta absoluta donde se guardará la persistencia del navegador.
* `-n, --network`: Tipo de red. Opciones: `normal`, `tor`, o `vpn:<instancia>`.
* `-t, --tz`: Configura la zona horaria del contenedor (ej. `UTC`).
* `--audio`: Habilita el sonido inyectando el socket de PulseAudio.
* `--usb`: Mapea `/dev/bus/usb` (necesario para hardware wallets como Trezor o Ledger).

*(Cualquier argumento adicional se pasará directamente al binario de Brave, como por ejemplo `--class="cript-app"` para gestionar reglas de ventanas en tu WM).*

## 🐛 Diagnóstico y Logs

El orquestador lanza los contenedores en modo *detached* (`-d`). Para depurar fallos de arranque o problemas de Wayland, revisa los logs del contenedor:

```bash
podman logs -f <nombre-del-contenedor>
```
