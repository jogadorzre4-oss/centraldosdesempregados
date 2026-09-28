import { Pool } from 'pg';

declare global {
  var __centralDbPool: Pool | undefined;
}

function createPool() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) throw new Error('DATABASE_URL não configurada.');
  return new Pool({
    connectionString,
    ssl: { rejectUnauthorized: false },
    max: 5,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 10000
  });
}

export const db = global.__centralDbPool ?? createPool();
if (process.env.NODE_ENV !== 'production') global.__centralDbPool = db;
