
# Tahap 1: Build Aplikasi
FROM node:20-alpine AS builder

# Set direktori kerja
WORKDIR /app

# Salin package.json dan package-lock.json
COPY package*.json ./

# Instal dependensi produksi
RUN npm install

# Salin sisa kode aplikasi
COPY . .

# Bangun aplikasi
# Kita tidak perlu lagi build-time env vars
RUN npm run build

# Tahap 2: Buat Image Produksi
FROM node:20-alpine

WORKDIR /app

# Atur environment ke produksi
ENV NODE_ENV=production

# Salin build dari tahap builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/next.config.ts ./next.config.ts

# Ekspos port yang digunakan oleh Next.js
EXPOSE 3000

# Perintah untuk menjalankan aplikasi
CMD ["npm", "start", "-p", "3000"]
