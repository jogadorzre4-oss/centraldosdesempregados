import { NextResponse } from 'next/server';
import { db } from '@/lib/db';

export async function GET() {
  try {
    const result = await db.query('select now() as server_time, current_database() as database');
    return NextResponse.json({ ok: true, database: result.rows[0].database, serverTime: result.rows[0].server_time });
  } catch (error) {
    console.error('Database health check failed:', error);
    return NextResponse.json({ ok: false, error: 'Não foi possível conectar ao banco.' }, { status: 500 });
  }
}
