# Firefox Customization (Firefox 154+)

Firefox almacena toda la configuración del usuario dentro del **perfil**.

En esta imagen, el perfil se encuentra en:

```text
/home/browser/.config/mozilla/firefox/<perfil>.default-release/
```

Por ejemplo:

```text
/home/browser/
├── .cache/
├── .config/
│   └── mozilla/
│       └── firefox/
│           ├── profiles.ini
│           └── xxxxxxxx.default-release/
│               ├── user.js
│               ├── prefs.js
│               ├── chrome/
│               │   ├── userChrome.css
│               │   └── userContent.css
│               ├── extensions/
│               ├── storage/
│               ├── cookies.sqlite
│               ├── places.sqlite
│               ├── cert9.db
│               ├── key4.db
│               └── ...
└── Downloads/
```

La ruta exacta del perfil puede consultarse en:

```
about:support
```

→ **Directorio del perfil**

---

## `user.js`

Configuración declarativa del usuario.

Firefox lee este fichero al iniciar y copia las preferencias a `prefs.js`.

Es el lugar recomendado para mantener la configuración permanente.

Ejemplo:

```javascript
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.startup.homepage", "about:home");
```

---

## `prefs.js`

Configuración efectiva utilizada por Firefox.

Este fichero lo mantiene Firefox automáticamente.

**No debe editarse manualmente.**

---

## `chrome/userChrome.css`

Personaliza la **interfaz del navegador**.

Ejemplos:

* ocultar la barra de pestañas;
* modificar barras de herramientas;
* cambiar tamaños;
* ocultar botones;
* cambiar colores;
* reorganizar elementos.

Para que Firefox lo cargue debe estar activado:

```javascript
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
```

---

## `chrome/userContent.css`

Personaliza el contenido mostrado por Firefox.

Se utiliza principalmente para:

* páginas `about:*`;
* visor PDF;
* contenido web (cuando corresponda).

No modifica la interfaz del navegador.

---

## Otros ficheros importantes

| Fichero              | Función                                    |
| -------------------- | ------------------------------------------ |
| `places.sqlite`      | Historial y marcadores                     |
| `cookies.sqlite`     | Cookies                                    |
| `permissions.sqlite` | Permisos por sitio                         |
| `cert9.db`           | Certificados                               |
| `key4.db`            | Claves privadas                            |
| `handlers.json`      | Asociaciones MIME                          |
| `containers.json`    | Multi-Account Containers                   |
| `extensions/`        | Extensiones instaladas                     |
| `storage/`           | Datos persistentes de sitios y extensiones |

---

## Buenas prácticas

* Mantener preferencias persistentes en `user.js`.
* No editar `prefs.js`.
* Mantener la personalización de la interfaz en `chrome/userChrome.css`.
* Mantener la personalización del contenido en `chrome/userContent.css`.
* Considerar cada perfil como completamente independiente.

---

## Compatibilidad

Válido para Firefox **154 y posteriores**.

Aunque la preferencia `toolkit.legacyUserProfileCustomizations.stylesheets` contiene la palabra *legacy*, sigue siendo el mecanismo utilizado por Firefox para cargar `userChrome.css` y `userContent.css`. Mozilla no garantiza que los selectores CSS internos permanezcan estables entre versiones, por lo que algunas reglas pueden requerir ajustes tras una actualización.

