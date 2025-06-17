# 🧾 Descripción del jsonSchema de Receta Enriquecida

Este esquema define la estructura de una respuesta generada para una receta de cocina, incluyendo propiedades nutricionales, de salud, ambientales, culturales y de presentación.

## 🧩 Nivel superior (estructura principal)

```bash
| Clave           | Tipo                  | Descripción                                                               |
| --------------- | --------------------- | ------------------------------------------------------------------------- |
| `isValidRecipe` | `boolean`             | Indica si la entrada fue válida y se generó una receta.                   |
| `errorMessage`  | `string` *(opcional)* | Mensaje de error si no se pudo generar la receta.                         |
| `result`        | `object` *(opcional)* | Contiene los datos detallados de la receta, si `isValidRecipe` es `true`. |
| `cacheTime`     | `number` *(opcional)* | Marca de tiempo de caché (timestamp UNIX).                                |
| `time`          | `number` *(opcional)* | Tiempo de generación de la receta (timestamp UNIX).                       |
```

## 📦 result (contenido de la receta)

```bash
| Clave          | Tipo      | Descripción                                      |
| -------------- | --------- | ------------------------------------------------ |
| `title`        | `string`  | Nombre del plato.                                |
| `summary`      | `string`  | Descripción breve.                               |
| `isVegetarian` | `boolean` | Si es un plato vegetariano.                      |
| `mealType`     | `string`  | Tipo de comida (desayuno, almuerzo, cena, etc.). |
| `difficulty`   | `string`  | Nivel de dificultad.                             |
| `isAllergenic` | `boolean` | Si contiene alérgenos comunes.                   |
```

## 🧪 Alergias y Reemplazos

```bash
| Clave                      | Tipo    | Descripción                                     |
| -------------------------- | ------- | ----------------------------------------------- |
| `allergens`                | `array` | Lista de alérgenos presentes.                   |
| `AlternativasIngredientes` | `array` | Reemplazos sugeridos para ciertos ingredientes. |
```

## 🧂 Ingredientes y Preparación

```bash
| Clave                  | Tipo    | Descripción                                    |
| ---------------------- | ------- | ---------------------------------------------- |
| `ingredients`          | `array` | Ingredientes con nombre, cantidad e ID.        |
| `instructions`         | `array` | Pasos de preparación del plato.                |
| `plating_instructions` | `array` | Instrucciones para servir o emplatar el plato. |
```

## 🍎 Información Nutricional

```bash
| Clave            | Tipo     | Descripción                                                          |
| ---------------- | -------- | -------------------------------------------------------------------- |
| `nutrition_info` | `object` | Información general: calorías, proteína, carbohidratos, grasas, etc. |
| `macros`         | `object` | Macronutrientes en gramos o miligramos.                              |
| `glycemic_index` | `number` | Índice glucémico del plato.                                          |
```

## 🥗 Salud y Dietas

```bash
| Clave                    | Tipo     | Descripción                                                   |
| ------------------------ | -------- | ------------------------------------------------------------- |
| `diets`                  | `array`  | Dietas compatibles (ej: keto, paleo, vegana).                 |
| `recommended_servings`   | `object` | Porciones sugeridas para adulto, niño, atleta y adulto mayor. |
| `satiety_level`          | `string` | Nivel de saciedad (ej: alto, medio, bajo).                    |
| `digestion_time_minutes` | `number` | Tiempo estimado de digestión.                                 |
| `medical_restrictions`   | `array`  | Condiciones médicas incompatibles con el plato.               |
| `health_warnings`        | `array`  | Advertencias de salud adicionales.                            |
```

## 🌱 Otros aspectos

```bash
| Clave                  | Tipo     | Descripción                                                                         |
| ---------------------- | -------- | ----------------------------------------------------------------------------------- |
| `processing_level`     | `number` | Nivel de procesamiento del alimento (0 = natural, 3 = ultra procesado).             |
| `environmental_impact` | `string` | Impacto ambiental del plato.                                                        |
| `extra_info`           | `object` | Información adicional: país de origen, temporada ideal, método de cocción, picante. |
| `similar_dishes`       | `array`  | Platos similares sugeridos.                                                         |
| `recommended_pairings` | `object` | Maridajes sugeridos (bebidas, guarniciones, postres).                               |
```

### josn de respuesta

