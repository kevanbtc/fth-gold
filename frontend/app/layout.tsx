import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import Header from '@/components/Header';
import Footer from '@/components/Footer';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'FTH Exchange | Gold-Backed Token Private Placement',
  description: 'Private placement offering of FTH-G tokens backed by vaulted gold. Qualified investors only.',
  keywords: 'gold tokens, private placement, blockchain, FTH-G, DMCC, proof of reserve',
  robots: 'noindex, nofollow', // Private placement - not for public indexing
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={inter.className}>
      <body className="min-h-screen flex flex-col bg-white dark:bg-neutral-950 text-neutral-900 dark:text-neutral-100">
        <Header 
          appName="FTH Exchange"
          // Web3 integration props would be passed here in a real implementation
          // isConnected={isConnected}
          // walletAddress={address}
          // porStatus={porData}
          // onConnectWallet={connect}
          // onDisconnectWallet={disconnect}
          // onSign={signMessage}
          // isAuthenticated={isAuthenticated}
        />
        
        <main className="flex-1">
          {children}
        </main>
        
        <Footer 
          appName="FTH Exchange"
          links={{
            terms: "/legal/terms",
            privacy: "/legal/privacy",
            security: "/legal/security",
            status: "https://status.futuretechholdings.com",
            githubCommunity: "https://github.com/kevanbtc/fth-gold",
            docs: "/docs",
            contact: "/contact",
            manageCookies: "/privacy/cookies",
            doNotSell: "/privacy/do-not-sell"
          }}
          badges={{
            porHealthy: true, // Would be dynamic in real implementation
            chainName: "Polygon",
            walletConnected: false
          }}
        />
      </body>
    </html>
  );
}