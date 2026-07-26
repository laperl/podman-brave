# Podman Browser Sandbox 🛡

Un motor de contenerización para ejecutar navegadores web completamente aislados utilizando Podman sin privilegios (*rootless*) en entornos Wayland nativos.

Diseñado para aislar entornos críticos, como billeteras de criptomonedas (Web3, DeFi), identidades independientes o navegación a través de redes Tor/VPN, reduciendo al mínimo la superficie de ataque mediante una orquestación estricta.

## ✨ Características

* **Multi-navegador:** Soporte para diferentes navegadores (Brave, Mullvad Browser y futuros navegadores basados en Chromium o Firefox).
* **Zero-Host Network:** No utiliza `--network=host`. Cada instancia vive en su propio *namespace* de red (`slirp4netns`), utiliza Tor o se conecta directamente a un contenedor VPN existente.
* **Auto-Start VPN:** Si se especifica una red VPN, el motor inicia automáticamente el servicio `systemd` correspondiente antes de lanzar el navegador.
* **Zero-Host Filesystem:** El navegador no tiene acceso al `$HOME` real del usuario. Cada instancia dispone de su propio directorio persistente.
* **Wayland Nativo:** Renderizado acelerado mediante `/dev/dri` y `WAYLAND_DISPLAY`, sin depender de X11 o Xwayland.
* **Spoofing de Entorno:** Permite definir una zona horaria (`TZ`) distinta para cada instancia con el fin de reducir el *fingerprinting*.
* **Motor Genérico:** Un único lanzador (`MI_browser`) sirve para cualquier navegador soportado.

## 📂 Estructura del Repositorio

```text
podman-browser/
├── containers/
│   ├── brave/
│   │   └── Containerfile
│   └── mullvad/
│       └── Containerfile
├── deploy-stow/
│   └── .local/
│       ├── bin/
│       │   ├── MI_browser
│       │   ├── brave-...
│       │   └── mullvad-...
│       └── share/
│           └── applications/
├── INSTALL.md
├── README.md
└── debug.md
```

- **containers/** contiene las imágenes OCI para cada navegador.
- **deploy-stow/** contiene los scripts y lanzadores que se instalan mediante GNU Stow.
- **MI_browser** es el motor encargado de crear y ejecutar los contenedores.

## 🚀 Instalación

Consulta [INSTALL.md](INSTALL.md) para construir las imágenes y desplegar los scripts mediante GNU Stow.

## 🎮 Parámetros de `MI_browser`

Al crear tus propios lanzadores dentro de `deploy-stow/.local/bin/`, puedes utilizar los siguientes parámetros:

* `-c, --container` — Nombre del contenedor Podman.
* `-i, --image` — Imagen OCI que se utilizará.
* `-p, --profile` — Directorio persistente asociado a la instancia.
* `-n, --network` — Tipo de red: `normal`, `tor` o `vpn:<instancia>`.
* `-t, --tz` — Zona horaria del contenedor.
* `--audio` — Habilita el acceso al servidor de audio.
* `--usb` — Permite acceso a dispositivos USB (Ledger, Trezor, etc.).

Cualquier argumento situado después de `--` se pasará directamente al navegador.

Ejemplo:

```bash
MI_browser \
    -i localhost/brave:pro \
    -c brave-wallet \
    -p ~/browser_profiles/brave-wallet \
    -n vpn:wg-personal \
    -- \
    --class=brave-wallet
```

## 🐛 Diagnóstico

Para inspeccionar un contenedor en ejecución:

```bash
podman logs -f <nombre-del-contenedor>
```

Para comprobar el estado de las instancias:

```bash
podman ps -a
```
