# Utilizar Fedora Latest como base
FROM registry.fedoraproject.org/fedora:latest

LABEL maintainer="tu-usuario"
LABEL description="Imagen base de Fedora con Brave para aislamiento rootless en Wayland"

# Instalar herramientas base y el repositorio de Brave
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo && \
    rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# Actualizar sistema e instalar dependencias (Brave, gráfica, audio, fuentes)
RUN dnf upgrade -y && \
    dnf install -y \
        brave-browser \
        mesa-dri-drivers libglvnd-glx libglvnd-egl vulkan-loader \
        pulseaudio-libs alsa-lib \
        google-noto-sans-fonts google-noto-color-emoji-fonts \
        dbus dbus-x11 libcanberra-gtk3 pciutils \
    && dnf clean all

# Crear usuario sin privilegios para ejecutar Chromium/Brave
RUN useradd -m -u 1000 braveuser

USER braveuser
WORKDIR /home/braveuser

ENV DBUS_SESSION_BUS_ADDRESS="autolaunch:"

ENTRYPOINT ["/usr/bin/brave-browser"]
