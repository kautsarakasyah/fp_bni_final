
'use client';

import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { BniIcon } from '@/components/icons';
import { ArrowRight } from 'lucide-react';

export default function HomePage() {
  const router = useRouter();

  return (
    <div 
        className="flex min-h-screen w-full items-center justify-center bg-background p-4 bg-cover bg-center"
        style={{ backgroundImage: "url('/images/logo-bni.jpg')" }}
    >
      <div className="absolute inset-0 bg-black/50 z-0" />
      <div className="flex flex-col items-center gap-6 text-center z-10 rounded-lg bg-card p-8 shadow-xl max-w-md">
        <div className="mx-auto h-auto w-48">
            <BniIcon className="h-full w-full object-contain" />
        </div>
        <div className="space-y-2">
            <h1 className="text-3xl font-bold text-card-foreground">Selamat Datang di Simulasi Transaksi</h1>
            <p className="text-muted-foreground">
                Aplikasi ini adalah prototipe untuk mensimulasikan alur transaksi perbankan digital.
            </p>
        </div>
        <Button size="lg" onClick={() => router.push('/login')}>
            Mulai Simulasi
            <ArrowRight className="ml-2 h-5 w-5" />
        </Button>
      </div>
    </div>
  );
}
