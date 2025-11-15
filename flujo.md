# 📊 Contenido del Archivo

El archivo incluye **15 diagramas Mermaid listos para usar**:

1. ✅ **User Journey Completo (Macro)** – Flujo general usuario  
2. ✅ **Onboarding Completo** – Setup inicial  
3. ✅ **Search & Explore Detallado** – Búsqueda y filtros  
4. ✅ **Recipe Detail – Tabs Completo** – Página receta  
5. ✅ **Meal Plan Completo** – Planificación semanal  
6. ✅ **Shopping List Completo** – Lista de compras  
7. ✅ **Cooking Mode Revolucionario** – Modo cocina *hands-free*  
8. ✅ **Profile & Settings** – Perfil de usuario  
9. ✅ **Autenticación Completa** – Login / Signup  
10. ✅ **Favoritos & Colecciones** – Sistema de favoritos  
11. ✅ **Notificaciones & Reminders** – Sistema de notificaciones  
12. ✅ **Data Sync & Offline** – Sincronización de datos  
13. ✅ **Analytics & Tracking** – Eventos y tracking  
14. ✅ **Gamificación (Fase 2)** – Sistema de puntos / badges  
15. ✅ **Dark Mode Toggle** – Modo oscuro  

---

## 🎨 Características de los Diagramas

- ✅ **Color-coded** – Cada flujo usa colores distintos para fácil identificación  
- ✅ **Detallados** – Incluyen decisiones, validaciones y caminos completos  
- ✅ **Listos para usar** – Copiar y pegar directamente en *Mermaid Live Editor*  
- ✅ **Visuables** – Diseñados para ser leídos fácilmente  
- ✅ **Documentados** – Cada uno con descripción clara  



```mermaid
graph TD
    A["Usuario Nuevo"] -->|Descarga app| B["Onboarding"]
    B -->|Completa preferencias| C["Home Screen"]
    C -->|Selecciona opcion| D{Â¿Que desea hacer?}
    
    D -->|Buscar receta| E["Search & Explore"]
    D -->|Ver plan| F["Meal Plan"]
    D -->|Ir de compras| G["Shopping List"]
    D -->|Mi cuenta| H["Profile"]
    
    E -->|Encuentra receta| I["Recipe Detail"]
    I -->|Quiere cocinar| J["Cooking Mode"]
    I -->|Quiere guardar| K["Add to Favorites"]
    I -->|Necesita ingredientes| L["Add to Shopping List"]
    
    J -->|Termina de cocinar| M["Mark as Cooked"]
    M -->|Gana puntos| N["Gamification"]
    N -->|Vuelve a home| C
    
    F -->|Ver semana planeada| O["Week Overview"]
    O -->|Aniadir comida| P["Search to Add"]
    P -->|Selecciona| I
    
    G -->|Ver lista| Q["List View"]
    Q -->|Marcar comprado| R["Check Items"]
    
    H -->|Ver perfil| S["My Stats"]
    S -->|Editar| T["Settings"]
    
    style A fill:#e1f5e1
    style B fill:#fff4e6
    style C fill:#e3f2fd
    style D fill:#f3e5f5
    style E fill:#e8f5e9
    style F fill:#fff3e0
    style G fill:#fce4ec
    style H fill:#ffe0b2
    style I fill:#b3e5fc
    style J fill:#ffccbc
    style K fill:#c8e6c9
    style L fill:#f8bbd0
    style M fill:#a5d6a7
    style N fill:#ffd54f
    style O fill:#ffb74d
    style P fill:#4fc3f7
    style Q fill:#ba68c8
    style R fill:#90caf9
    style S fill:#ce93d8
    style T fill:#81c784
```

---

```mermaid
graph TD
    A["App Abierta"] -->|Primera vez| B["Splash Screen<br/>2 segundos"]
    B -->|Termina| C["Welcome<br/>Bienvenida"]
    
    C -->|Toca Empezar| D["Pantalla 1: Preferencias<br/>Que te describe?"]
    D -->|Selecciona opciones| E{Validacion}
    E -->|OK| F["Pantalla 2: Nivel Cocina<br/>Principiante/Intermedio/Avanzado"]
    E -->|Error| D
    
    F -->|Selecciona nivel| G{Validacion}
    G -->|OK| H["Pantalla 3: Permisos<br/>Notificaciones + Camara"]
    G -->|Error| F
    
    H -->|Permite permisos| I["Pantalla 4: Celebracion<br/>Listo!"]
    H -->|Rechaza| J["Pantalla 4 Alt: Sin permisos"]
    
    I -->|Continuar| K["Home Screen"]
    J -->|Continuar| K
    
    K -->|Ya tiene cuenta| L["Login Screen<br/>Email + Google + Apple"]
    L -->|Login exitoso| M["Home Screen"]
    
    style A fill:#e3f2fd
    style B fill:#bbdefb
    style C fill:#90caf9
    style D fill:#64b5f6
    style E fill:#42a5f5
    style F fill:#2196f3
    style G fill:#1e88e5
    style H fill:#1976d2
    style I fill:#1565c0
    style J fill:#0d47a1
    style K fill:#e8f5e9
    style L fill:#c8e6c9
    style M fill:#a5d6a7
```

---

