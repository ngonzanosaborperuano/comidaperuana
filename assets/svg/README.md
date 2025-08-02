```m
sequenceDiagram
    participant UI as Widget UI
    participant Semantic as SvgIconSemantic
    participant Icons as SvgIcons
    participant AppSvg as AppSvgIcon
    participant Service as SvgService
    participant Cache as Cache Map
    participant Assets as Assets

    UI->>Semantic: context.svgIconSemantic.sparkle()
    Semantic->>Icons: SvgIcons.sparkle
    Icons-->>Semantic: 'assets/svg/sparkle.svg'
    Semantic->>AppSvg: AppSvgIcon(assetPath, size, color)
    AppSvg->>Service: loadSvgFromAssets()
    Service->>Cache: ¿Existe en cache?

    alt En cache
        Cache-->>Service: Widget cacheado
        Service-->>AppSvg: Widget
    else No en cache
        Service->>Assets: Cargar SVG
        Assets-->>Service: SVG data
        Service->>Service: Crear SvgPicture.asset
        Service->>Cache: Guardar en cache
        Service-->>AppSvg: Widget
    end

    AppSvg-->>Semantic: AppSvgIcon widget
    Semantic-->>UI: Widget listo
    UI->>UI: Renderizar en pantalla
```
