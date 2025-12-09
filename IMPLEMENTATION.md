# Miauni - Documentación Completa del Proyecto

> ⚠️ **DISCLAIMER: Documentación Generada por IA**  
> Este documento ha sido generado automáticamente por inteligencia artificial como parte del proceso de desarrollo del proyecto Miauni.

---

## 📋 Resumen del Proyecto

**Miauni** es una aplicación móvil de finanzas personales desarrollada en Flutter, diseñada específicamente para estudiantes universitarios chilenos. La app funciona 100% offline con almacenamiento local, sin requerir conexión a internet, login o sincronización en la nube.

## 🏗️ Arquitectura

### Estructura de Archivos

```
lib/
├── models/
│   ├── transaction.dart              # Modelo principal con adaptador Hive
│   └── transaction.g.dart            # Generado automáticamente por build_runner
├── services/
│   ├── transactions_service.dart     # Gestión CRUD de transacciones
│   └── streak_service.dart           # Lógica de racha de ahorro
├── providers/
│   └── transactions_provider.dart    # Estado global con ChangeNotifier
├── screens/
│   ├── home_screen.dart              # Pantalla principal (integrada)
│   ├── history_screen.dart           # Historial de transacciones (integrada)
│   ├── stats_screen.dart             # Estadísticas (integrada)
│   └── add_transaction_screen.dart   # Formulario para agregar transacciones
├── widgets/                          # Widgets reutilizables (existentes)
├── styles/                           # Colores y estilos de texto
├── utils/                            # Utilidades (vacío por ahora)
└── main.dart                         # Punto de entrada (actualizado)
```

## 🔧 Tecnologías Utilizadas

### Almacenamiento Local

**Hive** - Base de datos NoSQL ligera y rápida

**¿Por qué Hive y no SQLite?**

- ✅ No requiere SQL (más simple)
- ✅ Más rápido para operaciones de lectura/escritura
- ✅ Perfecto para apps offline
- ✅ TypeAdapter generado automáticamente
- ✅ Soporte nativo para tipos complejos

### Gestión de Estado

**Provider** - Patrón ChangeNotifier

**¿Por qué Provider y no Riverpod?**

- ✅ Más simple y directo para este caso de uso
- ✅ Menos boilerplate
- ✅ Ideal para apps pequeñas/medianas
- ✅ Bien documentado y maduro

### Dependencias Principales

```yaml
dependencies:
  provider: ^6.1.2 # Estado global
  hive: ^2.2.3 # Base de datos local
  hive_flutter: ^1.1.0 # Integración con Flutter
  uuid: ^4.5.1 # Generación de IDs únicos
  intl: ^0.19.0 # Formato de fechas/números

dev_dependencies:
  hive_generator: ^2.0.1 # Generación de adaptadores
  build_runner: ^2.4.13 # Ejecutor de generadores
```

## 📊 Modelo de Datos

### Transaction

```dart
class Transaction {
  String id;                    // UUID único
  TransactionType type;         // income / expense
  double amount;                // Monto
  String category;              // Ej: "🍔 Comida"
  DateTime date;                // Fecha de creación
  String? note;                 // Nota opcional
}
```

### TransactionType (Enum)

- `income` - Ingresos
- `expense` - Gastos

## 🔄 Servicios

### TransactionsService (Singleton)

Gestiona todas las operaciones CRUD con Hive.

**Métodos principales:**

- `init()` - Inicializa Hive y registra adaptadores
- `addTransaction(Transaction)` - Crea nueva transacción
- `updateTransaction(Transaction)` - Actualiza existente
- `deleteTransaction(String id)` - Elimina por ID
- `getAllTransactions()` - Obtiene todas
- `watchTransactions()` - Stream reactivo
- `getCurrentMonthTransactions()` - Filtra por mes actual

### StreakService (Singleton)

Gestiona la lógica de racha de ahorro.

**Lógica de racha:**

1. Se cuenta un día si hay al menos 1 ingreso con categoría "Ahorro" o "Beca"
2. Los días deben ser consecutivos (sin saltos)
3. Si pasa un día sin registro, la racha se resetea
4. Guarda `currentStreak` y `bestStreak`