```mermaid
graph TD
    A["Home Screen"] -->|Tap Search| B["Search Bar Activado"]
    
    B -->|Usuario escribe| C{Que escribio?}
    
    C -->|Ingrediente| D["Buscar por ingrediente<br/>ej: pollo"]
    C -->|Plato| E["Buscar por nombre<br/>ej: ceviche"]
    C -->|Mood| F["Buscar por sentimiento<br/>ej: algo rapido"]
    C -->|Vacio| G["Mostrar categorias<br/>Rapido/Economico/Saludable"]
    
    D -->|Resultados| H["Results Grid"]
    E -->|Resultados| H
    F -->|Resultados| H
    G -->|Tap categoria| H
    
    H -->|Ver recetas| I{Usuario que hace?}
    
    I -->|Tap receta| J["Recipe Detail Page"]
    I -->|Tap Favorito| K["Add to Favorites<br/>Sin abrir receta"]
    I -->|Scroll| L["Ver mas resultados"]
    
    B -->|Tap filtro| M["Filter Panel Abierto"]
    M -->|Selecciona filtros| N["Tiempo<br/>Costo<br/>Dificultad<br/>Tipo comida<br/>Ingrediente principal"]
    N -->|Aplica filtros| O["Resultados filtrados"]
    O -->|Ver| H
    
    M -->|Tap Limpiar| P["Reset filtros"]
    P -->|Vuelve a| H
    
    J -->|Tap Aniadir a lista| Q["Add Ingredients to List"]
    J -->|Tap Favorito| K
    J -->|Tap Aniadir a plan| R["Aniadir a Meal Plan"]
    
    style A fill:#e3f2fd
    style B fill:#bbdefb
    style C fill:#90caf9
    style D fill:#64b5f6
    style E fill:#42a5f5
    style F fill:#2196f3
    style G fill:#1e88e5
    style H fill:#fff3e0
    style I fill:#ffeb3b
    style J fill:#fbc02d
    style K fill:#f9a825
    style L fill:#f57f17
    style M fill:#fce4ec
    style N fill:#f8bbd0
    style O fill:#f48fb1
    style P fill:#f06292
    style Q fill:#ec407a
    style R fill:#e91e63
```

---

```mermaid
graph TD
    A["Recipe Detail Page"] 
    
    A -->|Hero Image| B["Fullscreen Image<br/>Back + Favorito + Menu"]
    B -->|Scroll up| C["Header Info<br/>Titulo + Rating + Author"]
    
    C -->|Tabs disponibles| D{Que tab?}
    
    D -->|TAB 1: Ingredientes| E["Ingredientes Tab"]
    E -->|Mostrar| F["Porciones Ajustables<br/>[-] 4 [+]"]
    F -->|Ingredientes con checkbox| G["Ingredientes List"]
    G -->|Mostrar| H["Ingrediente<br/>Checkbox<br/>Cantidad<br/>Substituto"]
    H -->|Tap checkbox| I["Marcar como tengo"]
    H -->|Tap Substituto| J["Sugerencia IA<br/>Substituto disponible"]
    G -->|Scroll| K["Boton Sticky Bottom<br/>Aniadir faltantes a lista"]
    K -->|Tap| L["Add to Shopping List"]
    
    D -->|TAB 2: Pasos| M["Pasos Tab"]
    M -->|Mostrar pasos| N["Numerados 1/8"]
    N -->|Cada paso| O["Numero<br/>Texto instruccion<br/>Imagen opcional<br/>Tiempo sugerido"]
    O -->|Tap Tiempo| P["Timer sugerido"]
    P -->|Muestra| Q["15 minutos<br/>Deseas timer?"]
    O -->|Scroll| R["Boton Sticky Bottom<br/>Iniciar Modo Cocina"]
    R -->|Tap| S["COOKING MODE"]
    
    D -->|TAB 3: Nutricion| T["Nutricion Tab"]
    T -->|Mostrar| U["Grafica Macros"]
    U -->|Detalles| V["Calorias: 420kcal<br/>Proteinas: 32g<br/>Carbos: 48g<br/>Grasas: 12g"]
    V -->|Badges| W["Sin gluten<br/>Alto en proteina<br/>No vegetariano"]
    
    D -->|TAB 4: Reviews| X["Reviews Tab"]
    X -->|Mostrar| Y["Rating Summary<br/>4.8 estrellas (234)"]
    Y -->|Reviews list| Z["Avatar + Nombre<br/>Rating<br/>Texto<br/>Likes"]
    Z -->|Tap review| AA["Expandir review"]
    Z -->|Scroll| AB["Ver mas reviews"]
    
    S -->|Cooking Mode| AC["COOKING MODE SCREEN"]
    AC -->|Pantalla gigante| AD["Texto XL<br/>Imagen paso<br/>Botones gigantes<br/>Keep screen on"]
    AD -->|Anterior/Siguiente| AE["Navega pasos"]
    AD -->|Comandos voz| AF["Voice Commands<br/>siguiente paso<br/>repetir<br/>timer 15 min"]
    
    style A fill:#f3e5f5
    style B fill:#e1bee7
    style C fill:#ce93d8
    style D fill:#ba68c8
    style E fill:#c8e6c9
    style F fill:#a5d6a7
    style G fill:#81c784
    style H fill:#66bb6a
    style I fill:#4caf50
    style J fill:#43a047
    style K fill:#388e3c
    style L fill:#2e7d32
    style M fill:#ffe0b2
    style N fill:#ffcc80
    style O fill:#ffb74d
    style P fill:#ffa726
    style Q fill:#fb8c00
    style R fill:#f57c00
    style S fill:#e65100
    style T fill:#b3e5fc
    style U fill:#81d4fa
    style V fill:#4fc3f7
    style W fill:#29b6f6
    style X fill:#ffd54f
    style Y fill:#ffca28
    style Z fill:#fbc02d
    style AA fill:#f9a825
    style AB fill:#f57f17
    style AC fill:#ffccbc
    style AD fill:#ffab91
    style AE fill:#ff8a65
    style AF fill:#ff7043
```

