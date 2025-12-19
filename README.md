Pokedex – Flutter Mobile & Web

Aplicación Pokédex desarrollada en Flutter para Mobile y Web.
Consume la PokéAPI y muestra un listado paginado de Pokémon con su respectivo detalle.
Incluye un manejo básico de cache para funcionar offline y una arquitectura pensada para poder escalar si el proyecto creciera.

Cómo correr el proyecto
Requisitos

Flutter stable (>= 3.x)

Dart >= 3

Google Chrome (para Web)

Emulador iOS / Android o dispositivo físico

Después ejecutar:

flutter pub get

Ejecutar la aplicación
Mobile
flutter run

Web
flutter run -d chrome


Se recomienda Chrome para Web por temas de performance y debugging.

Arquitectura y escalabilidad

La aplicación está organizada siguiendo un enfoque feature-first, separando el código compartido de las features de negocio.
No es una Clean Architecture estricta, sino una versión práctica y ligera, pensada para el alcance del challenge y para poder crecer sin complicarse de más.

Estructura principal del proyecto:

lib/
  config/
    env.dart
  core/
    cache/
      local_cache.dart
    network/
      poke_api_client.dart
    presentation/
      resources/
        app_colors.dart
        app_text_styles.dart
      widgets/
        app_core_appbar.dart
    utils/
      pokemon_image.dart
  features/
    pokedex/
      data/
        models/
        repositories/
      presentation/
        cubit/
        pages/
        widgets/

Separación de responsabilidades

config
Configuración global de la aplicación, como la carga y acceso a variables de entorno.

core
Código reutilizable y agnóstico al dominio:

cache: persistencia local (offline)

network: cliente HTTP

presentation/resources: colores y estilos globales

presentation/widgets: widgets compartidos

utils: helpers comunes

features/pokedex
Todo lo relacionado con la Pokédex:

data: modelos y repositories

presentation: Cubits, páginas y widgets específicos

Flujo general

La UI interactúa únicamente con los Cubits.

Los Cubits delegan la obtención de datos al Repository.

El Repository decide si leer desde la API o desde el cache.

El Cubit emite un nuevo estado y la UI se reconstruye.

La UI no conoce detalles de red ni persistencia, y los side-effects quedan centralizados.

Escalabilidad

Esta estructura permite:

Agregar nuevas features sin afectar las existentes.

Reutilizar lógica compartida desde core.

Compartir la misma lógica entre Mobile y Web.

Testear Cubits y repositories de forma aislada.

Si el proyecto creciera, sería sencillo extender la capa de datos o agregar nuevas features sin reescribir la UI.

Trade-offs por el tiempo del challenge

Dado el timebox de aproximadamente un día, se tomaron algunas decisiones conscientes:

Se usó Cubit en lugar de Bloc para reducir boilerplate.

Se eligió Hive como solución de cache simple y compatible con Web.

No se implementaron estrategias avanzadas de sincronización (ETags, TTL complejos).

El foco del UI fue funcionalidad y claridad, no diseño final.

La prioridad fue entregar una solución clara, estable y fácil de entender.

Gestión de estado y side-effects

Flujo general de datos:

UI
 → Cubit
   → Repository
     → API o Cache


Ejemplo:

La UI dispara una acción en el Cubit.

El Cubit delega al Repository.

El Repository decide si usar API o cache.

El Cubit emite un nuevo estado.

La UI se reconstruye en base a ese estado.

Esto mantiene bajo acoplamiento y facilita el mantenimiento y testing.

Offline y cache

Se implementó un manejo offline simple:

Primero se intenta obtener la información desde la API.

Si la llamada falla, se intenta leer desde cache local.

Qué se guarda:

Listado paginado de Pokémon (limit + offset).

Detalle individual por pokemonId.

Las claves de cache están versionadas (por ejemplo pokedex_cache_v1) para permitir invalidación simple si cambia la estructura de datos.

Para un producto real se podrían agregar TTLs, revalidación en background y estrategias más finas de invalidación.

Flutter Web

Decisiones específicas para Web:

Layout responsive.

En Mobile se usa navegación tradicional (lista → detalle).

En Desktop/Web se usa un layout tipo master-detail.

Scroll infinito para una experiencia más natural con mouse.

Filas alternadas y selección visual para mejorar la interacción.

En cuanto a performance:

Se evitan requests innecesarios.

Las imágenes se calculan a partir del id del Pokémon.

Los Cubits están acotados por feature.

Limitaciones esperables:

Tamaño del bundle en Web.

Cache limitado por el navegador.

Calidad de código

Algunas decisiones tomadas durante el desarrollo:

Estados explícitos para evitar UI en estados ambiguos.

Nada de lógica de negocio dentro de los widgets.

Colores y estilos centralizados para evitar valores hardcodeados.

La intención fue mantener el código legible y fácil de seguir.

Testing

Por el alcance y el tiempo del challenge no se implementaron tests automatizados.

Si hubiera más tiempo, los primeros tests que agregaría serían:

Tests de Cubit para validar transiciones de estado.

Tests del Repository para el flujo offline (API falla → cache).

Algunos golden tests básicos para la UI.

Pendientes

Algunas cosas que quedaron fuera principalmente por tiempo:

Búsqueda por nombre.

Filtro por tipo.

TTL de cache.

Skeleton loaders para mejorar la percepción de carga.

Mejoras de accesibilidad (semantics y navegación por teclado en Web).

Autor

Brayan Olivares
Flutter / Full Stack and Mobile Developer
