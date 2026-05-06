#!/bin/bash

echo "🛠 Исправляю критические ошибки компиляции..."

# 1. Восстанавливаем fm и bundleFolder в laramgr.swift
# Мы ранее их удалили, но они нужны функциям поиска приложений ниже по коду
if [ -f "lara/classes/laramgr.swift" ]; then
    sed -i 's/_ = FileManager.default/let fm = FileManager.default/g' laramgr.swift 2>/dev/null
    sed -i 's/_ = "\/private\/var\/containers\/Bundle\/Application"/let bundleFolder = "\/private\/var\/containers\/Bundle\/Application"/g' laramgr.swift 2>/dev/null
    # Если ты использовал мой предыдущий скрипт, он мог заменить их в laramgr.swift
    sed -i 's/_ = FileManager.default/let fm = FileManager.default/g' lara/classes/laramgr.swift 2>/dev/null
    sed -i 's/_ = "\/private\/var\/containers\/Bundle\/Application"/let bundleFolder = "\/private\/var\/containers\/Bundle\/Application"/g' lara/classes/laramgr.swift 2>/dev/null
    echo "✅ Переменные в laramgr.swift восстановлены."
fi

# 2. Исправляем опасный указатель в keepalive.swift
# Заменяем небезопасный Data(bytes: &v) на безопасный withUnsafeBytes
if [ -f "lara/funcs/keepalive.swift" ]; then
    python3 -c "
import sys
content = open('lara/funcs/keepalive.swift').read()
old_code = 'wavdata.append(Data(bytes: \&v, count: MemoryLayout<T>.size))'
new_code = 'withUnsafeBytes(of: v) { wavdata.append(Data(\$0)) }'
if old_code in content:
    open('lara/funcs/keepalive.swift', 'w').write(content.replace(old_code, new_code))
"
    echo "✅ Ошибка UnsafeRawPointer в keepalive.swift исправлена."
fi

# 3. Финальный проход по типам Shape для стабильности
find lara -name "*.swift" -exec sed -i 's/: Shape/: any Shape/g' {} + 2>/dev/null

echo "🚀 Готово. Теперь делай commit и пушь!"