---

```mermaid
graph TD
    A["Home Screen"] -->|Tap Calendar| B["Meal Plan Page"]
    
    B -->|Mostrar| C["Selector: Esta semana / Proxima semana"]
    C -->|Mostrar| D["Calendario 7 dias"]
    D -->|Cada dia| E["Dia: L/M/X/J/V/S/D<br/>3 slots: Desayuno/Almuerzo/Cena"]
    
    E -->|Slot Vacio| F["Estado vacio"]
    F -->|Tap| G["Modal: Buscar receta<br/>O ver Favoritos"]
    G -->|Busca receta| H["Resultados de busqueda"]
    H -->|Tap receta| I["Aniade a slot"]
    I -->|Confirmacion| J["Receta aparece en slot"]
    
    E -->|Slot Lleno| K["Estado lleno"]
    K -->|Tap| L["Ver receta asignada<br/>Con opciones:"]
    L -->|Opciones| M["Ver detalles<br/>Cambiar receta<br/>Eliminar<br/>Duplicar dia"]
    
    M -->|Ver detalles| N["Abre Recipe Detail Page"]
    M -->|Cambiar| O["Modal busqueda<br/>Filtra similar"]
    M -->|Eliminar| P["Confirma eliminacion"]
    P -->|Elimina| Q["Slot vuelve a vacio"]
    M -->|Duplicar| R["Copia comidas del dia<br/>A proximo dia"]
    
    B -->|Swipe horizontal| S["Navega entre semanas"]
    S -->|Left| T["Semana anterior"]
    S -->|Right| U["Semana siguiente"]
    
    B -->|Boton: Generar semana| V["Auto-generate<br/>Fase 2 con IA"]
    V -->|Toca| W["Modal opciones:<br/>Tipo de comida<br/>Presupuesto<br/>Restricciones"]
    W -->|Confirma| X["IA genera plan"]
    X -->|Muestra| Y["Semana completa"]
    
    B -->|Boton: Exportar| Z["Export as PDF<br/>Futuro"]
    
    B -->|Boton: Generar lista| AA["Generate Shopping<br/>List"]
    AA -->|Toca| AB["Todos ingredientes<br/>de semana a lista"]
    AB -->|Confirma| AC["Lista generada"]
    
    style A fill:#e3f2fd
    style B fill:#e8f5e9
    style C fill:#fff3e0
    style D fill:#c8e6c9
    style E fill:#a5d6a7
    style F fill:#81c784
    style G fill:#66bb6a
    style H fill:#4caf50
    style I fill:#43a047
    style J fill:#388e3c
    style K fill:#ffc107
    style L fill:#ffb300
    style M fill:#ffa000
    style N fill:#ff8f00
    style O fill:#ff6f00
    style P fill:#e65100
    style Q fill:#bf360c
    style R fill:#9c27b0
    style S fill:#8e24aa
    style T fill:#7b1fa2
    style U fill:#6a1b9a
    style V fill:#4527a0
    style W fill:#311b92
    style X fill:#1a237e
    style Y fill:#0d47a1
    style Z fill:#03a9f4
    style AA fill:#00bcd4
    style AB fill:#00acc1
    style AC fill:#0097a7
```

---

