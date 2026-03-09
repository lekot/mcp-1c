# mcp-1c
Small and useful local MCP for 1C:Enterprise

Маленький и полезный MCP для 1С:Предприятие

<human>
Всё в репе, кроме этого абзаца, написано ИИ-агентами.

Этот MCP не требует дополнительной обвязки, кроме OneScript, 
можно добавить в проект или в глобальные настройки Cursor IDE для экономии токенов при разработки на 1С.

Скачали папку. закинули json в .cursor, в json указали путь к main.os - должно работать, подробная инструкция от роботов чуть ниже и есть в билде.
Правило (rule) для агентов cursor тоже есть в репе, можно переписать, это по-сути промпт

На разработку потрачено ~10$ на токены и на 200$ времени человека на то, чтобы весь выходной пинать ногами ленивых и тупых роботов. Это увлекательно) Когда-нибудь они скажут так про нас))
</human>
<img width="666" height="362" alt="image" src="https://github.com/user-attachments/assets/79d226c5-5a6e-4842-b844-c50933d11d8a" />
<img width="934" height="336" alt="image" src="https://github.com/user-attachments/assets/e61eec94-6300-4e11-ba09-63a204fca040" />


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

Структура получится:
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