**Métodos principales:**

- `init()` - Abre box de Hive para streak_data
- `recomputeStreak(List<Transaction>)` - Recalcula racha
- `get currentStreak` - Racha actual
- `get bestStreak` - Mejor racha histórica

## 🎯 Provider (Estado Global)

### TransactionsProvider

Controlador principal que expone:

**Listas:**

- `transactions` - Todas (ordenadas por fecha)
- `incomes` - Solo ingresos
- `expenses` - Solo gastos
- `currentMonthTransactions` - Del mes actual

**Totales:**

- `totalIncome` - Suma de todos los ingresos
- `totalExpense` - Suma de todos los gastos
- `currentBalance` - Ingresos - Gastos
- `currentMonthIncome` - Ingresos del mes
- `currentMonthExpense` - Gastos del mes
- `currentMonthBalance` - Balance del mes

**Racha:**

- `currentStreak` - Días consecutivos ahorrando
- `bestStreak` - Mejor racha histórica

**Métodos:**

- `addTransaction(Transaction)` - Agregar
- `updateTransaction(Transaction)` - Actualizar
- `deleteTransaction(String id)` - Eliminar
- `getTransactionsByCategory(String)` - Filtrar
- `getExpensesByCategory()` - Agrupar gastos

## 📱 Pantallas Integradas

### 🏠 HomeScreen

**Funcionalidad:**

- ✅ Muestra balance del mes actual (datos reales)
- ✅ Muestra racha de ahorro en header
- ✅ Botones GASTO/INGRESO navegan a AddTransactionScreen
- ✅ Card "Este mes" muestra cantidad de transacciones
- ✅ Usa Consumer<TransactionsProvider> para actualizaciones reactivas

### 📋 HistoryScreen

**Funcionalidad:**

- ✅ Lista todas las transacciones (datos reales)
- ✅ Ordenadas por fecha (más reciente primero)
- ✅ Separadores de fecha
- ✅ Filtros funcionales:
  - Por tipo (Todo/Ingreso/Gasto)
  - Por tiempo (Hoy/7 días/30 días)
  - Por categoría
- ✅ Filtros colapsables para ahorrar espacio
- ✅ Dismissible para eliminar con confirmación
- ✅ Estado vacío cuando no hay transacciones

### 📊 StatsScreen

**Funcionalidad:**

- ✅ 4 cards con totales (Ingresos/Gastos/Ahorro/Tasa)
- ✅ Gastos agrupados por categoría
- ✅ Top 5 categorías con porcentajes
- ✅ Metas de ahorro (placeholder basado en balance)
- ✅ Todos los números calculados desde el provider

### ➕ AddTransactionScreen

**Funcionalidad:**

- ✅ Selector de tipo (Gasto/Ingreso)
- ✅ Campo de monto con validación
- ✅ Selector de categoría (chips)
- ✅ Campo de nota opcional
- ✅ Guarda y regresa a la pantalla anterior
- ✅ Feedback visual (SnackBar)

## 🚀 Inicialización