```mermaid
graph TD
    A["Home Screen"] -->|Tap| B["Shopping List Page"]
    
    B -->|Header| C["Titulo: Lista del Super<br/>Subtitle: 12 items 45 soles"]
    C -->|Mode selector| D{Que modo?}
    
    D -->|Supermercado| E["Modo Supermercado<br/>Agrupar por pasillos:<br/>Pasillo 1, 5, 8, 12"]
    D -->|Mercado| F["Modo Mercado<br/>Agrupar por puestos:<br/>Verduleria, Carniceria"]
    D -->|Delivery| G["Modo Delivery<br/>Agrupar por tienda:<br/>Rappi, PedidosYa"]
    
    E -->|Mostrar items| H["Items Agrupados"]
    F -->|Mostrar items| H
    G -->|Mostrar items| H
    
    H -->|Estructura| I["Categoria Header<br/>Item 1 Checkbox + Qty<br/>Item 2<br/>Item 3"]
    
    I -->|Tap checkbox| J["Marcar comprado<br/>Item se grisa"]
    I -->|Swipe right| K["Swipe action:<br/>Marca comprado"]
    I -->|Swipe left| L["Swipe action:<br/>Eliminar o editar"]
    
    L -->|Opciones| M["Eliminar<br/>Editar cantidad<br/>Aumentar qty"]
    
    I -->|Long press item| N["Opciones contextuales:<br/>Editar<br/>Eliminar<br/>Duplicar"]
    
    H -->|Tap categoria header| O["Expandir/Colapsar<br/>Grupo"]
    
    B -->|Boton: Limpiar| P["Clear List<br/>Elimina todo"]
    P -->|Confirma| Q["Lista vacia"]
    
    B -->|FAB +| R["Add Item Manual"]
    R -->|Modal| S["Nombre ingrediente<br/>Cantidad<br/>Categoria<br/>Precio opcional"]
    S -->|Guarda| T["Nuevo item en lista"]
    
    B -->|Boton: Reordenar| U["Reorder"]
    U -->|Toca| V["Modo edicion:<br/>Drag items<br/>para reordenar"]
    
    B -->|Boton: Compartir| W["Share List<br/>WhatsApp/Email"]
    W -->|Toca| X["Genera link<br/>o texto"]
    
    B -->|Boton: Comprar| Y["Buy Online<br/>Futuro"]
    Y -->|Toca| Z["Integracion Rappi/PedidosYa"]
    
    Q -->|Empty state| AA["Ilustracion<br/>Tu lista esta vacia<br/>Boton: Explorar recetas"]
    AA -->|Toca| AB["Va a Search"]
    
    style A fill:#e3f2fd
    style B fill:#e8f5e9
    style C fill:#fff3e0
    style D fill:#f3e5f5
    style E fill:#c8e6c9
    style F fill:#a5d6a7
    style G fill:#81c784
    style H fill:#fff3e0
    style I fill:#ffeb3b
    style J fill:#fbc02d
    style K fill:#f9a825
    style L fill:#f57f17
    style M fill:#ffccbc
    style N fill:#ffab91
    style O fill:#ff8a65
    style P fill:#ffebee
    style Q fill:#ffcdd2
    style R fill:#a5d6a7
    style S fill:#81c784
    style T fill:#66bb6a
    style U fill:#ce93d8
    style V fill:#ba68c8
    style W fill:#ab47bc
    style X fill:#9c27b0
    style Y fill:#7b1fa2
    style Z fill:#6a1b9a
    style AA fill:#ffb300
    style AB fill:#ffa000
```

---

```mermaid
graph TD
    A["Recipe Detail - Pasos Tab"] -->|Tap Boton| B["Iniciar Modo Cocina"]
    B -->|Transicion| C["COOKING MODE ACTIVADO"]
    
    C -->|Configuracion| D["Pantalla NO se apaga<br/>Brightness maximo<br/>Orientacion vertical lock"]
    
    C -->|Layout| E["Paso X de Y<br/>@top"]
    E -->|Instruccion| F["TEXTO GIGANTE<br/>40-48px<br/>Line spacing 1.8"]
    F -->|Imagen paso| G["Referencia visual<br/>Altura reducida<br/>Aspect ratio 16:9"]
    G -->|Tiempo| H["~15 minutos"]
    
    H -->|Botones grandes| I["ANTERIOR<br/>SIGUIENTE"]
    I -->|Acciones| J["VOZ: siguiente paso<br/>VOZ: repetir paso<br/>VOZ: ir atras"]
    
    J -->|Voice recognition| K["Usuario dijo?"]
    K -->|siguiente| L["Avanza paso"]
    K -->|repetir| M["Relee paso actual"]
    K -->|atras| N["Paso anterior"]
    K -->|timer 15| O["Inicia timer 15min"]
    K -->|pausar| P["Pausa timer"]
    K -->|ingredientes| Q["Lista ingredientes paso"]
    K -->|tips| R["Muestra tips si existen"]
    
    L -->|Avanzar| S["Muestra siguiente paso"]
    M -->|Relee| T["Text-to-speech paso"]
    
    O -->|Timer activo| U["TIMER VISUAL<br/>15:00 > 14:59..."]
    U -->|Tiempo pasa| V["Color cambia:<br/>Verde > Amarillo > Rojo"]
    V -->|0 segundos| W["NOTIFICACION<br/>Tiempo terminado!"]
    W -->|Vibracion| X["Haptic feedback"]
    
    X -->|Usuario puede| Y["OK Continuar<br/>+5 Aniadir 5min mas"]
    
    H -->|Tap Tiempo| Z["Timer modal:<br/>Slider 1-60min"]
    Z -->|Selecciona| AA["Auto-set timer"]
    
    R -->|Tips contextuales| AB["Tip aparece flotante:<br/>Temperatura media-baja"]
    
    U -->|Back button| AC["Confirmacion:<br/>Salir modo cocina?"]
    AC -->|Confirma| AD["Vuelve a Recipe Detail<br/>Timer en background"]
    
    W -->|Notificacion push| AE["Mientras app cerrada"]
    AE -->|Tap notificacion| AF["Abre Recipe Detail"]
    
    style A fill:#f3e5f5
    style B fill:#e1bee7
    style C fill:#ffccbc
    style D fill:#ffab91
    style E fill:#ff8a65
    style F fill:#ff7043
    style G fill:#ff5722
    style H fill:#ffd54f
    style I fill:#ffca28
    style J fill:#fbc02d
    style K fill:#f9a825
    style L fill:#f57f17
    style M fill:#c8e6c9
    style N fill:#a5d6a7
    style O fill:#81c784
    style P fill:#66bb6a
    style Q fill:#4caf50
    style R fill:#43a047
    style S fill:#388e3c
    style T fill:#2e7d32
    style U fill:#ffd54f
    style V fill:#ffb74d
    style W fill:#ff6f00
    style X fill:#e65100
    style Y fill:#bf360c
    style Z fill:#b3e5fc
    style AA fill:#81d4fa
    style AB fill:#a1887f
    style AC fill:#6d4c41
    style AD fill:#5d4037
    style AE fill:#4e342e
    style AF fill:#3e2723
```

