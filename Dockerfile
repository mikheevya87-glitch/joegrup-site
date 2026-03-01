# ── Stage 1: Build frontend ──
FROM node:20-alpine AS frontend
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ── Stage 2: Build backend ──
FROM node:20-alpine AS backend
WORKDIR /app/server
COPY server/package*.json ./
RUN npm ci
COPY server/ .
RUN npx prisma generate
RUN npx tsc

# ── Stage 3: Production ──
FROM node:20-alpine
WORKDIR /app

# Copy backend build
COPY --from=backend /app/server/dist ./dist
COPY --from=backend /app/server/node_modules ./node_modules
COPY --from=backend /app/server/prisma ./prisma
COPY --from=backend /app/server/package.json ./

# Copy frontend build
COPY --from=frontend /app/dist ./public

# Create directories
RUN mkdir -p /app/uploads /app/data

# Prisma migrations
RUN npx prisma generate

EXPOSE 3001

ENV NODE_ENV=production
ENV DATABASE_URL="file:/app/data/data.db"
ENV PORT=3001

CMD ["sh", "-c", "npx prisma migrate deploy && node dist/index.js"]
