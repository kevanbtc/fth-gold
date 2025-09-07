import React from 'react';
import Link from 'next/link';

export default function HomePage() {
  return (
    <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
      {/* Hero Section */}
      <div className="text-center mb-16">
        <div className="mx-auto h-16 w-16 rounded-2xl gold-gradient shadow-lg mb-6"></div>
        <h1 className="text-4xl font-bold tracking-tight mb-4 sm:text-6xl">
          FTH Gold (FTH-G)
        </h1>
        <p className="text-xl text-neutral-600 dark:text-neutral-400 mb-8 max-w-2xl mx-auto">
          Private placement offering of gold-backed tokens. Each FTH-G token represents 
          1 kilogram of vaulted gold stored in DMCC-licensed facilities.
        </p>
        
        <div className="rounded-xl border border-amber-200 bg-amber-50 p-6 mb-8 max-w-2xl mx-auto dark:border-amber-800/60 dark:bg-amber-900/20">
          <p className="text-amber-800 dark:text-amber-200">
            <strong>Private Placement Only:</strong> This offering is available exclusively to 
            qualified accredited investors through private invitation.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link
            href="/dashboard"
            className="inline-flex items-center justify-center rounded-xl bg-neutral-900 px-6 py-3 text-sm font-medium text-white hover:bg-black dark:bg-white dark:text-black dark:hover:bg-neutral-200"
          >
            Access Platform
          </Link>
          <Link
            href="/legal/terms"
            className="inline-flex items-center justify-center rounded-xl border border-neutral-200 px-6 py-3 text-sm font-medium text-neutral-700 hover:bg-neutral-50 dark:border-neutral-800 dark:text-neutral-300 dark:hover:bg-neutral-900"
          >
            Review Terms
          </Link>
        </div>
      </div>

      {/* Key Features */}
      <div className="grid gap-8 md:grid-cols-3 mb-16">
        <div className="text-center p-6 rounded-2xl border border-neutral-200 dark:border-neutral-800">
          <div className="h-12 w-12 rounded-xl bg-emerald-100 dark:bg-emerald-900/20 mx-auto mb-4 flex items-center justify-center">
            <svg className="h-6 w-6 text-emerald-600 dark:text-emerald-400" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.623 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z" />
            </svg>
          </div>
          <h3 className="text-lg font-semibold mb-2">Proof of Reserve</h3>
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            Chainlink-verified proof of vaulted gold holdings with real-time attestations
          </p>
        </div>

        <div className="text-center p-6 rounded-2xl border border-neutral-200 dark:border-neutral-800">
          <div className="h-12 w-12 rounded-xl bg-blue-100 dark:bg-blue-900/20 mx-auto mb-4 flex items-center justify-center">
            <svg className="h-6 w-6 text-blue-600 dark:text-blue-400" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z" />
            </svg>
          </div>
          <h3 className="text-lg font-semibold mb-2">Regulatory Compliance</h3>
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            Multi-jurisdiction compliance with KYC/AML verification and soulbound tokens
          </p>
        </div>

        <div className="text-center p-6 rounded-2xl border border-neutral-200 dark:border-neutral-800">
          <div className="h-12 w-12 rounded-xl bg-amber-100 dark:bg-amber-900/20 mx-auto mb-4 flex items-center justify-center">
            <svg className="h-6 w-6 text-amber-600 dark:text-amber-400" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" d="M12 6v12m-3-2.818l.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <h3 className="text-lg font-semibold mb-2">Gold-Backed Value</h3>
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            Each token represents 1kg of physical gold stored in Dubai DMCC vaults
          </p>
        </div>
      </div>

      {/* Token Economics */}
      <div className="rounded-2xl border border-neutral-200 p-8 mb-16 dark:border-neutral-800">
        <h2 className="text-2xl font-bold mb-6 text-center">Token Structure</h2>
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
          <div className="text-center">
            <div className="text-3xl font-bold text-amber-600 dark:text-amber-400 mb-2">1 KG</div>
            <div className="text-sm font-medium">Gold per Token</div>
          </div>
          <div className="text-center">
            <div className="text-3xl font-bold text-blue-600 dark:text-blue-400 mb-2">5 MO</div>
            <div className="text-sm font-medium">Staking Period</div>
          </div>
          <div className="text-center">
            <div className="text-3xl font-bold text-emerald-600 dark:text-emerald-400 mb-2">DMCC</div>
            <div className="text-sm font-medium">Licensed Vaults</div>
          </div>
          <div className="text-center">
            <div className="text-3xl font-bold text-purple-600 dark:text-purple-400 mb-2">KYC</div>
            <div className="text-sm font-medium">Verified Only</div>
          </div>
        </div>
      </div>

      {/* Legal Notice */}
      <div className="rounded-xl border border-red-200 bg-red-50 p-6 text-center dark:border-red-800/60 dark:bg-red-900/20">
        <h3 className="font-semibold text-red-800 dark:text-red-200 mb-2">Important Legal Notice</h3>
        <p className="text-sm text-red-700 dark:text-red-300">
          FTH-G tokens are offered exclusively through private placement to qualified accredited investors. 
          This is not a public offering. Please read the complete Private Placement Memorandum and 
          consult with qualified legal and financial advisors before participating.
        </p>
      </div>
    </div>
  );
}