---

```mermaid
graph TD
    A["Home Screen"] -->|Tap Profile| B["Profile Page"]
    
    B -->|Header| C["Avatar<br/>Nombre usuario<br/>Email"]
    C -->|Edit| D["Edit Profile<br/>Modal"]
    D -->|Puede cambiar| E["Avatar<br/>Nombre<br/>Mostrar publico?"]
    
    B -->|Stats Section| F["Mis Estadisticas"]
    F -->|Mostrar| G["Esta Semana:<br/>5 comidas cocinadas<br/>3 nuevas recetas<br/>120 soles ahorrados"]
    
    G -->|Historico| H["Historial:<br/>Ultimos 30 dias"]
    
    B -->|Mis Favoritos| I["Mis Favoritos<br/>X recetas guardadas"]
    I -->|Tap| J["Grid de favoritos"]
    
    B -->|Mis Recetas| K["Mis Recetas<br/>Futuro v2.0"]
    K -->|Recetas usuario| L["Recetas subidas"]
    
    B -->|Preferencias| M["Preferencias"]
    M -->|Tap| N["Settings Modal"]
    
    N -->|Opciones| O["Restricciones Dieteticas<br/>Alergias/Intolerancias<br/>Nivel de Cocina"]
    
    O -->|Guardar| P["Actualiza perfil"]
    
    B -->|Soporte| Q["Soporte/Contacto"]
    Q -->|Tap| R["Enviar email<br/>Ver FAQ"]
    
    B -->|Legal| S["Legal"]
    S -->|Opciones| T["Terms & Conditions<br/>Privacy Policy<br/>Version app"]
    
    B -->|Acciones peligrosas| U["Zona roja"]
    U -->|Opciones| V["Cambiar contraseÃ±a<br/>Logout<br/>Eliminar cuenta"]
    
    V -->|Cambiar contraseÃ±a| W["Modal:<br/>ContraseÃ±a actual<br/>Nueva contraseÃ±a"]
    
    V -->|Logout| X["Confirmacion:<br/>Salir de sesion?"]
    X -->|Confirma| Y["Login Screen"]
    
    V -->|Eliminar| Z["Confirmacion final:<br/>Accion IRREVERSIBLE"]
    Z -->|Confirma + ContraseÃ±a| AA["Cuenta eliminada<br/>Vuelve a Login"]
    
    style A fill:#e3f2fd
    style B fill:#e8f5e9
    style C fill:#c8e6c9
    style D fill:#a5d6a7
    style E fill:#81c784
    style F fill:#fff3e0
    style G fill:#ffeb3b
    style H fill:#fbc02d
    style I fill:#f9a825
    style J fill:#f57f17
    style K fill:#ffc107
    style L fill:#ffb300
    style M fill:#ce93d8
    style N fill:#ba68c8
    style O fill:#ab47bc
    style P fill:#9c27b0
    style Q fill:#8e24aa
    style R fill:#7b1fa2
    style S fill:#6a1b9a
    style T fill:#4527a0
    style U fill:#ffebee
    style V fill:#ffcdd2
    style W fill:#ef9a9a
    style X fill:#e57373
    style Y fill:#ef5350
    style Z fill:#f44336
    style AA fill:#e53935
```

---

