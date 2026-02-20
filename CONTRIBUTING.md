# Guía de Contribución y Estrategia de Ramas

¡Gracias por querer contribuir a **WhatsApp Serio**! Para mantener el proyecto profesional y organizado, seguimos una estrategia de ramas basada en Git Flow simplificado.

## 🌿 Estrategia de Ramas

Para garantizar la estabilidad del código, el repositorio se organiza de la siguiente manera:

- **`main`**: Solo contiene código estable y probado. Es la rama que se descarga para producción.
- **`develop`**: Rama principal para el desarrollo. Aquí es donde se integran las nuevas funcionalidades antes de pasar a `main`.
- **`feature/nombre-de-la-mejora`**: Ramas temporales para trabajar en una funcionalidad específica (ej: `feature/nuevos-emojis`, `feature/traduccion-ingles`). Una vez terminadas, se fusionan con `develop`.
- **`bugfix/descripcion-del-error`**: Ramas para corregir errores detectados en `develop` o `main`.

### Flujo de Trabajo Recomendado

1. Crea una nueva rama desde `develop`: `git checkout -b feature/mi-nueva-mejora`
2. Realiza tus cambios y haz *commits* descriptivos: `git commit -m "Añadir animación de pulso al nodo de examen"`
3. Sube tu rama a GitHub: `git push origin feature/mi-nueva-mejora`
4. Abre un **Pull Request** hacia la rama `develop`.

## 🎨 Estilo de Código (GDScript)

- Usa **Snake Case** para nombres de archivos y variables (`mi_variable`).
- Usa **PascalCase** para nombres de clases.
- Documenta las funciones complejas con comentarios breves.
- Mantén la separación entre lógica (Scripts) e interfaz (Scenes).

## 🐛 Reporte de Errores

Si encuentras un error, por favor abre un *Issue* describiendo:
- Qué estabas haciendo.
- Qué esperabas que pasara.
- Qué pasó realmente (adjunta capturas si es posible).

---

¡Tu ayuda hace que la tecnología sea más accesible para todos!
