#!/bin/bash

# Путь к файлу данных
DATA_FILE="data/bookings.txt"

# Функция инициализации хранилища
init_storage() {
    mkdir -p data
    if [ ! -f "$DATA_FILE" ]; then
        touch "$DATA_FILE"
    fi
}

# Функция: Показать все бронирования
show_bookings() {
    clear
    echo "=== СПИСОК ВСЕХ БРОНИРОВАНИЙ ==="
    if [ ! -s "$DATA_FILE" ]; then
        echo "Список броней пока пуст."
    else
        cat -n "$DATA_FILE"
    fi
    echo ""
    read -p "Нажмите Enter, чтобы вернуться в меню..."
}

# Функция: Добавить новую бронь
add_booking() {
    clear
    echo "=== ДОБАВЛЕНИЕ НОВОЙ БРОНИ ==="
    read -p "Введите имя клиента: " client_name
    read -p "Введите услугу/номер: " service_name
    read -p "Введите дату (ДД.ММ.ГГГГ): " booking_date

    if [ -z "$client_name" ] || [ -z "$service_name" ] || [ -z "$booking_date" ]; then
        echo "Ошибка: все поля должны быть заполнены!"
    else
        echo "Клиент: $client_name | Услуга: $service_name | Дата: $booking_date" >> "$DATA_FILE"
        echo "Бронирование успешно добавлено!"
    fi
    echo ""
    read -p "Нажмите Enter, чтобы вернуться в меню..."
}

# Функция: Найти бронь (использование text utilities: grep)
search_booking() {
    clear
    echo "=== ПОИСК БРОНИРОВАНИЯ ==="
    read -p "Введите имя клиента или дату для поиска: " query
    
    if [ -z "$query" ]; then
        echo "Запрос не может быть пустым."
    else
        echo "Результаты поиска для '$query':"
        echo "-----------------------------------"
        grep -i "$query" "$DATA_FILE" || echo "Ничего не найдено."
    fi
    echo ""
    read -p "Нажмите Enter, чтобы вернуться в меню..."
}

# Функция: Статистика броней (использование text utilities: wc)
show_stats() {
    clear
    echo "=== СТАТИСТИКА ПРОЕКТА ==="
    init_storage
    total_count=$(wc -l < "$DATA_FILE")
    echo "Всего активных бронирований в базе: $total_count"
    echo "Файл данных: $DATA_FILE"
    echo ""
    read -p "Нажмите Enter, чтобы вернуться в меню..."
}

# Главная функция TUI-интерфейса
main_menu() {
    init_storage
    while true; do
        clear
        echo "========================================"
        echo "   СИСТЕМА БРОНИРОВАНИЯ (BookingService) "
        echo "========================================"
        echo "1. Просмотреть все бронирования"
        echo "2. Добавить новую бронь"
        echo "3. Найти бронирование (через grep)"
        echo "4. Показать статистику (через wc)"
        echo "5. Выход"
        echo "----------------------------------------"
        read -p "Выберите пункт меню [1-5]: " choice

        case $choice in
            1) show_bookings ;;
            2) add_booking ;;
            3) search_booking ;;
            4) show_stats ;;
            5) clear; echo "Выход из программы. До свидания!"; break ;;
            *) echo "Неверный пункт! Пожалуйста, выберите от 1 до 5."; sleep 2 ;;
        esac
    done
}

# Запуск приложения
main_menu
