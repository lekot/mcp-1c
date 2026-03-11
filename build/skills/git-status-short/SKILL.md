---
name: git-status-short
description: Use git status --short when checking repository status. Keeps output compact and saves context. Use when the agent needs to see working tree state, changed files, or before suggesting git add/commit.
---

# Git status — короткий вывод

## Правило

При проверке состояния репозитория всегда вызывать **`git status --short`**, а не `git status`.

- Вывод компактный (по одной строке на файл), меньше токенов.
- Достаточно для решений «что изменилось» и «что коммитить».

## Пример

```bash
git status --short
```

Типичный вывод:
```
 M docs/AGENT-HANDOFF.md
?? scripts/newfile.os
```

## Когда применять

- Нужно узнать, есть ли незакоммиченные изменения.
- Перед предложением `git add` / `git commit`.
- При любом запросе «статус репо», «что изменено», «git status».

Полный `git status` вызывать только если пользователь явно просит подробный вывод или ветки/upstream.
