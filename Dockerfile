# Dockerfile

# Tahap 1: Build Stage - Membangun aplikasi Next.js
FROM node:18 AS build

WORKDIR /app

# Salin file package.json dan package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Salin sisa kode aplikasi
COPY . .

# Tambahkan dummy env var agar proses build tidak gagal
ARG POSTGRES_URL="dummy_url_for_build_only"
# Jalankan build
RUN npm run build


# Tahap 2: Production Stage - Menjalankan aplikasi
FROM node:18-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

# Salin hasil build dari tahap 'build'
# --chown=node:node memastikan file dimiliki oleh user non-root
COPY --from=build --chown=node:node /app/.next ./.next
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/package.json ./package.json

# Secara otomatis mengekspos port yang ditentukan oleh Next.js (default 3000)
# OpenShift akan menangani mapping port ini.
EXPOSE 3000

# Ganti ke user non-root untuk keamanan
USER node

# Perintah untuk menjalankan aplikasi
# Menggunakan 'node server.js' lebih andal daripada 'npm start' di dalam container
CMD ["node", ".next/standalone/server.js"]
