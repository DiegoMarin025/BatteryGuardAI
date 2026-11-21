# BatteryGuard AI

Sistema de mantenimiento predictivo para baterías de vehículos eléctricos. Un modelo de machine learning estima la **probabilidad de falla** y la **vida útil restante (ciclos)** de cada batería, explica cada predicción con **SHAP** y prioriza qué baterías debe inspeccionar el taller. Incluye un asistente conversacional (**BatteryGuard AI**) que responde solo sobre la app con los datos reales de cada batería.

Proyecto final · Fundamentos de Inteligencia Artificial · Equipo BatteryGuard AI (Grupo LITIID71).

## Funcionalidades

- **Flota:** indicadores, batería prioritaria en 3D, umbral de riesgo ajustable con costo estimado, distribución de riesgo, curva de captura de fallas, riesgo por marca, salud vs. temperatura, Top 15 y lista priorizada paginada con filtros y exportación a CSV.
- **Batería:** diagnóstico del pack, explicación SHAP de los 5 factores principales, perfil frente a la flota, simulador «¿qué pasaría si…?», checklist de inspección, mediciones y exportación de la ficha.
- **Datos:** carga de CSV o Excel (.xlsx, .xls), revisión de calidad y puntuación con el modelo.
- **Asistente BatteryGuard AI:** chat en streaming (Groq) limitado a temas de la app.
- Tema claro y oscuro, diseño adaptable a móvil.

## Requisitos

| Componente | Versión |
|---|---|
| Python | 3.11 o superior (probado con 3.14.0) |
| Servidor | `http.server` de la librería estándar de Python |
| Interfaz | HTML, CSS y JavaScript (sin frameworks) |
| Machine learning | scikit-learn 1.9.1, SHAP 0.54, pandas 2.3, NumPy 2.3 |
| Asistente | Groq (SDK `groq` 1.7) |
| Sistema operativo probado | Windows 11 |

## Instalación

```bash
git clone <URL del repositorio>
cd <carpeta-del-proyecto>
python -m venv venv
# Windows: venv\Scripts\activate
# Linux/macOS: source venv/bin/activate
pip install -r requirements.txt
```

## Variables de entorno

Copiar `.env.example` como `.env` y completar:

| Variable | Descripción | Ejemplo |
|---|---|---|
| `IA_PROVEEDOR` | Proveedor del asistente | `groq` |
| `IA_API_KEY` | Llave de la API de Groq (https://console.groq.com/keys) | `gsk_...` |
| `IA_MODELO` | Opcional. Modelo principal | `openai/gpt-oss-120b` |
| `IA_MODELO_RESPALDO` | Opcional. Modelo si el principal está limitado | `qwen/qwen3.8-27b` |

Sin llave, la app funciona completa y el chat usa respuestas básicas generadas con la predicción del modelo.

## Arranque

```bash
python server.py
```

Abrir **http://localhost:8000**. En Windows también se puede usar doble clic en `iniciar.bat`, que instala dependencias y arranca el servidor. Otro puerto: `python server.py --port 8001`.

La primera carga del modelo tarda entre 10 y 30 segundos; después cada predicción responde en menos de 0.2 s.

**Credenciales de prueba:** no aplica (el sistema no tiene autenticación).

## Datos de prueba

- `datos_prueba/flota_prueba_400.xlsx`: 400 baterías reales del conjunto de prueba que el modelo no vio al entrenar (80 con falla real).
- `datos_prueba/escenarios_prueba.csv`: 10 escenarios controlados (sobrecalentamiento, alertas del BMS, desgaste, etc.).

Se cargan en la pantalla **Datos**. Resultados esperados en `datos_prueba/LEEME.txt`.

## Modelo

| Métrica (5,000 baterías de prueba) | Valor | Meta |
|---|---|---|
| Recall de la clase falla | 0.867 | ≥ 0.85 |
| Precisión | 0.617 | ≥ 0.55 |
| MAE de vida útil | 440.7 ciclos | ≤ 784 |

Gradient Boosting ajustado (61 variables, umbral recomendado 19 %) y Gradient Boosting Regressor para la vida útil. Código, entrenamiento y reportes en `modelo/` (ver `modelo/README.md`).

## Estructura

```
.
├── server.py            # servidor local: modelo + API + interfaz
├── asistente.py         # asistente BatteryGuard AI (Groq)
├── web/                 # interfaz: index.html, styles.css, app.js, charts.js, pack.js, anim.js
├── modelo/              # modelo de IA: src/, models/, data/, reports/, tests/
├── datos_prueba/        # archivos para probar la carga de datos
├── docs/                # guía de uso de la aplicación
├── requirements.txt
├── .env.example
└── iniciar.bat          # arranque con doble clic (Windows)
```

## API local

| Ruta | Función |
|---|---|
| `GET /api/flota` | Flota puntuada con `predecir_lote()` |
| `GET /api/bateria` | Predicción y explicación SHAP con `predecir()` |
| `POST /api/predecir` | Simulador: predicción con valores ajustados |
| `POST /api/revisar` | Lectura y calidad de un CSV o Excel |
| `POST /api/lote` | Puntuación del archivo revisado |
| `POST /api/chat/stream` | Respuesta del asistente en streaming |

## Equipo

- Leobardo Alexander Mex Tamayo · Datos y preprocesamiento
- Amerika Vannesa Carvajal Gatica · Modelado y experimentación
- Victor Emmanuel Canche Che · Pipeline e integración
- Antonella Junco Moran · Gerencia de proyecto y requerimientos
- Diego Alexander Marín Cruz · Requerimientos e interfaz
