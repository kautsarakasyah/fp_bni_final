# Tahap 1: Build Aplikasi
FROM node:20-alpine AS builder

# Set direktori kerja
WORKDIR /app

# Salin package.json dan package-lock.json
COPY package*.json ./

# Instal dependensi
RUN npm install

# Salin sisa kode aplikasi
COPY . .

# Build aplikasi untuk produksi
# Menambahkan variabel lingkungan untuk build
ARG POSTGRES_URL
ENV POSTGRES_URL=$POSTGRES_URL
RUN npm run build

# Tahap 2: Buat Production Image
FROM node:20-alpine

WORKDIR /app

# Salin dependensi dari tahap builder
COPY --from=builder /app/node_modules ./node_modules
# Salin folder .next yang sudah di-build
COPY --from=builder /app/.next ./.next
# Salin package.json
COPY package.json .
# Salin folder public
COPY public ./public

# Expose port yang digunakan Next.js
EXPOSE 3000

# Perintah untuk menjalankan aplikasi
CMD ["npm", "start", "-p", "3000"]
