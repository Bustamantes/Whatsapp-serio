# 📱 WhatsApp Serio

[![Godot Version](https://img.shields.io/badge/Godot-4.3%2B-blue?logo=godot-engine&logoColor=white)](https://godotengine.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Beta-orange.svg)]()

**WhatsApp Serio** es una aplicación educativa interactiva diseñada para ayudar a adultos mayores y personas con poca experiencia tecnológica a dominar WhatsApp paso a paso. Inspirada en la gamificación de plataformas como Duolingo, la app ofrece un camino de aprendizaje visual, intuitivo y divertido.

---

## ✨ Características Principales

- **🗺️ Ruta de Aprendizaje (Snake Path):** Un mapa de lecciones dinámico que guía al usuario por 12 módulos temáticos.
- **🦉 Gamificación Estilo Duolingo:**
  - Nodos de lección circulares con diseño 3D.
  - Indicadores de progreso y "racha" (🔥).
  - Personajes animados decorativos.
  - Feedback visual inmediato (animaciones de pulso, errores con *shake* y aciertos con *bounce*).
- **🎓 Evaluación Continua:** Exámenes al final de cada módulo para desbloquear nuevos contenidos.
- **🌙 Interfaz Moderna:** Tema oscuro premium con efectos de *glassmorphism* y tipografía de alta legibilidad.
- **📱 Contenido Completo:** Desde "Abrir la aplicación" hasta "Privacidad avanzada" y "Trucos útiles".

## 📸 Vista Previa

> [!TIP]
> La interfaz utiliza un diseño de "camino de serpiente" que se desplaza automáticamente a la posición de la lección activa del usuario.

| Pantalla de Módulos | Examen Interactivo | Detalle de Lección |
| :---: | :---: | :---: |
| *(Camino Duolingo)* | *(Feedback Shake/Bounce)* | *(Contenido Paso a Paso)* |

## 🛠️ Requisitos e Instalación

1. **Descargar Godot Engine 4.3 o superior.**
2. Clonar este repositorio:
   ```bash
   git clone https://github.com/TuUsuario/whatsapp-serio.git
   ```
3. Abrir Godot y seleccionar `Importar`.
4. Navegar hasta la carpeta del proyecto y seleccionar `project.godot`.
5. ¡Presionar F5 para ejecutar!

## 📂 Estructura del Proyecto

```text
Whatsapp-serio/
├── data/               # Contenido de las lecciones (JSON)
├── scenes/             # Escenas de Godot (.tscn)
├── scripts/            # Lógica en GDScript
│   ├── autoload/       # Singletons (Data/Progress Manager)
│   └── ui/             # Controladores de interfaz
└── project.godot       # Configuración del motor
```

## 🤝 Contribuciones

Si deseas mejorar las lecciones o el diseño, consulta nuestro archivo [CONTRIBUTING.md](CONTRIBUTING.md) para conocer la estrategia de ramas y reglas de estilo.

---

Desarrollado con ❤️ para empoderar a nuestros mayores.
