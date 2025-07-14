
import { Pool } from 'pg';

// Konfigurasi koneksi akan diambil dari variabel lingkungan
// Pastikan Anda membuat file .env.local di root proyek Anda
// dengan isi sebagai berikut:
//
// POSTGRES_URL="postgres://user:password@host:port/database"
//
// Contoh:
// POSTGRES_URL="postgres://postgres:mysecretpassword@localhost:5432/bni_prototype"

// Kita akan membiarkan connectionString kosong jika POSTGRES_URL tidak ada saat build.
// Pool akan melempar error saat koneksi pertama kali dicoba jika string koneksi tidak valid,
// yang terjadi saat runtime, bukan saat build.
export const pool = new Pool({
  connectionString: process.env.POSTGRES_URL,
});

// Menambahkan listener untuk memastikan kita mendapatkan error yang jelas jika koneksi gagal saat runtime.
pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});