### main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar servicios de storage
  await TransactionsService.instance.init();
  await StreakService.instance.init();

  // 2. Inicializar formato de fechas en español
  await initializeDateFormatting('es_ES', null);

  // 3. Lanzar app envuelta en Provider
  runApp(const MyApp());
}
```

## ✅ Funcionalidades Implementadas

### CRUD Completo

- ✅ Crear transacciones (ingresos y gastos)
- ✅ Leer todas las transacciones
- ✅ Eliminar transacciones (con confirmación)
- ⏳ Actualizar transacciones (implementado pero no expuesto en UI)

### Filtrado y Búsqueda

- ✅ Filtrar por tipo (Ingreso/Gasto)
- ✅ Filtrar por período (Hoy/7 días/30 días)
- ✅ Filtrar por categoría
- ✅ Filtros colapsables

### Cálculos Automáticos

- ✅ Balance total y por mes
- ✅ Totales de ingresos y gastos
- ✅ Tasa de ahorro (%)
- ✅ Gastos agrupados por categoría con porcentajes

### Racha de Ahorro

- ✅ Detección automática de días consecutivos
- ✅ Reseteo si pasa un día sin ahorro
- ✅ Mejor racha histórica guardada
- ✅ Actualización en tiempo real

### UI/UX

- ✅ Actualización reactiva con Provider
- ✅ Estados vacíos con mensajes
- ✅ Confirmaciones para acciones destructivas
- ✅ Feedback visual (SnackBars)
- ✅ Formato de números con separadores de miles
- ✅ Fechas en español

## 🎨 Categorías Predefinidas

### Gastos

- 🎓 Estudios
- 🎉 Carrete
- 🍔 Comida
- 🍕 Delivery
- 🚌 Transporte
- 🎮 Entretenimiento
- 👕 Ropa
- 💊 Salud
- 🛒 Supermercado

### Ingresos

- 🎓 Beca
- 💼 Trabajo
- 💰 Ahorro (cuenta para racha)
- 🎁 Regalo
- 📈 Inversión

## 📝 Notas Técnicas

### Persistencia

- Todos los datos se guardan automáticamente en el dispositivo
- No requiere conexión a internet
- Los datos persisten entre sesiones
- Ubicación: Directorio de la app (gestionado por Hive)

### Performance

- Lecturas/escrituras rápidas con Hive
- Stream reactivo para actualizaciones en tiempo real
- Filtros calculados en memoria (eficiente para <10k transacciones)
- Consumer<Provider> solo reconstruye lo necesario

### Seguridad

- Datos 100% locales (no salen del dispositivo)
- Sin login/autenticación (app personal)
- Sin encriptación (puede agregarse con Hive Encrypted Box)

## 🔮 Próximas Mejoras (No Implementadas)

### Funcionalidad

- [ ] Editar transacciones existentes (UI)
- [ ] Categorías personalizadas
- [ ] Presupuestos configurables por categoría
- [ ] Exportar datos a CSV
- [ ] Gráficos visuales (fl_chart)
- [ ] Metas de ahorro personalizadas
- [ ] Notificaciones de racha

### Técnico

- [ ] Tests unitarios
- [ ] Tests de integración
- [ ] Migraciones de base de datos
- [ ] Backup/restore
- [ ] Encriptación de datos

## 🐛 Testing

### Comandos Útiles

```bash
# Análisis de código
flutter analyze

# Ejecutar tests (cuando se creen)
flutter test

# Limpiar y regenerar
flutter clean && flutter pub get

