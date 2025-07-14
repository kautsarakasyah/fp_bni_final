# Tahap 1: Build aplikasi
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Argumen ini ada untuk memastikan 'next build' tidak gagal karena variabel lingkungan yang hilang.
ARG POSTGRES_URL="dummy_url_for_build_only"
RUN npm run build

# Tahap 2: Buat image produksi yang ramping
FROM node:18-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

# Salin file yang diperlukan dari tahap build
COPY --from=build --chown=node:node /app/.next ./.next
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/package.json ./package.json
COPY --from=build --chown=node:node /app/public ./public

# Gunakan user non-root untuk keamanan
USER node

# Expose port yang akan digunakan oleh aplikasi
EXPOSE 8080

# Perintah untuk menjalankan aplikasi
CMD ["npm", "start"]
