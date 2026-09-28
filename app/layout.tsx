import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Central dos Desempregados',
  description: 'Encontre sua próxima oportunidade.'
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return <html lang="pt-BR"><body>{children}</body></html>;
}