# Regenerar adaptadores de Hive
dart run build_runner build --delete-conflicting-outputs
```

### Datos de Prueba

La app inicia vacía. Usa los botones GASTO/INGRESO para agregar transacciones.

Para resetear todos los datos:

1. Desinstala la app
2. O usa `Hive.deleteBoxFromDisk()` en código

## 📚 Referencias

- [Hive Documentation](https://docs.hivedb.dev/)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Flutter Documentation](https://docs.flutter.dev/)

---

## 📂 Documentación Completa de Archivos del Proyecto

### 📱 Screens (Pantallas)

#### `lib/screens/home_screen.dart`

**Propósito:** Pantalla principal de la aplicación

**Estado:** ✅ Completamente funcional con datos reales

**Características:**

- Header con emoji de casa y saludo personalizado
- Indicador de racha de ahorro en tiempo real (🔥 X días)
- BalanceCard que muestra balance, ingresos y gastos del mes actual
- Mensaje motivacional del gato pixel
- Botones de acción para agregar GASTO e INGRESO
- Navegación inferior con 3 pestañas: Inicio, Stats, Historial
- Usa Consumer<TransactionsProvider> para actualización reactiva

**Dependencias:**

- Provider para estado global
- TransactionsProvider para datos
- AddTransactionScreen para agregar transacciones
- Widgets: BalanceCard, ActionButton

**Flujo de navegación:**

- Botón GASTO → AddTransactionScreen(type: expense)
- Botón INGRESO → AddTransactionScreen(type: income)
- Bottom nav → cambia entre Home, Stats, History

---

#### `lib/screens/stats_screen.dart`

**Propósito:** Pantalla de estadísticas y análisis financiero

**Estado:** ✅ Completamente funcional con datos calculados

**Características:**

- Header con fecha actual formateada en español
- 4 tarjetas de resumen:
  - Ingresos totales (color verde menta)
  - Gastos totales (color coral)
  - Ahorro total (color azul)
  - Tasa de ahorro en % (color morado)
- Sección "Gastos por Categoría":
  - Placeholder para gráfico circular
  - Lista top 5 categorías con porcentajes
  - Colores alternados automáticamente
- Sección "Últimos 7 días": Placeholder para gráfico
- Sección "Metas de Ahorro":
  - Fondo de emergencia (calculado como 45% del balance)
  - Viaje de verano (calculado como 32% del balance)
  - Barras de progreso visuales

**Cálculos automáticos:**

- Total ingresos/gastos desde provider
- Balance = ingresos - gastos
- Tasa ahorro = (balance / ingresos) \* 100
- Porcentaje por categoría = (gasto categoría / total gastos) \* 100

**Datos mostrados:**

- Si no hay transacciones → mensaje "No hay gastos registrados"
- Si hay datos → estadísticas calculadas en tiempo real

---

#### `lib/screens/history_screen.dart`

**Propósito:** Historial completo de transacciones con filtros

**Estado:** ✅ Completamente funcional con filtros y eliminación

**Características:**

- Header con emoji de portapapeles
- Sistema de filtros colapsable:
  - Botón "Filtros" con indicador de filtros activos (punto rojo)
  - Filtro por Tipo: Todo, Ingreso, Gasto
  - Filtro por Período: Todo, Hoy, Últimos 7 días, Últimos 30 días
  - Filtro por Categoría: Todas + categorías disponibles
  - Secciones separadas con líneas divisorias
- Lista de transacciones:
  - Agrupadas por fecha con separadores
  - Formato de fecha en español (ej: "miércoles 10 de diciembre")
  - Cards con emoji de categoría, nombre, nota opcional y monto
  - Color de fondo según tipo (rojo para gastos, verde para ingresos)
  - Swipe para eliminar con confirmación
- Estado vacío: Muestra emoji de buzón vacío y mensaje

**Filtros implementados:**

- `_getFilteredTransactions()`: Aplica todos los filtros activos
- Filtro de tipo: compara TransactionType
- Filtro de tiempo: calcula rangos de fechas
- Filtro de categoría: comparación exacta de strings

**Interacciones:**

- Tap en "Filtros" → expande/colapsa panel
- Tap en chip de filtro → activa/desactiva filtro
- Swipe left en transacción → muestra botón rojo de eliminar
- Confirmar eliminación → elimina de Hive y actualiza UI

---

#### `lib/screens/add_transaction_screen.dart`

**Propósito:** Formulario para crear nuevas transacciones

**Estado:** ✅ Completamente funcional con validación

**Características:**

- AppBar con botón de cerrar (X)
- Selector de tipo (Gasto/Ingreso) con botones grandes
- Campo de monto:
  - Teclado numérico
  - Prefijo $ automático
  - Validación de número válido > 0
  - Style grande (heading2)
- Selector de categorías:
  - Chips con emojis
  - Categorías diferentes para gasto e ingreso
  - Color de fondo cambia al seleccionar
  - Auto-scroll horizontal
- Campo de nota opcional:
  - 3 líneas de altura
  - Placeholder: "Agrega una descripción..."
- Botón GUARDAR:
  - Valida formulario
  - Genera UUID automático
  - Guarda con fecha actual
  - Muestra SnackBar de confirmación
  - Cierra pantalla automáticamente

**Categorías predefinidas:**

Gastos:

- 🎓 Estudios, 🎉 Carrete, 🍔 Comida
- 🍕 Delivery, 🚌 Transporte, 🎮 Entretenimiento
- 👕 Ropa, 💊 Salud, 🛒 Supermercado

Ingresos:

- 🎓 Beca, 💼 Trabajo, 💰 Ahorro
- 🎁 Regalo, 📈 Inversión

**Validaciones:**

- Monto no vacío y > 0
- Categoría seleccionada
- Tipo seleccionado (siempre tiene valor por default)

---

### 🎨 Widgets (Componentes Reutilizables)

#### `lib/widgets/balance_card.dart`

**Propósito:** Tarjeta que muestra el balance mensual

**Props:**

- `balance` (double): Balance neto del mes
- `income` (double): Total ingresos del mes
- `expense` (double): Total gastos del mes

**Diseño:**

- Fondo blanco con borde negro de 2px
- Balance grande en el centro
- Dos columnas abajo: Ingresos (verde) y Gastos (rojo)
- Formato de números con separador de miles

---

#### `lib/widgets/action_button.dart`

**Propósito:** Botón grande de acción para agregar transacciones

**Props:**

- `label` (String): Texto del botón
- `icon` (IconData): Icono a mostrar
- `backgroundColor` (Color): Color de fondo
- `onPressed` (VoidCallback): Función al presionar

**Diseño:**

- Altura de 56px
- Borde negro de 2px
- Icono + texto centrados
- Elevación 0 (flat design)

---

#### `lib/widgets/budget_card.dart`

**Propósito:** ⚠️ **YA NO SE USA** - Fue eliminado del proyecto

**Estado:** ❌ Deprecated - El componente existe pero no se utiliza en ninguna pantalla

---

### 🎨 Styles (Estilos)

#### `lib/styles/colors.dart`

**Propósito:** Paleta de colores del proyecto

**Colores definidos:**

```dart
background: Color(0xFFF5F5F5)    // Gris claro para fondo
mintGreen: Color(0xFFB8E6D5)    // Verde menta (ingresos)
coral: Color(0xFFFFA69E)         // Coral (gastos)
teal: Color(0xFF4ECDC4)          // Turquesa (acentos)
darkGreen: Color(0xFF006B54)    // Verde oscuro (textos ingresos)
textPrimary: Color(0xFF1A1A1A)  // Negro para textos
textSecondary: Color(0xFF666666) // Gris para textos secundarios
borderDark: Color(0xFF1A1A1A)   // Negro para bordes
```

**Uso:**

- Ingresos: mintGreen con texto darkGreen
- Gastos: coral (0xFFFEE2E2 para fondos más suaves)
- Bordes: siempre borderDark con width: 2
- Fondos: background para páginas, white para cards

---

#### `lib/styles/text_styles.dart`

**Propósito:** Estilos de texto consistentes

**Estilos definidos:**

```dart
heading1: 32px, bold              // Títulos principales
heading2: 24px, bold              // Títulos de sección
heading3: 18px, w600              // Subtítulos
bodyBold: 14px, w600              // Texto en negrita
bodyRegular: 14px, w400           // Texto normal
caption: 12px, w400               // Textos pequeños
```

**Convención:**

- Todos usan color textPrimary por defecto
- Se puede override con .copyWith(color: ...)
- Font family: Roboto (definido en theme)

---

### 🗄️ Models (Modelos de Datos)

#### `lib/models/transaction.dart`

**Propósito:** Modelo principal de transacciones con adaptador Hive

**Annotations:**

- `@HiveType(typeId: 0)` para Transaction class
- `@HiveType(typeId: 1)` para TransactionType enum
- `@HiveField(N)` para cada campo

**Campos:**

```dart
String id           // UUID único
TransactionType type // income o expense
double amount       // Monto en pesos
String category     // "🎓 Estudios", "🍔 Comida", etc.
DateTime date       // Fecha y hora de creación
String? note        // Nota opcional (nullable)
```

**Helpers:**

- `isIncome`: getter booleano
- `isExpense`: getter booleano
- `signedAmount`: monto con signo (+ o -)
- `copyWith()`: crear copia con modificaciones
- `toString()`: representación de string para debug

**Generación:**

- `transaction.g.dart` generado con `build_runner`
- Adaptadores TransactionAdapter y TransactionTypeAdapter

---

#### `lib/models/transaction.g.dart`

**Propósito:** Adaptadores Hive generados automáticamente

**Estado:** ✅ Auto-generado (no editar manualmente)

**Contiene:**

- TransactionAdapter (typeId: 0)
- TransactionTypeAdapter (typeId: 1)
- Métodos read/write para serialización

**Regenerar:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

### ⚙️ Services (Servicios)

#### `lib/services/transactions_service.dart`

**Propósito:** Servicio singleton para gestionar transacciones con Hive

**Pattern:** Singleton con `instance` getter

**Métodos públicos:**

**Inicialización:**

- `init()`: Inicializa Hive, registra adaptadores, abre box
  - DEBE llamarse en main() antes de runApp()
  - Solo se ejecuta una vez

**CRUD básico:**

- `addTransaction(Transaction)`: Guarda nueva transacción
- `updateTransaction(Transaction)`: Actualiza existente por ID
- `deleteTransaction(String id)`: Elimina por ID
- `getAllTransactions()`: Retorna lista completa
- `getTransaction(String id)`: Obtiene una por ID

**Queries:**

- `getTransactionsByType(TransactionType)`: Filtra por income/expense
- `getTransactionsByDateRange(DateTime, DateTime)`: Rango de fechas
- `getCurrentMonthTransactions()`: Solo del mes actual

**Reactive:**

- `watchTransactions()`: Stream<List<Transaction>>
  - Emite nueva lista cada vez que hay cambios
  - Perfecto para StreamBuilder o Provider

**Utilidades:**

- `clearAll()`: Elimina todas las transacciones
- `close()`: Cierra la box (raramente necesario)

**Box name:** 'transactions'

---

#### `lib/services/streak_service.dart`

**Propósito:** Servicio singleton para gestionar racha de ahorro

**Pattern:** Singleton con `instance` getter

**Lógica de racha:**

1. Se cuenta un día si hay ≥1 ingreso con categoría "Ahorro" o "Beca"
2. Los días deben ser consecutivos desde hoy hacia atrás
3. Si hay un día sin registro, la racha se corta
4. Se guarda currentStreak y bestStreak (record histórico)

**Métodos públicos:**

**Inicialización:**

- `init()`: Abre box 'streak_data'
  - DEBE llamarse después de TransactionsService.init()

**Getters:**

- `currentStreak`: int - Racha actual en días
- `bestStreak`: int - Mejor racha histórica
- `lastStreakDate`: DateTime? - Última fecha con racha

**Cálculo:**

- `recomputeStreak(List<Transaction>)`: Recalcula racha completa
  - Filtra ingresos con categoría de ahorro
  - Agrupa por fecha (sin hora)
  - Cuenta consecutivos desde hoy
  - Actualiza currentStreak y bestStreak si aplica

**Helpers:**

- `wouldIncrementStreak(Transaction)`: Indica si una transacción sumará a la racha
- `reset()`: Limpia toda la data (para testing)

**Almacenamiento:**

- Box: 'streak_data'
- Keys: 'current_streak', 'best_streak', 'last_streak_date'

---

### 🔄 Providers (Estado Global)

#### `lib/providers/transactions_provider.dart`

**Propósito:** Provider principal con ChangeNotifier para estado global

**Extends:** ChangeNotifier (de package:flutter/foundation.dart)

**Dependencias:**

- TransactionsService (singleton)
- StreakService (singleton)

**Inicialización automática:**

```dart
TransactionsProvider() {
  _init(); // Carga datos y configura listener
}
```

**Lista principal:**

- `_transactions`: List<Transaction> privada
- `transactions`: getter público (ordenada por fecha desc)

**Getters de listas filtradas:**

- `incomes`: Solo ingresos
- `expenses`: Solo gastos
- `currentMonthTransactions`: Del mes actual

**Getters de totales:**

- `totalIncome`: Suma de todos los ingresos
- `totalExpense`: Suma de todos los gastos
- `currentBalance`: ingresos - gastos
- `currentMonthIncome`: Ingresos del mes actual
- `currentMonthExpense`: Gastos del mes actual
- `currentMonthBalance`: Balance del mes actual

**Getters de racha:**

- `currentStreak`: Delegado a StreakService
- `bestStreak`: Delegado a StreakService

**Métodos públicos:**

**CRUD:**

- `addTransaction(Transaction)`: Agrega nueva
- `updateTransaction(Transaction)`: Actualiza existente
- `deleteTransaction(String id)`: Elimina por ID
- `loadTransactions()`: Recarga desde storage

**Queries:**

- `getTransactionsByCategory(String)`: Filtra por categoría
- `getExpensesByCategory()`: Map<String, double> - Gastos agrupados

**Reactivity:**

- Escucha `watchTransactions()` del service
- Llama `notifyListeners()` automáticamente
- Recalcula racha después de cada cambio

**Estados:**

- `isLoading`: bool - Indica si está cargando datos

---

### 🚀 Main (Punto de Entrada)

#### `lib/main.dart`

**Propósito:** Inicialización y configuración de la app

**Flujo de inicio:**

1. **Preparación async:**

```dart
WidgetsFlutterBinding.ensureInitialized();
```

2. **Inicializar storage:**

```dart
await TransactionsService.instance.init();
await StreakService.instance.init();
```

3. **Inicializar i18n:**

```dart
await initializeDateFormatting('es_ES', null);
```

4. **Lanzar app:**

```dart
runApp(const MyApp());
```

**MyApp widget:**

- Envuelve con `ChangeNotifierProvider`
- Crea instancia de TransactionsProvider
- Configura MaterialApp con:
  - Theme personalizado (seedColor: teal)
  - Locale: español ('es', 'ES')
  - debugShowCheckedModeBanner: false
  - Home: HomeScreen

**Theme:**

- ColorScheme desde teal
- Surface: background color
- Material 3: true
- Font family: Roboto

---

## 🛠️ Configuración del Proyecto

### `pubspec.yaml`

**Dependencias de producción:**

```yaml
flutter:
  sdk: flutter
