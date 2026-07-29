# Guía de Instalación y Despliegue 🚀

Este repositorio utiliza **GNU Stow** para gestionar de forma transparente los enlaces simbólicos de los scripts lanzadores y archivos de escritorio (`.desktop`) en tu usuario (`$HOME`), manteniendo el sistema limpio y modular.

---

## ⚙️ Requisitos Previos

Asegúrate de contar con las siguientes dependencias instaladas en tu sistema host:
* `podman` (configurado en modo *rootless*).
* `stow` (GNU Stow).
* `realpath` y `systemctl` (disponibles habitualmente en sistemas systemd).
* Un entorno gráfico basado en **Wayland** (Sway, Hyprland, Gnome Wayland, etc.).

---

## 🛠️ Paso 1: Construir las Imágenes OCI (Podman)

Puedes construir la imagen correspondiente al navegador que desees utilizar. 

### Opción A: Imagen Fedora + Brave Browser
```bash
podman build -t localhost/fedora-brave:pro -f containers/brave/Containerfile .

```

### Opción B: Imagen Fedora + Firefox / Firefox Developer Edition

```bash
podman build -t localhost/fedora-firefox:pro -f containers/firefox/Containerfile .

```

> **Nota:** Si deseas hacer una reconstrucción limpia ignorando la caché previa:
> ```bash
> podman build --no-cache -t localhost/fedora-firefox:pro -f containers/firefox/Containerfile .
> 
> ```
> 
> 

---

## 🏗️ Paso 2: Crear tus Perfiles y Wrappers

Dentro del directorio `deploy-stow/` definirás los lanzadores que consumirá tu sistema.

### 1. Crear el Wrapper (Script ejecutable)

Añade tu script en `deploy-stow/.local/bin/tu-lanzador`:

```bash
#!/usr/bin/env bash
set -euo pipefail

exec "$HOME/.local/bin/MI_browser" \
  -c firefox-dev-logan-nyk \
  -i localhost/fedora-firefox:pro \
  -p "$HOME/Documentos/perfiles/firefox-dev-logan-nyk" \
  -d "$HOME/Descargas/firefox-dev-logan-nyk" \
  -n vpn:wg-logan-nyk \
  -t "America/New_York" \
  --audio \
  -- \
  --name="dev-logan-nyk" \
  "$@"

```

*Asegúrate de concederle permisos de ejecución:*

```bash
chmod +x deploy-stow/.local/bin/tu-lanzador

```

### 2. Crear el Lanzador de Escritorio (`.desktop`)

Crea tu acceso directo en `deploy-stow/.local/share/applications/tu-lanzador.desktop`:

```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox Dev (Logan NYK)
Comment=Navegador aislado en contenedor Podman con VPN
Exec=firefox-dev-logan-nyk %U
Icon=firefox-developer-edition
Terminal=false
Categories=Network;WebBrowser;

```

---

## 🖼️ Paso 3: Configurar el Marco de la Ventana en Sway / Tiling WM (Obligatorio)

Para garantizar que el gestor de ventanas asigne reglas, títulos, flotación o bordes correctos según la instancia, mapea la clase/nombre definida mediante las flags pasadas tras `--` (por ejemplo `--class=...` o `--name=...`).

Si utilizas **Sway**, actualiza el archivo de configuración correspondiente (ej. `~/.config/sway/config.d/99-podman-browser.conf`):

```text
# Ejemplo de regla para Firefox Dev / Logan NYK
for_window [app_id="firefox" title=".*dev-logan-nyk.*"] border pixel 2, client.focused #ffb52a

# Ejemplo de regla para Brave Cripto
for_window [class="Brave-browser" instance="brave-cript-jaume"] border pixel 2

```

---

## 🚀 Paso 4: Desplegar con Stow

Una vez preparados los scripts en `deploy-stow/`, enlázalos a tu directorio `$HOME` ejecutando desde la raíz del repositorio:

```bash
stow -t ~ deploy-stow

```

### Estrategia de Enlaces Generada:

* `deploy-stow/.local/bin/*` ➡️ `~/.local/bin/*`

* `deploy-stow/.local/share/applications/*` ➡️ `~/.local/share/applications/*`


Cualquier actualización realizada en el repositorio estará disponible de inmediato en tu sistema sin necesidad de copiar archivos manualmente.

---

## 🧹 Desinstalación o Limpieza

Para desvincular los enlaces simbólicos instalados en tu `$HOME` manteniendo intactos los archivos del repositorio, ejecuta:

```bash
stow -D -t ~ deploy-stow

```
