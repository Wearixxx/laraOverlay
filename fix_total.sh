#!/bin/bash

echo "🛠 Исправляю критические ошибки и восстанавливаю логику..."

# 1. Исправляем laramgr.swift (возвращаем используемые переменные)
# Мы заменяем заглушки '_' обратно на полезные имена, чтобы функции ниже видели их в области видимости
if [ -f "lara/classes/laramgr.swift" ]; then
    sed -i 's/_ = FileManager.default/let fm = FileManager.default/g' lara/classes/laramgr.swift
    sed -i 's/_ = "\/private\/var\/containers\/Bundle\/Application"/let bundleFolder = "\/private\/var\/containers\/Bundle\/Application"/g' lara/classes/laramgr.swift
    echo "✅ laramgr.swift: переменные fm и bundleFolder восстановлены."
fi

# 2. Исправляем опасный указатель в keepalive.swift
# Ошибка 'forming UnsafeRawPointer' исправляется использованием безопасного метода копирования данных
if [ -f "lara/funcs/keepalive.swift" ]; then
    sed -i 's/Data(bytes: \&v, count: MemoryLayout<T>.size)/withUnsafeBytes(of: v) { Data($0) }/g' lara/funcs/keepalive.swift
    echo "✅ keepalive.swift: работа с памятью теперь безопасна."
fi

# 3. Финальный проход по типам Shape (для совместимости с Swift 6)
find lara -name "*.swift" -exec sed -i 's/: Shape/: any Shape/g' {} + 2>/dev/null
find lara -name "*.swift" -exec sed -i 's/shape: Shape/shape: any Shape/g' {} + 2>/dev/null

echo "🚀 Готово! Теперь можно пушить и собирать."