cupertino_icons: ^1.0.8
provider: ^6.1.2 # Estado global
hive: ^2.2.3 # Base de datos NoSQL
hive_flutter: ^1.1.0 # Integración Flutter
uuid: ^4.5.1 # Generación de IDs
intl: ^0.19.0 # i18n y formatos
```

**Dependencias de desarrollo:**

```yaml
flutter_test:
  sdk: flutter
flutter_lints: ^6.0.0
hive_generator: ^2.0.1 # Genera adaptadores
build_runner: ^2.4.13 # Ejecuta generadores
```

**Configuración:**

- SDK: ^3.10.1
- Nombre: miauni
- Descripción: "A new Flutter project."
- Versión: 1.0.0+1

---

### `analysis_options.yaml`

**Propósito:** Configuración de linter y análisis estático

**Incluye:**

- Reglas de flutter_lints
- Configuración de análisis estricto

---

## 📱 Plataformas Soportadas

### Android (`android/`)

**Configuración:**

- Gradle con Kotlin DSL
- minSdkVersion: 21 (Android 5.0+)
- targetSdkVersion: 34 (Android 14)
- Java 17 compatibility

**Archivos clave:**

- `android/app/build.gradle.kts`
- `android/app/src/main/AndroidManifest.xml`

---

### iOS (`ios/`)

**Configuración:**

- Xcode project
- iOS deployment target: 12.0+
- Swift 5

**Archivos clave:**

- `ios/Runner.xcodeproj/`
- `ios/Runner/Info.plist`

---

### Linux (`linux/`)

**Configuración:**

- CMake build system
- Requiere: GTK, libblkid

---

### macOS (`macos/`)

**Configuración:**

- Xcode project
- macOS 10.14+

---

### Windows (`windows/`)

**Configuración:**

- CMake build system
- MSVC compiler

---

### Web (`web/`)

**Configuración:**

- index.html con canvas mode
- Service worker ready
- PWA manifest

**Nota:** La app está diseñada para móvil, pero compila para web

---

## 🧪 Testing

### `test/widget_test.dart`

**Estado:** ⚠️ Test por defecto de Flutter (necesita actualización)

**Tests pendientes:**

- [ ] Tests unitarios para services
- [ ] Tests unitarios para provider
- [ ] Tests de widgets
- [ ] Tests de integración
- [ ] Tests de UI

---

## 🎯 Flujos de Usuario Principales

### 1️⃣ Agregar un Gasto

```
Home → Botón GASTO → AddTransactionScreen
→ Seleccionar monto
→ Elegir categoría (ej: 🍔 Comida)
→ Agregar nota (opcional)
→ GUARDAR
→ Vuelve a Home con balance actualizado
```

### 2️⃣ Agregar un Ingreso

```
Home → Botón INGRESO → AddTransactionScreen
→ Seleccionar monto
→ Elegir categoría (ej: 🎓 Beca o 💰 Ahorro)
→ Agregar nota (opcional)
→ GUARDAR
→ Vuelve a Home
→ Si es "Ahorro"/"Beca", suma a la racha
```

### 3️⃣ Ver Historial

```
Home → Tab Historial
→ Ver lista de todas las transacciones
→ Tap en "Filtros" para filtrar
→ Swipe left en transacción → Eliminar
→ Confirmar eliminación
```

### 4️⃣ Ver Estadísticas

```
Home → Tab Stats
→ Ver totales del mes
→ Ver gastos por categoría
→ Ver metas de ahorro
```

---

## 🔐 Persistencia y Almacenamiento

### Ubicación de Datos

**Hive guarda en:**

- Android: `/data/data/com.example.miauni/app_flutter/`
- iOS: Application Documents Directory
- Desktop: User's app data folder

### Boxes de Hive

1. **transactions**: Todas las transacciones
2. **streak_data**: Datos de racha (current, best, last_date)

### Backup y Restore

**Manual:**

- No implementado (feature futura)
- Se puede acceder a archivos de Hive en el dispositivo

**Automático:**

- Hive maneja persistencia automáticamente
- No hay sincronización en la nube

---

## 🎨 Convenciones de Diseño

### Colores por Contexto

- **Ingresos:** Verde (#B8E6D5 fondo, #006B54 texto)
- **Gastos:** Rojo/Coral (#FEE2E2 fondo, #FFA69E acento)
- **Neutro:** Negro/Gris (#1A1A1A texto, #F5F5F5 fondo)
- **Acentos:** Turquesa (#4ECDC4)

### Espaciado

- **Padding general:** 20px
- **Entre secciones:** 20-32px
- **Entre elementos:** 8-12px
- **Pequeño:** 4px

### Bordes

- **Grosor estándar:** 2px
- **Color:** Negro (#1A1A1A)
- **Border radius:** 8-16px según tamaño

### Tipografía

- **Títulos:** Roboto Bold, 24-32px
- **Cuerpo:** Roboto Regular, 14px
- **Captions:** Roboto Regular, 12px

---

## 🚀 Comandos de Desarrollo

### Setup inicial

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Desarrollo

```bash
flutter run                    # Ejecutar en dispositivo
flutter run -d chrome          # Ejecutar en Chrome
flutter analyze                # Análisis estático
flutter test                   # Ejecutar tests
```

### Build

```bash
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios              # iOS
flutter build web              # Web
```

### Mantenimiento

```bash
flutter clean                  # Limpiar build
flutter pub upgrade            # Actualizar deps
dart run build_runner watch    # Regenerar en watch mode
```

---

## ✅ Estado del Proyecto

### Completado (v1.0)

- ✅ Arquitectura base con Hive + Provider
- ✅ CRUD de transacciones
- ✅ Sistema de racha de ahorro
- ✅ Pantalla Home con balance real
- ✅ Pantalla Stats con cálculos automáticos
- ✅ Pantalla History con filtros
- ✅ Formulario de agregar transacciones
- ✅ Persistencia local completa
- ✅ UI con diseño consistente
- ✅ 3 pestañas de navegación (Inicio, Stats, Historial)

### En Progreso

- 🚧 Tests unitarios
- 🚧 Gráficos visuales en Stats

### Por Hacer

- ⏳ Editar transacciones (UI)
- ⏳ Categorías personalizadas
- ⏳ Presupuestos configurables
- ⏳ Exportar a CSV
- ⏳ Metas de ahorro personalizables
- ⏳ Notificaciones de racha
- ⏳ Modo oscuro
- ⏳ Onboarding inicial

---

✅ **Proyecto funcional y listo para desarrollo continuo**
