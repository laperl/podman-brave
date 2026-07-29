# Podman Browser Sandbox 🛡️

Un motor de contenerización avanzado para ejecutar navegadores web completamente aislados utilizando **Podman sin privilegios (*rootless*)** en entornos **Wayland nativos**.

Diseñado para aislar identidades, entornos críticos como billeteras de criptomonedas (Web3, DeFi), o navegación a través de redes VPN/Tor, reduciendo al mínimo la superficie de ataque mediante una orquestación estricta del contenedor y del almacenamiento.

---

## ✨ Características Principales

* **Universal y Agnóstico (Multi-Navegador):** Un único motor (`MI_browser`) con soporte nativo e higiénico para **Gecko / Firefox** (Firefox Dev, Mullvad Browser), **Chromium** (Brave, Chrome) y aplicaciones **Qt**.
* **Wayland Nativo Universal:** Exporta de forma transparente variables de entorno globales (`MOZ_ENABLE_WAYLAND`, `ELECTRON_OZONE_PLATFORM_HINT`, `QT_QPA_PLATFORM`) e inyecta sockets gráficos para aceleración directa por hardware (`/dev/dri/renderD128`) sin pasar por Xwayland.
* **Aislamiento de Red Granular (Zero-Host Network):**
  * **`normal`:** Red aislada mediante `slirp4netns`.
  * **`tor`:** Enrutamiento obligatorio mediante SOCKS5 proxy hacia Tor.
  * **`vpn:<instancia>`:** Integración directa con contenedores VPN (`Gluetun`). Mantiene auto-start via `systemctl --user` si la VPN no está activa.
* **Mapeo de Almacenamiento y Descargas Flexible:**
  * **Perfil Persistente Obligatorio:** Montado en `/home/browser`.
  * **Mapeo de Descargas Opcional (`-d, --downloads`):** Monta un directorio del host en `/home/browser/Downloads`. Si se omite, las descargas se quedan aisladas dentro del volumen del perfil.
* **Spoofing de Entorno:** Permite definir la zona horaria (`TZ`) por perfil para mitigar el *fingerprinting*.
* **Soporte de Hardware Avanzado:**
  * **Audio:** Inyección opcional de sockets de PulseAudio / PipeWire.
  * **USB Passthrough:** Soporte para dispositivos USB (Ledger, Trezor, YubiKeys, etc.).
* **Integración con GNU Stow:** Estructura modular preparada para desplegar ejecutable y accesos directos `.desktop` en el entorno del usuario.

---

## 📂 Estructura del Repositorio

```text
podman-browser/
├── containers/
│   ├── brave/
│   │   └── Containerfile
│   ├── firefox/
│   │   └── Containerfile
│   └── mullvad/
│       └── Containerfile
├── deploy-stow/
│   └── .local/
│       ├── bin/
│       │   ├── MI_browser                # Motor principal
│       │   ├── brave-causanon-ntl
│       │   ├── brave-cript-jaume
│       │   ├── brave-cript-logan-nyk
│       │   ├── firefox-dev-logan-nyk
│       │   └── mullvad-andresmultini-nwy
│       └── share/
│           └── applications/             # Archivos .desktop correspondientes
├── INSTALL.md
├── README.md
└── DEBUG.md

```

---

## 🚀 Instalación y Despliegue

Consulta la guía paso a paso en [INSTALL.md](INSTALL.md) para construir las imágenes OCI, configurar los marcos de ventana en tu Tiling Window Manager (Sway/Hyprland) y desplegar las aplicaciones mediante GNU Stow.

---

## 🎮 Opciones y Uso de `MI_browser`

```text
Uso:
    MI_browser --profile PERFIL [opciones] [-- argumentos_navegador]

```

### Tabla de Parámetros:

| Opción | Descripción | Requerido / Defecto |
| --- | --- | --- |
| `-p, --profile DIR` | Directorio local persistente. Se montará en `/home/browser`. | **Obligatorio** |
| `-d, --downloads DIR` | Directorio local para guardar descargas. Se montará en `/home/browser/Downloads`. | Opcional (Aislado si se omite) |
| `-c, --container NAME` | Nombre único para el contenedor de Podman. | Por defecto: `browser` |
| `-i, --image IMAGE` | Imagen OCI a utilizar para lanzar el navegador. | Por defecto: `localhost/brave:pro` |
| `-n, --network MODE` | Modo de red: `normal`, `tor` o `vpn:<INSTANCIA>`. | Por defecto: `normal` |
| `-t, --tz ZONA` | Zona horaria para el contenedor (ej. `America/New_York`). | Opcional |
| `--audio` | Opciones de integración para audio (PipeWire/PulseAudio). | Deshabilitado por defecto |
| `--usb` | Habilita acceso a `/dev/bus/usb` (Firmas, Llaves de seguridad). | Deshabilitado por defecto |
| `--` | Separador. Cualquier flag posterior pasa directamente al navegador. | Opcional |

---

## 💡 Ejemplos de Uso

### 1. Firefox Dev con VPN dedicada, Zona Horaria y Descargas

```bash
MI_browser \
  -c firefox-dev-logan-nyk \
  -i localhost/fedora-firefox:pro \
  -p "$HOME/Documents/SECURE_vc/browser_profiles/firefox/firefox-dev-logan-nyk" \
  -d "$HOME/Baixades/podman-browser/firefox-dev-logan-nyk" \
  -n vpn:wg-logan-nyk \
  -t "America/New_York" \
  --audio \
  -- \
  --name="dev-logan-nyk" \
  about:support

```

### 2. Brave Aislado con Red Tor y Soporte USB (Hardware Wallets)

```bash
MI_browser \
  -c brave-tor-crypto \
  -i localhost/brave:pro \
  -p "$HOME/perfiles/brave-tor" \
  -n tor \
  --usb \
  -- \
  --class="brave-crypto"

```

---

## 🐛 Diagnóstico y Registros

Ver logs de la instancia en tiempo real:

```bash
podman logs -f <nombre-del-contenedor>

```

Inspeccionar contenedores activos o detenidos:

```bash
podman ps -a

```
