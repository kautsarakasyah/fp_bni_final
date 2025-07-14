
import { Pool } from 'pg';

export const pool = new Pool({
  connectionString: process.env.POSTGRES_URL,
});

pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

const createTablesQuery = `
  CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    balance NUMERIC(15, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    nominal NUMERIC(15, 2) NOT NULL,
    status VARCHAR(20) NOT NULL
  );
`;

const ensureTablesExist = async () => {
  let client;
  try {
    client = await pool.connect();
    await client.query(createTablesQuery);
    console.log('Tabel berhasil divalidasi/dibuat.');
  } catch (error) {
    console.error('!!! GAGAL MEMBUAT TABEL DATABASE !!!', error);
    throw error;
  } finally {
    if (client) client.release();
  }
};


export const verifyDbConnection = async () => {
  let client;
  try {
    console.log('Mencoba menghubungkan ke database...');
    client = await pool.connect();
    console.log('Koneksi database berhasil!');
    
    console.log('Memastikan tabel tersedia...');
    await ensureTablesExist();
    
  } catch (error) {
    console.error('!!! GAGAL MENGINISIALISASI DATABASE !!!');
    if (error instanceof Error) {
        console.error('Detail Error:', error.message);
        console.error(`URL Koneksi yang Digunakan: ${process.env.POSTGRES_URL ? 'Ada (disembunyikan untuk keamanan)' : 'TIDAK DITEMUKAN'}`);
    }
    throw error;
  } finally {
    if (client) {
      client.release();
      console.log('Koneksi database dilepaskan.');
    }
  }
};