```mermaid
graph TD
    A["Login Screen"] -->|Opciones| B{Como ingresa?}
    
    B -->|Email + ContraseÃ±a| C["Form: Email<br/>Password<br/>Remember me"]
    B -->|Google OAuth| D["Google OAuth Flow"]
    B -->|Apple| E["Apple Sign-in Flow"]
    B -->|No tengo cuenta| F["Sign Up"]
    
    C -->|Ingresa datos| G["Validacion:<br/>Email valido?<br/>Password > 6 chars?"]
    G -->|Error| H["Error message"]
    H -->|Corrige| G
    G -->|OK| I["API: POST login"]
    
    D -->|Google aprueba| J["Google OAuth token"]
    J -->|Envia token| K["API: POST auth/google"]
    
    E -->|Apple aprueba| L["Apple token"]
    L -->|Envia token| M["API: POST auth/apple"]
    
    I -->|Response OK| N["Login exitoso<br/>Store token"]
    K -->|Response OK| N
    M -->|Response OK| N
    
    I -->|Response error| O["Credenciales invalidas"]
    O -->|Show| P["Error message<br/>Link: Olvide contraseÃ±a"]
    P -->|Reintentar| C
    
    F -->|Sign Up| Q["Form: Email<br/>Password<br/>Confirm password<br/>Nombre"]
    Q -->|Ingresa datos| R["Validacion:<br/>Email valido?<br/>Password > 8 chars?"]
    R -->|Error| S["Show error"]
    S -->|Corrige| R
    R -->|OK| T["API: POST signup"]
    
    T -->|Response OK| U["Cuenta creada<br/>Envia email verificacion"]
    T -->|Response error| V["Email ya existe"]
    V -->|Show| W["Error: Email en uso"]
    W -->|Tapa| C
    
    U -->|Email enviado| X["Modal:<br/>Revisa tu email"]
    X -->|Usuario abre email| Y["Link de verificacion"]
    Y -->|Tap link| Z["Cuenta verificada<br/>Auto-login"]
    
    Z -->|Exitoso| AB["Inicia Onboarding"]
    N -->|Exitoso| AC["Va a Home Screen"]
    
    P -->|Forgot password| AD["Reset Password Screen"]
    AD -->|Ingresa email| AE["API: POST forgot-password"]
    AE -->|OK| AF["Email enviado"]
    AF -->|Usuario abre email| AG["Link reset"]
    AG -->|Tap link| AH["Nueva contraseÃ±a<br/>Confirmar"]
    AH -->|Ingresa| AI["API: POST reset-password"]
    AI -->|OK| AJ["ContraseÃ±a actualizada"]
    AJ -->|Vuelve a| AC
    
    style A fill:#e3f2fd
    style B fill:#fff3e0
    style C fill:#e8f5e9
    style D fill:#f3e5f5
    style E fill:#ffe0b2
    style F fill:#fff9c4
    style G fill:#ffeb3b
    style H fill:#ffca28
    style I fill:#fbc02d
    style J fill:#f9a825
    style K fill:#f57f17
    style L fill:#4fc3f7
    style M fill:#29b6f6
    style N fill:#c8e6c9
    style O fill:#ffcdd2
    style P fill:#ef9a9a
    style Q fill:#e8f5e9
    style R fill:#c8e6c9
    style S fill:#ffebee
    style T fill:#c8e6c9
    style U fill:#a5d6a7
    style V fill:#ef5350
    style W fill:#f44336
    style X fill:#e53935
    style Y fill:#d32f2f
    style Z fill:#81c784
    style AB fill:#66bb6a
    style AC fill:#4caf50
    style AD fill:#b3e5fc
    style AE fill:#81d4fa
    style AF fill:#4fc3f7
    style AG fill:#29b6f6
    style AH fill:#03a9f4
    style AI fill:#039be5
    style AJ fill:#0288d1
```

---

```mermaid
graph TD
    A["Recipe Detail"] -->|Tap Favorito| B["Add to Favorites"]
    B -->|Validacion| C{Ya es favorito?}
    C -->|No| D["Aniade a favoritos"]
    C -->|Si| E["Elimina de favoritos"]
    
    D -->|Guarda| F["Toast: Aniadido"]
    E -->|Elimina| G["Toast: Eliminado"]
    
    A -->|Home Screen| H["Boton Favoritos"]
    H -->|Tap| I["Mis Favoritos Page"]
    
    I -->|Mostrar| J["Grid de recetas favoritas"]
    J -->|Si vacio| K["Empty state:<br/>No tienes favoritos"]
    K -->|Tap boton| L["Va a Search"]
    
    J -->|Si tiene items| M["Favoritos agrupados"]
    M -->|Filtrar por| N["Tiempo<br/>Dificultad<br/>Tipo"]
    M -->|Ordenar por| O["Reciente<br/>Rating<br/>Nombre"]
    
    I -->|Opcion: Crear Coleccion| P["Nueva Coleccion"]
    P -->|Modal| Q["Nombre coleccion<br/>Descripcion"]
    Q -->|Guarda| R["Coleccion creada"]
    
    R -->|Mostrar en| S["Colecciones en Profile"]
    S -->|Tap coleccion| T["Coleccion View"]
    T -->|Ver recetas| U["Recetas en coleccion"]
    
    T -->|Opciones| V["Add recetas<br/>Edit nombre<br/>Delete"]
    
    V -->|Add| W["Search modal<br/>Selecciona recetas"]
    V -->|Edit| X["Modal edit"]
    V -->|Delete| Y["Confirmacion"]
    
    U -->|Tap receta| AA["Ver Recipe Detail"]
    
    style A fill:#f3e5f5
    style B fill:#ffccbc
    style C fill:#ffab91
    style D fill:#ff8a65
    style E fill:#ff7043
    style F fill:#c8e6c9
    style G fill:#a5d6a7
    style H fill:#81c784
    style I fill:#e8f5e9
    style J fill:#c8e6c9
    style K fill:#fff3e0
    style L fill:#ffeb3b
    style M fill:#fbc02d
    style N fill:#f9a825
    style O fill:#f57f17
    style P fill:#ffc107
    style Q fill:#ffb300
    style R fill:#ffa000
    style S fill:#ff8f00
    style T fill:#64b5f6
    style U fill:#42a5f5
    style V fill:#2196f3
    style W fill:#1e88e5
    style X fill:#1976d2
    style Y fill:#ffcdd2
    style AA fill:#81c784
```

---

