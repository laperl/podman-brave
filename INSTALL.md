# Guía de Instalación y Despliegue 🚀

Este repositorio utiliza **GNU Stow** para gestionar los enlaces simbólicos de los scripts y archivos `.desktop` en tu directorio de usuario (`$HOME`), manteniendo tu sistema limpio y el repositorio autocontenido.

## ⚙️ Requisitos Previos

Asegúrate de tener instalados los siguientes paquetes en tu sistema (ej. Fedora, Arch, Debian):
* `podman` (configurado para uso rootless)
* `stow` (GNU Stow)
* Un entorno gráfico basado en **Wayland**

---

## 🛠️ Paso 1: Construir la Imagen Base de Podman

Antes de poder ejecutar cualquier instancia, necesitamos construir la imagen de contenedor que contiene Fedora, Brave Browser y las dependencias de Wayland/Audio.

Abre tu terminal en la raíz de este repositorio y ejecuta:

```bash
podman build -t localhost/fedora-brave:pro -f Containerfile .
```
*(Este proceso puede tardar unos minutos dependiendo de tu conexión a internet, ya que descargará los paquetes necesarios).*

Para reconstruir la imagen desde cero (sin reutilizar capas de compilaciones anteriores), añade la opción --no-cache:

```bash
podman build --no-cache -t localhost/fedora-brave:pro -f Containerfile .
 ```

---

## 🏗️ Paso 2: Crear tus Perfiles (Opcional)

Si necesitas añadir nuevos perfiles (billeteras, identidades, etc.), debes crear sus respectivos archivos dentro de la carpeta `deploy-stow` **antes** de desplegarlos.

1. **El Wrapper (Lanzador Bash):**
   Crea tu script en `deploy-stow/.local/bin/tu-perfil`
   ```bash
   #!/usr/bin/env bash
   exec "MI_browser" -c mi-contenedor -p "$HOME/Ruta/Segura" -n normal "$@"
   ```
   *No olvides darle permisos de ejecución:* `chmod +x deploy-stow/.local/bin/tu-perfil`

2. **El Archivo Desktop (Icono del menú):**
   Crea tu lanzador en `deploy-stow/.local/share/applications/tu-perfil.desktop`
   ```ini
   [Desktop Entry]
   Version=1.0
   Name=Brave Mi Perfil
   Exec=tu-perfil %U
   Icon=brave-browser
   Terminal=false
   Type=Application
   ```

---

## 🖼️ Paso 3: Configurar el Marco de la Ventana (Obligatorio)

**⚠️ No olvides este paso.** Para que cada navegador tenga el marco, el título y el comportamiento adecuados en Sway, es necesario editar la configuración de los `for_window`.

Abre el siguiente archivo del repositorio `dotfiles`:

```text
../src/github.com/laperl/dotfiles/sway/.config/sway/config.d/99-podman-browser.conf
```

Y añade o actualiza la regla correspondiente para la nueva instancia del navegador.

> **Importante:** Si omites este paso, el navegador seguirá funcionando, pero la ventana no tendrá el aspecto y comportamiento esperados.

---

## 🚀 Paso 4: Desplegar con Stow

Una vez que tengas la imagen construida y tus perfiles listos en la carpeta `deploy-stow`, es hora de instalarlos en tu sistema.

Ejecuta el siguiente comando desde la raíz del repositorio:

```bash
stow --target=$HOME deploy-stow
```

O su versión abreviada:

```bash
stow -t ~ deploy-stow
```

### ¿Qué hace este comando?
Stow leerá el contenido de la carpeta `deploy-stow` y creará enlaces simbólicos exactos en tu `$HOME`. 
* `deploy-stow/.local/bin/MI_browser`  ➡️  `~/.local/bin/MI_browser`
* `deploy-stow/.local/share/applications/...` ➡️ `~/.local/share/applications/...`

Ningún archivo real se mueve de tu repositorio, lo que significa que si haces un `git pull` con actualizaciones, tu sistema se actualizará automáticamente.

---

## 🧹 Desinstalación

Si algún día deseas eliminar los scripts y lanzadores de tu sistema, simplemente entra en el repositorio y dile a Stow que deshaga el trabajo:

```bash
stow -D -t ~ deploy-stow
```
*(Esto eliminará los enlaces simbólicos de tu `$HOME`, pero mantendrá los archivos intactos en tu repositorio).*
