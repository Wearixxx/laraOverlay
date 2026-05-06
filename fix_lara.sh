#!/bin/bash

echo "🚀 Начинаю автоматическое исправление кода..."

# 1. Исправляем протоколы Shape на 'any Shape' в PartyUI
# Это устраняет предупреждения: "use of protocol 'Shape' as a type must be written 'any Shape'"
find lara/PartyUI -name "*.swift" -exec sed -i 's/: Shape/: any Shape/g' {} +
find lara/PartyUI -name "*.swift" -exec sed -i 's/shape: Shape/shape: any Shape/g' {} +

# 2. Исправляем неоднозначность типов в LGView.swift
# Убираем дефолтные значения для дженериков, которые путают компилятор
if [ -f "lara/views/tweaks/springboard/LGView.swift" ]; then
    sed -i 's/type: T.Type = Bool.self/type: T.Type/g' lara/views/tweaks/springboard/LGView.swift
    sed -i 's/default: T? = false/default: T?/g' lara/views/tweaks/springboard/LGView.swift
    sed -i 's/enable: T? = true/enable: T?/g' lara/views/tweaks/springboard/LGView.swift
    echo "✅ LGView.swift пропатчен."
fi

# 3. Исправляем неоднозначность типов в EditorView.swift
if [ -f "lara/views/tweaks/ui/EditorView.swift" ]; then
    sed -i 's/type: T.Type = Int.self/type: T.Type/g' lara/views/tweaks/ui/EditorView.swift
    sed -i 's/default: T? = 0/default: T?/g' lara/views/tweaks/ui/EditorView.swift
    sed -i 's/enable: T? = 1/enable: T?/g' lara/views/tweaks/ui/EditorView.swift
    echo "✅ EditorView.swift пропатчен."
fi

# 4. Исправляем переменную 'text' в Logger.swift (var -> let)
if [ -f "lara/classes/Logger.swift" ]; then
    sed -i 's/var text = panding/let text = panding/g' lara/classes/Logger.swift
    echo "✅ Logger.swift исправлен."
fi

# 5. Очистка неиспользуемых переменных в laramgr.swift
if [ -f "lara/classes/laramgr.swift" ]; then
    sed -i 's/let fm = FileManager.default/_ = FileManager.default/g' lara/classes/laramgr.swift
    sed -i 's/let bundleFolder = /_ = /g' lara/classes/laramgr.swift
    echo "✅ laramgr.swift очищен от неиспользуемых let."
fi

echo "✨ Все исправления применены! Попробуй запустить сборку снова."
