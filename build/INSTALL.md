# mcp-1c-onescript — установка

MCP-сервер для работы с выгрузкой конфигурации 1С в Cursor. Даёт агенту инструменты `bsl_search`, `xml_search`, `config_list`, `read_module` — поиск по коду и метаданным без ручного обхода файлов.

## Требования

- [OneScript 2.0+](https://oscript.io/) — `oscript` должен быть в PATH
- Cursor IDE

## Установка

### 1. Скопировать сервер

Скопируй папку `build/` в любое место **без кириллицы в пути**, например:

```
C:\mcp-1c\
```

Структура должна быть:
```
C:\mcp-1c\
  main.os
  src\
    Dispatcher.os
    adapters\...
    common\...
    domain\...
    handlers\...
    usecases\...
```

### 2. Прописать в глобальный конфиг Cursor

Открой (или создай) файл `%USERPROFILE%\.cursor\mcp.json` и добавь сервер:

```json
{
  "mcpServers": {
    "mcp-1c-onescript": {
      "command": "oscript",
      "args": ["C:\\mcp-1c\\main.os"]
    }
  }
}
```

> **Важно:** путь к `main.os` должен быть без кириллицы. Если в пути есть кириллица (например `C:\Users\Максим\...`), Cursor передаёт его в искажённом виде и сервер не запускается.

> **Важно:** не дублируй сервер в локальном `.cursor/mcp.json` проекта — Cursor запустит два процесса с одним именем, один из них сразу получит EOF и упадёт.

### 3. Перезапустить MCP в Cursor

Settings → MCP → кнопка рестарт рядом с `mcp-1c-onescript`. Должно появиться `4 tools`.

## Подключение к проекту с 1С

Чтобы агент автоматически использовал MCP при работе с выгрузкой 1С, скопируй правило в проект:

```
build\1c-mcp-metadata.mdc  →  <твой-проект>\.cursor\rules\1c-mcp-metadata.mdc
```

Правило активируется автоматически при открытии `.bsl` и `.xml` файлов конфигурации.

## Проверка

```powershell
echo '{"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1"}},"jsonrpc":"2.0","id":0}' | oscript C:\mcp-1c\main.os
```

Должен вернуть JSON с `"result":{"protocolVersion":"2024-11-05",...}`.
