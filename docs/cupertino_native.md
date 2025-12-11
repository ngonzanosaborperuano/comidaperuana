# Cupertino Native (v0.1.1)

Guía rápida de los widgets nativos (Liquid Glass) que expone el paquete
`cupertino_native` para iOS/macOS. Todos los widgets hacen fallback a
implementaciones Flutter en plataformas no Apple.

## Requisitos de plataforma
- iOS 14+ y Xcode 26 (beta) para ver Liquid Glass.
- macOS 11+ (soporte básico; Liquid Glass aún sin pulir).

## Componentes disponibles

### CNButton / CNButton.icon
- Botones de texto o solo ícono con estilos nativos.
- Props clave: `label`, `icon` (para `.icon`), `onPressed`, `style`
  (`CNButtonStyle`), `tint`, `height`, `size` (icon).
- Estilos soportados (`CNButtonStyle`):
  - `plain`, `gray`, `tinted`, `bordered`, `borderedProminent`,
    `filled`, `glass`, `prominentGlass`.

### CNTabBar + CNTabBarItem
- Tab bar nativa (UITabBar) para iOS.
- Props clave: `items` (lista de `CNTabBarItem` con `label`/`icon`),
  `currentIndex`, `onTap`.

### CNIcon + CNSymbol
- Renderiza SF Symbols con los modos nativos: `monochrome`,
  `hierarchical`, `palette`, `multicolor`.
- `CNSymbol` permite definir `size`, `color`, `mode`, `paletteColors` y
  `gradient`.

### CNSlider (+ CNSliderController)
- Slider nativo (UISlider/NSSlider) con colores y pasos opcionales.
- Props clave: `value`, `min`, `max`, `step`, `color`, `height`,
  `onChanged`.
- `CNSliderController` permite setear el valor de forma imperativa
  (`setValue(animated: true/false)`).

### CNSegmentedControl
- Segmented control nativo (UISegmentedControl/NSSegmentedControl).
- Props clave: `labels`, `selectedIndex`, `onValueChanged`, `color`,
  `height`, `sfSymbols` (lista opcional de `CNSymbol` por segmento).

### CNSwitch
- Interruptor nativo (UISwitch).
- Props clave: `value`, `onChanged`, `color` (tinte).

### CNPopupMenuButton
- Botón que abre un menú contextual nativo.
- Items: `CNPopupMenuItem(label, icon?, enabled?)` y separadores con
  `CNPopupMenuDivider`.
- Variantes: `CNPopupMenuButton` (texto) y `CNPopupMenuButton.icon`.
- Props clave: `items`, `onSelected`, `buttonLabel` o `buttonIcon`,
  `buttonStyle` (`CNButtonStyle`), `size`.

## Consejos de uso
- Siempre provee `onPressed`/`onSelected` para recibir eventos; sin eso
  los controles no responden.
- Para íconos, usa SF Symbols disponibles en la plataforma; símbolos
  inválidos no se renderizan.
- Los colores y estilos se adaptan a modo claro/oscuro automáticamente;
  ajusta `tint` solo si necesitas resaltar.

## Limitaciones conocidas (0.1.1)
- Liquid Glass solo visible en iOS 17+/Xcode 26 (según README del
  paquete).
- macOS funciona pero con estilo menos pulido y sin pruebas exhaustivas.
- Integración con scroll views aún en revisión; valida en tu layout.
