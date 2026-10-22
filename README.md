## Integrantes
- Roxana Jacquelinne Alvarado Bonilla — contribución: RF-01, RF-02
- Ruth Marina Morales de Alvarado — contribución: RF-03, RF-04
- Jerson David  Cabreras Chicas — contribución: RF-05 , RF-06


# Rick and Morty Explorer 

Tercer Examen, Desarrollo de Aplicaciones Móviles. Consulta personajes desde la API pública de Rick and Morty, permite ver detalles, buscar en la página actual, navegar por páginas y guardar favoritos localmente.

## Funcionalidades incluidas
- Catálogo real mediante `GET https://rickandmortyapi.com/api/character?page=1`.
- Tarjetas con imagen remota, nombre, estado y especie.
- Pantalla de detalle con estado, especie, género, origen, ubicación, tipo y cantidad de episodios.
- Búsqueda local sin distinguir mayúsculas/minúsculas, con aviso de que solo filtra la página cargada.
- Paginación anterior/siguiente y número de página; botones deshabilitados en los límites.
- Favoritos agregables y eliminables, guardados con `SharedPreferences` y recuperados al iniciar.
- Indicador de carga, mensajes de error de conexión, estado sin resultados y reintento.
- Alternativa visual cuando una imagen remota falla.
- Separación de modelos, servicio HTTP, estado, pantallas y widgets.

## Estructura
```text
lib/
  main.dart
  models/
    character.dart
    character_page.dart
  services/
    character_api.dart
  state/
    app_state.dart
  screens/
    home_screen.dart
    character_detail_screen.dart
    favorites_screen.dart
  widgets/
    character_card.dart
```


## Fuente de datos
Rick and Morty API: https://rickandmortyapi.com/documentation


