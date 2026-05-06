#!/bin/bash

echo "🛠 Выполняю финальную полировку кода..."

# 1. Исправляем laramgr.swift: явно гасим предупреждение об неиспользовании
# Добавляем _ = fm сразу после объявления, чтобы компилятор отстал
if [ -f "lara/classes/laramgr.swift" ]; then
    sed -i '/let fm = FileManager.default/a \            _ = fm' lara/classes/laramgr.swift
    sed -i '/let bundleFolder = "\/private\/var\/containers\/Bundle\/Application"/a \            _ = bundleFolder' lara/classes/laramgr.swift
    echo "✅ laramgr.swift: предупреждения об использовании подавлены."
fi

# 2. Исправляем keepalive.swift: меняем var на let и применяем безопасный указатель
if [ -f "lara/funcs/keepalive.swift" ]; then
    # Заменяем var на let, так как v не меняется
    sed -i 's/var v = value/let v = value/g' lara/funcs/keepalive.swift
    # Применяем безопасный способ работы с данными через withUnsafeBytes
    sed -i 's/Data(bytes: \&v, count: MemoryLayout<T>.size)/withUnsafeBytes(of: v) { Data($0) }/g' lara/funcs/keepalive.swift
    echo "✅ keepalive.swift: исправлено на let и добавлен безопасный буфер."
fi

echo "🚀 Готово! Последние штрихи нанесены."