```mermaid
graph TD
    A["Settings"] -->|Notificaciones| B["Permitir notificaciones?"]
    B -->|Permite| C["Notificaciones activas"]
    B -->|Rechaza| D["Sin notificaciones"]
    
    C -->|Configurar| E["Settings - Notificaciones"]
    E -->|Opciones| F["Activar/Desactivar<br/>Horarios<br/>Sonido"]
    
    F -->|Tipos disponibles| G["Tipo 1: Comida planeada"]
    F -->|Tipos disponibles| H["Tipo 2: Shopping list"]
    F -->|Tipos disponibles| I["Tipo 3: Weekly recap"]
    
    G -->|Trigger| J["1 hora antes de comida"]
    J -->|Ejemplo| K["Comida: Almuerzo - Pollo<br/>Dia: Martes 12:00"]
    K -->|Usuario recibe| L["Push notification<br/>Cocinamos pollo?"]
    L -->|Tap notificacion| M["Abre app - Recipe"]
    L -->|Dismiss| N["Descarta"]
    
    H -->|Trigger| O["Domingo 6pm"]
    O -->|Notificacion| P["Planifica tu semana"]
    P -->|Tap| Q["Abre Meal Plan"]
    
    I -->|Trigger| R["Lunes 9am"]
    R -->|Notificacion| S["Resumen semanal"]
    S -->|Tap| T["Abre Profile Stats"]
    
    D -->|Sin notificaciones| U["Usuario puede activas despues"]
    U -->|Settings| V["Permitir notificaciones?"]
    V -->|Aceptar| W["Sistema pide permiso"]
    W -->|Permite| C
    
    A -->|Personalizacion| X["Mi cuenta - Notificaciones"]
    X -->|Personalizar| Y["Notificacion para:<br/>Comidas on/off<br/>Lista compras on/off"]
    Y -->|Guardar| Z["Preferencias guardadas"]
    
    style A fill:#e3f2fd
    style B fill:#bbdefb
    style C fill:#c8e6c9
    style D fill:#ffcdd2
    style E fill:#e8f5e9
    style F fill:#fff3e0
    style G fill:#ffc107
    style H fill:#ffb300
    style I fill:#ffa000
    style J fill:#ff8f00
    style K fill:#ff6f00
    style L fill:#ffd54f
    style M fill:#ffca28
    style N fill:#fbc02d
    style O fill:#b3e5fc
    style P fill:#81d4fa
    style Q fill:#4fc3f7
    style R fill:#ce93d8
    style S fill:#ba68c8
    style T fill:#ab47bc
    style U fill:#fff9c4
    style V fill:#ffeb3b
    style W fill:#fbc02d
    style X fill:#e8f5e9
    style Y fill:#c8e6c9
    style Z fill:#a5d6a7
```

---

```mermaid
graph TD
    A["App Iniciada"] -->|Conexion?| B{Hay internet?}
    
    B -->|Si| C["Online Mode"]
    B -->|No| D["Offline Mode"]
    
    C -->|Sync automatico| E["Sincroniza local DB<br/>con cloud backend"]
    E -->|Envia| F["Cambios recientes<br/>Nuevas recetas favoritas"]
    F -->|Cloud actualiza| G["Firebase Backend"]
    G -->|Retorna| H["Datos cloud"]
    H -->|Actualiza local| I["Local SQLite DB"]
    I -->|Todo listo| J["App funcional"]
    
    D -->|Offline Mode| K["Usa datos en dispositivo"]
    K -->|Puedes ver| L["Recetas guardadas<br/>Favoritos<br/>Meal plan<br/>NO: Nuevas recetas"]
    L -->|Puedes hacer| M["Marcar comprados<br/>Editar comidas<br/>NO: Signup"]
    
    M -->|Cambios se guarden| N["Localmente en app"]
    N -->|Cuando internet vuelve| O["Automatico sync"]
    O -->|Retorna online| C
    
    C -->|Background sync| P["Cada 5 minutos<br/>Checa cambios"]
    P -->|Si hay cambios| Q["Descarga automatico"]
    
    D -->|Usuario ve| R["Banner gris arriba<br/>Modo offline"]
    
    A -->|Logout| S["Limpia local DB"]
    
    A -->|Delete account| T["Elimina TODA data"]
    
    style A fill:#e3f2fd
    style B fill:#bbdefb
    style C fill:#c8e6c9
    style D fill:#ffcdd2
    style E fill:#a5d6a7
    style F fill:#81c784
    style G fill:#66bb6a
    style H fill:#4caf50
    style I fill:#43a047
    style J fill:#388e3c
    style K fill:#fff3e0
    style L fill:#ffeb3b
    style M fill:#fbc02d
    style N fill:#f9a825
    style O fill:#f57f17
    style P fill:#e65100
    style Q fill:#bf360c
    style R fill:#b0bec5
    style S fill:#90caf9
    style T fill:#ef5350
```

---

```mermaid
graph TD
    A["Events Tracked"] -->|Eventos| B["onboarding_started"]
    A -->|Eventos| C["onboarding_completed"]
    A -->|Eventos| D["recipe_viewed"]
    A -->|Eventos| E["recipe_favorited"]
    A -->|Eventos| F["recipe_added_to_plan"]
    
    B -->|Data| G["timestamp<br/>source"]
    C -->|Data| H["timestamp<br/>time_taken"]
    D -->|Data| I["timestamp<br/>recipe_id<br/>recipe_name"]
    
    G -->|Envia a| J["Firebase Analytics"]
    H -->|Envia a| J
    I -->|Envia a| J
    
    J -->|Dashboard| K["Analytics Dashboard"]
    K -->|Metricas| L["DAU: X usuarios/dia<br/>MAU: X usuarios/mes<br/>D1 Retention: X%"]
    K -->|Metricas| M["Funnel:<br/>Install > Signup > Onboarding"]
    
    K -->|Crashes| N["Crash Reporting"]
    N -->|Detecta| O["Crash ocurre"]
    O -->|Envia| P["Stack trace<br/>Device info"]
    P -->|Dashboard| Q["Crashlytics Dashboard"]
    Q -->|Prioridad| R["Top crashes<br/>Affected users"]
    
    A -->|Privacidad| S["GDPR Compliant"]
    S -->|Cumple| T["No tracking sin consent"]
    
    style A fill:#e3f2fd
    style B fill:#bbdefb
    style C fill:#90caf9
    style D fill:#64b5f6
    style E fill:#42a5f5
    style F fill:#2196f3
    style J fill:#fff3e0
    style K fill:#f3e5f5
    style L fill:#c8e6c9
    style M fill:#a5d6a7
    style N fill:#ffcdd2
    style Q fill:#ffebee
    style S fill:#e8f5e9
    style T fill:#c8e6c9
```

