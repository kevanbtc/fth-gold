import React from "react";
import Link from "next/link";

/**
 * FTH Web3 Header
 * - Responsive header with wallet connection and system status
 * - Integrates with FTH Gold smart contracts for real-time status
 * - SIWE (Sign-In With Ethereum) authentication
 */

export type HeaderProps = {
  appName?: string;
  logo?: React.ReactNode;
  walletAddress?: string;
  isConnected?: boolean;
  porStatus?: {
    healthy: boolean;
    coverageRatio: number;
    lastUpdate: number;
  };
  onConnectWallet?: () => void;
  onDisconnectWallet?: () => void;
  onSign?: () => void;
  isAuthenticated?: boolean;
};

const Header: React.FC<HeaderProps> = ({
  appName = "FTH Exchange",
  logo,
  walletAddress,
  isConnected = false,
  porStatus,
  onConnectWallet,
  onDisconnectWallet,
  onSign,
  isAuthenticated = false,
}) => {
  const [mobileMenuOpen, setMobileMenuOpen] = React.useState(false);

  const formatAddress = (address: string) => {
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  const formatCoverageRatio = (ratio: number) => {
    return `${(ratio / 100).toFixed(1)}%`;
  };

  return (
    <header className="border-b bg-white/80 dark:bg-neutral-950/80 backdrop-blur supports-[backdrop-filter]:bg-white/60 dark:supports-[backdrop-filter]:bg-neutral-950/60 sticky top-0 z-40">
      <div className="mx-auto w-full max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex h-16 items-center justify-between">
          {/* Logo and brand */}
          <div className="flex items-center gap-3">
            <Link href="/" className="flex items-center gap-3">
              {logo || (
                <div className="h-8 w-8 rounded-xl bg-gradient-to-br from-yellow-300 via-amber-400 to-orange-500 shadow-sm"/>
              )}
              <span className="text-xl font-semibold tracking-tight">{appName}</span>
            </Link>
            
            {/* System status indicator */}
            {porStatus && (
              <div className="ml-4 hidden md:flex items-center gap-2">
                <StatusDot 
                  healthy={porStatus.healthy} 
                  title={`PoR Coverage: ${formatCoverageRatio(porStatus.coverageRatio)}`}
                />
                <span className="text-xs text-neutral-500 dark:text-neutral-400">
                  PoR: {formatCoverageRatio(porStatus.coverageRatio)}
                </span>
              </div>
            )}
          </div>

          {/* Navigation */}
          <nav className="hidden md:flex items-center gap-6">
            <Link href="/dashboard" className="text-sm font-medium text-neutral-700 hover:text-neutral-900 dark:text-neutral-300 dark:hover:text-white">
              Dashboard
            </Link>
            <Link href="/stake" className="text-sm font-medium text-neutral-700 hover:text-neutral-900 dark:text-neutral-300 dark:hover:text-white">
              Stake
            </Link>
            <Link href="/portfolio" className="text-sm font-medium text-neutral-700 hover:text-neutral-900 dark:text-neutral-300 dark:hover:text-white">
              Portfolio
            </Link>
            <Link href="/docs" className="text-sm font-medium text-neutral-700 hover:text-neutral-900 dark:text-neutral-300 dark:hover:text-white">
              Docs
            </Link>
          </nav>

          {/* Wallet connection */}
          <div className="flex items-center gap-3">
            {!isConnected ? (
              <button
                onClick={onConnectWallet}
                className="rounded-xl bg-neutral-900 px-4 py-2 text-sm font-medium text-white hover:bg-black dark:bg-white dark:text-black dark:hover:bg-neutral-200"
              >
                Connect Wallet
              </button>
            ) : !isAuthenticated ? (
              <div className="flex items-center gap-2">
                <span className="text-sm text-neutral-600 dark:text-neutral-400">
                  {formatAddress(walletAddress || "")}
                </span>
                <button
                  onClick={onSign}
                  className="rounded-xl bg-blue-600 px-3 py-2 text-sm font-medium text-white hover:bg-blue-700"
                >
                  Sign In
                </button>
              </div>
            ) : (
              <WalletMenu 
                address={walletAddress || ""} 
                onDisconnect={onDisconnectWallet}
              />
            )}

            {/* Mobile menu button */}
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="md:hidden rounded-xl p-2 text-neutral-500 hover:text-neutral-900 dark:text-neutral-400 dark:hover:text-white"
              aria-label="Toggle menu"
            >
              <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
              </svg>
            </button>
          </div>
        </div>

        {/* Mobile menu */}
        {mobileMenuOpen && (
          <div className="border-t py-4 md:hidden">
            <nav className="flex flex-col gap-4">
              <Link href="/dashboard" className="text-sm font-medium text-neutral-700 hover:text-neutral-900 dark:text-neutral-300 dark:hover:text-white">
                Dashboard
              </Link>
              <Link href="/stake" className="text-sm font-medium text-neutral-700 hover:text-neutral-900 dark:text-neutral-300 dark:hover:text-white">
                Stake
              </Link>
              <Link href="/portfolio" className="text-sm font-medium text-neutral-700 hover:text-neutral-900 dark:text-neutral-300 dark:hover:text-white">
                Portfolio
              </Link>
              <Link href="/docs" className="text-sm font-medium text-neutral-700 hover:text-neutral-900 dark:text-neutral-300 dark:hover:text-white">
                Docs
              </Link>
              
              {porStatus && (
                <div className="flex items-center gap-2 pt-2 border-t">
                  <StatusDot healthy={porStatus.healthy} />
                  <span className="text-xs text-neutral-500 dark:text-neutral-400">
                    PoR Coverage: {formatCoverageRatio(porStatus.coverageRatio)}
                  </span>
                </div>
              )}
            </nav>
          </div>
        )}
      </div>
    </header>
  );
};

export default Header;

/* --------------------------------- Components -------------------------------- */

const StatusDot: React.FC<{ healthy: boolean; title?: string }> = ({ healthy, title }) => (
  <div
    className={`h-2 w-2 rounded-full ${
      healthy ? "bg-emerald-500" : "bg-red-500"
    }`}
    title={title}
  />
);

const WalletMenu: React.FC<{ address: string; onDisconnect?: () => void }> = ({ 
  address, 
  onDisconnect 
}) => {
  const [menuOpen, setMenuOpen] = React.useState(false);
  const menuRef = React.useRef<HTMLDivElement>(null);

  // Close menu when clicking outside
  React.useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setMenuOpen(false);
      }
    };

    if (menuOpen) {
      document.addEventListener('mousedown', handleClickOutside);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [menuOpen]);

  const formatAddress = (addr: string) => {
    return `${addr.slice(0, 6)}...${addr.slice(-4)}`;
  };

  return (
    <div className="relative" ref={menuRef}>
      <button
        onClick={() => setMenuOpen(!menuOpen)}
        className="flex items-center gap-2 rounded-xl border border-neutral-200 bg-white px-3 py-2 text-sm hover:bg-neutral-50 dark:border-neutral-800 dark:bg-neutral-900 dark:hover:bg-neutral-800"
      >
        <div className="h-2 w-2 rounded-full bg-emerald-500" />
        <span className="font-mono">{formatAddress(address)}</span>
        <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
        </svg>
      </button>

      {menuOpen && (
        <div className="absolute right-0 top-full mt-1 w-48 rounded-xl border border-neutral-200 bg-white shadow-lg dark:border-neutral-800 dark:bg-neutral-900">
          <div className="p-4">
            <div className="mb-2 text-xs text-neutral-500 dark:text-neutral-400">Connected</div>
            <div className="mb-4 font-mono text-sm">{formatAddress(address)}</div>
            
            <div className="space-y-2">
              <Link
                href="/profile"
                className="flex w-full items-center rounded-lg px-3 py-2 text-sm hover:bg-neutral-100 dark:hover:bg-neutral-800"
                onClick={() => setMenuOpen(false)}
              >
                Profile
              </Link>
              
              <button
                onClick={() => {
                  navigator.clipboard.writeText(address);
                  setMenuOpen(false);
                }}
                className="flex w-full items-center rounded-lg px-3 py-2 text-sm hover:bg-neutral-100 dark:hover:bg-neutral-800"
              >
                Copy Address
              </button>
              
              <button
                onClick={() => {
                  onDisconnect?.();
                  setMenuOpen(false);
                }}
                className="flex w-full items-center rounded-lg px-3 py-2 text-sm text-red-600 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-900/20"
              >
                Disconnect
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};