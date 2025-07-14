# --- Build Stage ---
# Menggunakan image Node.js yang lebih lengkap untuk build
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package.json dan package-lock.json (jika ada)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy sisa source code
COPY . .

# Build the Next.js app
# OpenShift/DevSandbox sudah menyediakan POSTGRES_URL saat runtime, tidak saat build.
# Kita akan menyediakannya sebagai dummy variable saat build untuk mencegah error.
ARG POSTGRES_URL="dummy_url_for_build_only"
RUN npm run build

# --- Production Stage ---
FROM node:18-alpine AS production

WORKDIR /app

# Atur environment ke production
ENV NODE_ENV=production

# Salin hanya artefak yang diperlukan dari tahap build
COPY --from=build --chown=node:node ./.next ./.next
COPY --from=build --chown=node:node ./public ./public
COPY --from=build --chown=node:node ./package.json ./package.json

# Install dependencies produksi
RUN npm install --omit=dev

# Expose port yang digunakan aplikasi (8080 adalah standar untuk OpenShift)
EXPOSE 8080

# Gunakan user non-root untuk keamanan
USER node

# Perintah untuk menjalankan aplikasi
# Ini adalah cara yang paling andal, langsung menjalankan server Next.js dengan Node.
# Menghindari masalah 'next not found'.
CMD ["node", ".next/standalone/server.js"]