---

```mermaid
graph TD
    A["Perfil Usuario"] -->|Gamificacion| B["Sistema de Puntos"]
    
    B -->|Acciones| C["Cocinar receta: +10 pts"]
    B -->|Acciones| D["Favoritar: +1 pt"]
    B -->|Acciones| E["Completar dia: +20 pts"]
    B -->|Acciones| F["Completar semana: +100 pts"]
    B -->|Acciones| G["Streak 7 dias: +50 pts"]
    
    C -->|Total| H["Total Puntos:<br/>X puntos acumulados"]
    
    H -->|Niveles| I["Nivel 1: 0-100 pts<br/>Nivel 2: 100-300<br/>Nivel 3: 300-600"]
    
    I -->|Rewards| J["Rewards por nivel:<br/>Level 2: Cocinero<br/>Level 3: Chef"]
    
    J -->|Streaks| K["Racha de dias"]
    K -->|Contador| L["Dia 1: 1<br/>Dia 7: 7<br/>Dia 30: 30"]
    
    J -->|Badges| M["Badges desbloqueables"]
    J -->|Leaderboard| N["Leaderboard:<br/>Top 100 usuarios"]
    
    J -->|Challenges| O["Challenges semanales"]
    O -->|Completar| P["+ 50 bonus pts"]
    
    M -->|Mostrar en| Q["Perfil<br/>Receta cocinada<br/>Leaderboard"]
    
    N -->|Mostrar| R["Top 10 visible globalmente"]
    
    B -->|Premium feature| S["Premium: Mas rewards"]
    
    style A fill:#e3f2fd
    style B fill:#ffc107
    style C fill:#ffeb3b
    style D fill:#fbc02d
    style E fill:#f9a825
    style F fill:#f57f17
    style G fill:#e65100
    style H fill:#ffb300
    style I fill:#ffa000
    style J fill:#ff8f00
    style K fill:#ff6f00
    style L fill:#e65100
    style M fill:#ffd54f
    style N fill:#ffca28
    style O fill:#9c27b0
    style P fill:#7b1fa2
    style Q fill:#6a1b9a
    style R fill:#4527a0
    style S fill:#311b92
```

---

```mermaid
graph TD
    A["Settings"] -->|Tema| B["Theme selector"]
    B -->|Opciones| C["Light Mode"]
    B -->|Opciones| D["Dark Mode"]
    B -->|Opciones| E["System Auto"]
    
    C -->|Selecciona| F["Light mode activado"]
    F -->|Background| G["#F9FAFB Gray 50"]
    F -->|Text| H["#111827 Gray 900"]
    F -->|Guarda| I["UserDefaults/SharedPrefs"]
    I -->|App reload| J["Light mode todas pantallas"]
    
    D -->|Selecciona| K["Dark mode activado"]
    K -->|Background| L["#111827 Gray 900"]
    K -->|Text| M["#F9FAFB Gray 50"]
    K -->|Guarda| N["UserDefaults/SharedPrefs"]
    N -->|App reload| O["Dark mode todas pantallas"]
    
    E -->|Selecciona| P["Auto mode activado"]
    P -->|6am-6pm| Q["Light mode automatico"]
    P -->|6pm-6am| R["Dark mode automatico"]
    P -->|Change| S["Detecta cambio sistema"]
    S -->|Automaticamente| T["Cambia app theme"]
    
    J -->|Componentes| U["Colors actualizados<br/>Shadows adaptadas"]
    O -->|Componentes| U
    T -->|Componentes| U
    
    U -->|Home Screen| V["Colors segun tema"]
    U -->|Recipe Detail| W["Colors segun tema"]
    U -->|Lists| X["Colors segun tema"]
    
    style A fill:#e3f2fd
    style B fill:#bbdefb
    style C fill:#fff59d
    style D fill:#424242
    style E fill:#90caf9
    style F fill:#fff9c4
    style G fill:#ffeb3b
    style H fill:#fbc02d
    style I fill:#f9a825
    style K fill:#303030
    style L fill:#424242
    style M fill:#616161
    style N fill:#757575
    style O fill:#9e9e9e
    style P fill:#b0bec5
    style Q fill:#fff3e0
    style R fill:#263238
    style S fill:#455a64
    style T fill:#37474f
    style U fill:#e1f5e1
    style V fill:#c8e6c9
    style W fill:#a5d6a7
    style X fill:#81c784
```