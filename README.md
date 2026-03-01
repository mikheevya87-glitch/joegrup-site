# CleanDrop — Премиальная бытовая химия

Полноценный сайт-каталог с админ-панелью, корзиной, заказами, обратными звонками и уведомлениями в Telegram.

## 🏗️ Архитектура

```
Frontend:  Vite + React + TypeScript + Tailwind CSS
Backend:   Node.js + Express + Prisma + SQLite
Auth:      JWT в httpOnly cookies
Upload:    Multer (локально) / S3-compatible (опционально)
Deploy:    Docker / VPS / Vercel+Railway
```

## 🚀 Быстрый старт (разработка)

### 1. Frontend (работает автономно с localStorage)

```bash
npm install
npm run dev
```
Сайт доступен на `http://localhost:5173`
**Логин:** `admin` / **Пароль:** `admin123`

### 2. Backend (опционально, для полного функционала)

```bash
cd server
cp .env.example .env    # настройте переменные
npm install
npx prisma migrate dev  # создаст SQLite базу
npm run dev              # сервер на :3001
```

Для подключения фронта к бэкенду, создайте `.env` в корне:
```
VITE_API_URL=http://localhost:3001
```

## 🐳 Docker (продакшен)

```bash
# Настройте переменные
cp server/.env.example .env

# Запуск
docker-compose up -d

# Сайт на http://localhost:3001
```

### Переменные окружения

| Переменная | Описание | По умолчанию |
|---|---|---|
| `PORT` | Порт сервера | `3001` |
| `DATABASE_URL` | SQLite/PostgreSQL URL | `file:./data.db` |
| `JWT_SECRET` | Секрет для JWT | `change-me` |
| `ADMIN_EMAIL` | Логин админа | `admin` |
| `ADMIN_PASSWORD` | Пароль админа | `admin123` |
| `FRONTEND_ORIGIN` | CORS origin | `http://localhost:5173` |
| `TELEGRAM_BOT_TOKEN` | Токен Telegram бота | — |

## 📱 Функционал

### Витрина
- 🎨 **Премиальный дизайн** — тёмная/светлая тема, анимации капель
- 🛒 **Каталог** — категории, фильтры, карточки товаров
- 🛍️ **Корзина + Заказ** — добавление товаров, оформление
- 📞 **Обратный звонок** — форма заявки
- 📱 **Mobile-first** — адаптивный дизайн
- ♿ **prefers-reduced-motion** — анимации отключаются

### Админ-панель (⚙️)
- 📞 **Заявки** — обратные звонки, статусы
- 📦 **Заказы** — полный состав, сумма, статусы
- 👥 **Клиенты** — зарегистрированные пользователи
- 🛒 **Товары** — CRUD, скрытие/показ, бейджи, фото (URL + загрузка)
- 📁 **Категории** — CRUD, скрытие/показ, фото
- 🏢 **О компании** — тексты, статистика, маркетплейсы
- 🏷️ **Линейки** — бренд-линейки
- ⚙️ **Настройки**:
  - Основные (название, логотип с загрузкой)
  - Тема (тёмная/светлая)
  - Телефон (показать/скрыть, текст замены)
  - Контакты (email, адрес, расписание)
  - Баннер (заголовок, подзаголовок, изображение)
  - Соцсети (VK, Telegram, WhatsApp)
  - Telegram уведомления (вкл/выкл, chat_id, типы)
  - Смена пароля

### Telegram уведомления (через сервер)
- Новая заявка на звонок
- Новый заказ
- Новая регистрация
- Тестовое сообщение из админки

## 🔐 Безопасность

- ✅ Telegram bot token **только на сервере** (`.env`), никогда на фронте
- ✅ Пароли хешируются через **bcrypt**
- ✅ JWT в **httpOnly cookies** (не в localStorage)
- ✅ **Rate limiting** на публичные endpoints
- ✅ **Helmet + CORS** на сервере
- ✅ Загрузка файлов: валидация типа/размера, рандомные имена
- ✅ Защита от path traversal

## 📂 Структура проекта

```
├── src/                    # Frontend (React + Vite)
│   ├── components/
│   │   ├── Header.tsx      # Шапка + тема + телефон
│   │   ├── Hero.tsx        # Баннер + капля/изображение
│   │   ├── Catalog.tsx     # Каталог товаров
│   │   ├── About.tsx       # О компании
│   │   ├── BrandLines.tsx  # Линейки
│   │   ├── Footer.tsx      # Подвал
│   │   ├── LoginModal.tsx  # Вход/регистрация
│   │   └── AdminPanel.tsx  # Админ-панель
│   ├── contexts/
│   │   └── AppContext.tsx   # Стейт + localStorage + API
│   ├── api.ts              # API слой (backend интеграция)
│   ├── data.ts             # Типы + дефолтные данные
│   ├── App.tsx             # Главный компонент
│   └── index.css           # Стили + темы + токены
├── server/                  # Backend (Express + Prisma)
│   ├── src/
│   │   └── index.ts        # Сервер + все роуты
│   ├── prisma/
│   │   └── schema.prisma   # Схема БД
│   └── .env.example        # Шаблон переменных
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## 💡 Переключение на PostgreSQL

1. Измените `provider` в `server/prisma/schema.prisma`:
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

2. Обновите `DATABASE_URL` в `.env`:
```
DATABASE_URL="postgresql://user:password@localhost:5432/cleandrop"
```

3. Запустите миграцию:
```bash
npx prisma migrate dev
```
