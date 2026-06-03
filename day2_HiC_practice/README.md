## Загрузка готовых карт, конвертация `.hic` в `.mcool` и балансировка

Для практики второго дня нам нужны готовые карты, для которых мы будем считать различные метрики.

Juicebox работает с `.hic`, а библиотеки `cooler` и `cooltools` работают с форматами
`.cool` и `.mcool`. Поэтому готовые карты или результат Juicer нужно конвертировать в
multi-resolution cooler и сбалансировать.

Не тратим время, сразу скачиваем готовые карты и конвертируем их в `mcool` формат
```bash
python scripts/download_data.py \
  --hic results/hic/MoPh7.inter.hic \
  --data-dir data \
  --nproc 4
```

Скрипт `scripts/download_data.py` делает три вещи:

- скачивает `.hic` файлы по URL или берет локальный `.hic`;
- конвертирует `.hic` в `.mcool` через `hic2cool`;
- запускает `cooler balance` для всех разрешений внутри `.mcool`.


Проверим, какие разрешения появились:

```bash
cooler ls data/MoPh7.inter.mcool
```

Проверим одно разрешение:

```bash
cooler info data/MoPh7.inter.mcool::/resolutions/1000000
```

## Шаг 9. Установка Juicebox для визуализации

Juicebox нужен для интерактивного просмотра `.hic` карт.

Страница релизов:
<https://github.com/aidenlab/Juicebox/releases>

Для macOS или Linux можно скачать `.jar`:

```bash
wget -O tools/Juicebox.jar \
  https://github.com/aidenlab/Juicebox/releases/download/v2.20.00/Juicebox.jar
```

Запуск:

```bash
java -jar tools/Juicebox.jar
```

В Juicebox:

1. `File` -> `Open`;
2. выбрать `results/hic/MoPh7.inter.hic`;
3. выбрать хромосому или весь геном;
4. менять разрешение карты;
5. сравнить вид сырой и нормализованной матрицы, если нормализация доступна.

Далее для практики мы будем использовать те же карты, только более глубокие
для них было выровнено большее количество ридов на референс.

Для загрузки используем скрипт:

```text
scripts/download_data.py
```

Что делает скрипт:

- скачивает `.hic` файлы из списка `URLS` в папку `data/`;
- конвертирует каждый `.hic` в multi-resolution `.mcool`;
- балансирует все разрешения внутри `.mcool` с помощью `cooler balance`.

После завершения в папке `data/` должны появиться пары файлов:

```text
data/*_inter_30.hic
data/*Control*_inter_30.mcool
```

Проверить список разрешений внутри `.mcool` можно так:

```bash
cooler ls data/Control_inter_30.mcool
```