````json
{
        "isValidRecipe": true,
        "result": {
          "AlternativasIngredientes": [
            {
              "alternativas": [
                {
                  "name": "Pato silvestre"
                }
              ],
              "original": "Pato de granja"
            },
            {
              "alternativas": [
                {
                  "name": "Arroz bomba"
                }
              ],
              "original": "Arroz tipo arborio"
            },
            {
              "alternativas": [
                {
                  "name": "Culantro"
                }
              ],
              "original": "Perejil"
            }
          ],
          "allergens": [
            {
              "name": "Ninguno identificado"
            }
          ],
          "diets": [
            {
              "name": "Omnívora"
            }
          ],
          "difficulty": "Media",
          "digestion_time_minutes": 150,
          "environmental_impact": "Moderado, dependiendo de la procedencia del pato y el arroz.",
          "extra_info": {
            "cooking_method": "Estofado y cocción en arroz",
            "ideal_season": "Otoño/Invierno",
            "origin_country": "Perú",
            "spicy_level": "Opcional (ají amarillo)"
          },
          "glycemic_index": 60,
          "health_warnings": [
            {
              "text": "Consumir con moderación debido a su contenido calórico y de grasas."
            }
          ],
          "ingredients": [
            {
              "amount": "1 pato entero (aprox. 2 kg)",
              "id": 1,
              "name": "Pato de granja"
            },
            {
              "amount": "2 tazas",
              "id": 2,
              "name": "Arroz tipo arborio"
            },
            {
              "amount": "1 taza",
              "id": 3,
              "name": "Cerveza negra"
            },
            {
              "amount": "1 cebolla roja grande, picada",
              "id": 4,
              "name": "Cebolla roja"
            },
            {
              "amount": "2 cucharadas",
              "id": 5,
              "name": "Ajo molido"
            },
            {
              "amount": "1 ají amarillo sin venas ni pepas, picado (opcional)",
              "id": 6,
              "name": "Ají amarillo"
            },
            {
              "amount": "1/2 taza",
              "id": 7,
              "name": "Culantro picado"
            },
            {
              "amount": "Aceite vegetal, cantidad necesaria",
              "id": 8,
              "name": "Aceite vegetal"
            },
            {
              "amount": "Sal y pimienta al gusto",
              "id": 9,
              "name": "Sal y pimienta"
            },
            {
              "amount": "5 tazas",
              "id": 10,
              "name": "Caldo de pollo"
            }
          ],
          "instructions": [
            {
              "step": 1,
              "text": "Trocear el pato y sazonarlo con sal, pimienta y comino. Dejar macerar por al menos 30 minutos."
            },
            {
              "step": 2,
              "text": "En una olla grande, calentar aceite a fuego medio. Dorar los trozos de pato por todos lados. Retirar y reservar."
            },
            {
              "step": 3,
              "text": "En la misma olla, sofreír la cebolla roja, el ajo y el ají amarillo (si se usa) hasta que estén dorados."
            },
            {
              "step": 4,
              "text": "Agregar el pato nuevamente a la olla. Incorporar la cerveza negra y dejar reducir por unos minutos."
            },
            {
              "step": 5,
              "text": "Añadir el arroz y el caldo de pollo caliente. Remover y llevar a ebullición. Luego, bajar el fuego, tapar la olla y cocinar a fuego lento durante unos 20-25 minutos, o hasta que el arroz esté cocido y el líquido se haya absorbido."
            },
            {
              "step": 6,
              "text": "Incorporar el culantro picado. Mezclar suavemente y dejar reposar por unos minutos antes de servir."
            }
          ],
          "isAllergenic": false,
          "isVegetarian": false,
          "macros": {
            "carbs_g": 60,
            "cholesterol_mg": 150,
            "fats_g": 45,
            "fiber_g": 3,
            "iron_mg": 4,
            "protein_g": 50,
            "sodium_mg": 500,
            "sugar_g": 5,
            "vitamin_c_mg": 8
          },
          "mealType": "Plato principal",
          "medical_restrictions": [
            {
              "name": "Colesterol alto (consumir con moderación)"
            }
          ],
          "nutrition_info": {
            "calories": 800,
            "carbs": "60g",
            "cholesterol": "150mg",
            "fats": "45g",
            "fiber": "3g",
            "iron": "4mg",
            "protein": "50g",
            "sodium": "500mg",
            "sugar": "5g",
            "vitamin_c": "8mg"
          },
          "plating_instructions": [
            {
              "description": "Servir el arroz con pato en un plato hondo.",
              "step": 1
            },
            {
              "description": "Decorar con una ramita de culantro fresco.",
              "step": 2
            },
            {
              "description": "Acompañar con una porción de salsa criolla (cebolla roja, ají limo, culantro, limón).",
              "step": 3
            }
          ],
          "processing_level": 2,
          "recommended_pairings": {
            "desserts": [
              {
                "name": "Suspiro limeño"
              }
            ],
            "drinks": [
              {
                "name": "Chicha morada"
              }
            ],
            "sides": [
              {
                "name": "Salsa criolla"
              }
            ]
          },
          "recommended_servings": {
            "adult": "1 porción generosa",
            "athlete": "1.5 porciones",
            "child": "Media porción",
            "senior": "Media porción"
          },
          "satiety_level": "Alto",
          "similar_dishes": [
            {
              "name": "Arroz con pollo"
            },
            {
              "name": "Seco de cordero"
            }
          ],
          "summary": "Un plato emblemático de la cocina peruana, combinación perfecta de arroz, pato tierno y aromas únicos.",
          "title": "Arroz con pato"
        },
        "cacheTime": 1718493485,
        "time": 1718493485
      }
      ```
````
