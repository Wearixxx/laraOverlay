#!/bin/bash

echo "🛠 Исправляю критические ошибки и предупреждения..."

# 1. Восстанавливаем переменные fm и bundleFolder в laramgr.swift
# Возвращаем их обратно, так как они нужны для работы с файловой системой
if [ -f "lara/classes/laramgr.swift" ]; then
    sed -i 's/_ = FileManager.default/let fm = FileManager.default/g' lara/classes/laramgr.swift
    sed -i 's/_ = "\/private\/var\/containers\/Bundle\/Application"/let bundleFolder = "\/private\/var\/containers\/Bundle\/Application"/g' lara/classes/laramgr.swift
    echo "✅ laramgr.swift: переменные fm и bundleFolder восстановлены."
fi

# 2. Подавляем предупреждения 'unused result' в Logger.swift
# Добавляем '_ =', чтобы компилятор не ругался на неиспользуемый результат try?
if [ -f "lara/classes/Logger.swift" ]; then
    sed -i 's/try? logfilehandle?.seekToEnd()/_ = try? logfilehandle?.seekToEnd()/g' lara/classes/Logger.swift
    echo "✅ Logger.swift: результаты seekToEnd() теперь игнорируются явно."
fi

# 3. Финальная проверка Shape -> any Shape (на всякий случай)
# Это гарантирует отсутствие ошибок в будущих версиях Swift
find lara -name "*.swift" -exec sed -i 's/: Shape/: any Shape/g' {} +
find lara -name "*.swift" -exec sed -i 's/shape: Shape/shape: any Shape/g' {} +

# 4. Исправление привязок типов в EditorView и LGView (устранение неоднозначности)
# Делаем параметры обязательными, чтобы Swift не гадал с типом T
for file in "lara/views/tweaks/springboard/LGView.swift" "lara/views/tweaks/ui/EditorView.swift"; do
    if [ -f "$file" ]; then
        sed -i 's/type: T.Type = Bool.self/type: T.Type/g' "$file" 2>/dev/null
        sed -i 's/type: T.Type = Int.self/type: T.Type/g' "$file" 2>/dev/null
        sed -i 's/default: T? = false/default: T?/g' "$file" 2>/dev/null
        sed -i 's/default: T? = 0/default: T?/g' "$file" 2>/dev/null
        sed -i 's/enable: T? = true/enable: T?/g' "$file" 2>/dev/null
        sed -i 's/enable: T? = 1/enable: T?/g' "$file" 2>/dev/null
    fi
done

echo "🚀 Все исправления применены. Можно пушить!"
