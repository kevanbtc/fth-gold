import React from "react";
import Link from "next/link";

/**
 * FTH Web3 Footer
 * - Responsive, accessible footer for a private Web3 app
 * - Tailwind-based design, shadcn/ui compatible (no hard dependency)
 * - Includes: Terms, Privacy, Security, Status, GitHub Community, Docs, Contact, Manage Cookies, "Do Not Sell/Share My Info"
 * - Optional on-chain/PoR badges + network/wallet state (pass via props)
 *
 * Usage (Next.js App Router):
 *   import Footer from "@/components/Footer";
 *   export default function RootLayout({ children }) {
 *     return (
 *       <html lang="en">
 *         <body className="min-h-screen flex flex-col">
 *           <main className="flex-1">{children}</main>
 *           <Footer />
 *         </body>
 *       </html>
 *     );
 *   }
 */

export type FooterProps = {
  appName?: string;
  year?: number;
  links?: {
    terms: string;
    privacy: string;
    security: string;
    status: string;
    githubCommunity: string;
    docs: string;
    contact: string;
    manageCookies?: string; // optional route for a full cookie preferences page
    doNotSell?: string; // CCPA/CPRA link
  };
  badges?: {
    porHealthy?: boolean; // Proof-of-Reserves status
    chainName?: string; // e.g., "Polygon Amoy"
    walletConnected?: boolean;
  };
};

const Footer: React.FC<FooterProps> = ({
  appName = "FTH Exchange",
  year = new Date().getFullYear(),
  links = {
    terms: "/legal/terms",
    privacy: "/legal/privacy",
    security: "/security",
    status: "https://status.example.com",
    githubCommunity: "https://github.com/kevanbtc/fth-gold",
    docs: "/docs",
    contact: "/contact",
    manageCookies: "/privacy/cookies",
    doNotSell: "/privacy/do-not-sell",
  },
  badges = {
    porHealthy: true,
    chainName: "Polygon",
    walletConnected: false,
  },
}) => {
  return (
    <footer className="border-t bg-white/60 dark:bg-neutral-950/60 backdrop-blur supports-[backdrop-filter]:bg-white/50 dark:supports-[backdrop-filter]:bg-neutral-950/50">
      <div className="mx-auto w-full max-w-7xl px-4 sm:px-6 lg:px-8">
        {/* Top: brand + quick status */}
        <div className="flex flex-col gap-4 py-8 md:flex-row md:items-center md:justify-between">
          <div className="flex items-center gap-3">
            <div className="h-9 w-9 rounded-2xl bg-gradient-to-br from-yellow-300 via-amber-400 to-orange-500 shadow-md"/>
            <div className="flex flex-col">
              <span className="text-lg font-semibold tracking-tight">{appName}</span>
              <span className="text-xs text-neutral-500 dark:text-neutral-400">Private placement • Gold-backed • DMCC anchored</span>
            </div>
          </div>

          {/* Status pills */}
          <div className="flex flex-wrap items-center gap-2">
            <StatusPill
              label="PoR"
              ok={!!badges.porHealthy}
              okText="Verified"
              badText="Degraded"
              title="Chainlink Proof-of-Reserves"
            />
            <StatusPill
              label={badges.chainName || "Network"}
              ok={true}
              okText="Online"
              badText="Down"
              title="Network health"
            />
            <StatusPill
              label={badges.walletConnected ? "Wallet" : "Guest"}
              ok={!!badges.walletConnected}
              okText="Connected"
              badText="Not Connected"
              title="Wallet connection status"
            />
          </div>
        </div>

        {/* Middle: navigation */}
        <nav aria-label="Footer" className="grid gap-2 py-2 text-sm sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
          <FooterLink href={links.terms}>Terms</FooterLink>
          <FooterLink href={links.privacy}>Privacy</FooterLink>
          <FooterLink href={links.security}>Security</FooterLink>
          <FooterLink href={links.status}>Status</FooterLink>
          <FooterLink href={links.githubCommunity}>GitHub Community</FooterLink>
          <FooterLink href={links.docs}>Docs</FooterLink>
          <FooterLink href={links.contact}>Contact</FooterLink>
          {links.manageCookies ? (
            <CookieManagerLink href={links.manageCookies} />
          ) : (
            <CookieManagerButton />
          )}
          <FooterLink href={links.doNotSell || "/privacy/do-not-sell"}>Do not sell/share my personal information</FooterLink>
        </nav>

        {/* Bottom: fine print */}
        <div className="flex flex-col gap-2 py-6 text-xs text-neutral-500 dark:text-neutral-400 md:flex-row md:items-center md:justify-between">
          <p>
            © {year} {appName}. All rights reserved. Tokens offered via private invitation to qualified
            participants only. Not available to retail investors. Read the Private Placement Memorandum.
          </p>
          <p className="flex items-center gap-2">
            <span>DMCC • VARA • Reg D/S • MiCA • FINMA (private)</span>
          </p>
        </div>
      </div>

      {/* Cookie banner (controlled internally) */}
      <CookieBanner />
    </footer>
  );
};

export default Footer;

/* --------------------------------- Helpers -------------------------------- */

const FooterLink: React.FC<{ href: string; children: React.ReactNode }> = ({ href, children }) => (
  href.startsWith("http") ? (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      className="rounded-xl px-2 py-1 text-neutral-700 hover:text-neutral-900 hover:underline dark:text-neutral-300 dark:hover:text-white"
    >
      {children}
    </a>
  ) : (
    <Link
      href={href}
      className="rounded-xl px-2 py-1 text-neutral-700 hover:text-neutral-900 hover:underline dark:text-neutral-300 dark:hover:text-white"
    >
      {children}
    </Link>
  )
);

const StatusPill: React.FC<{ label: string; ok: boolean; okText: string; badText: string; title?: string }>
= ({ label, ok, okText, badText, title }) => (
  <div
    className={`inline-flex items-center gap-1 rounded-full border px-2 py-1 text-xs ${
      ok ? "border-emerald-300 bg-emerald-50 text-emerald-700 dark:border-emerald-800/60 dark:bg-emerald-900/20 dark:text-emerald-300" :
           "border-rose-300 bg-rose-50 text-rose-700 dark:border-rose-800/60 dark:bg-rose-900/20 dark:text-rose-300"
    }`}
    title={title}
    role="status"
    aria-live="polite"
  >
    <span className="font-medium">{label}:</span>
    <span>{ok ? okText : badText}</span>
  </div>
);

/* -------------------------- Cookie management UI -------------------------- */

const CookieBanner: React.FC = () => {
  const [open, setOpen] = React.useState(false);
  const [visible, setVisible] = React.useState(() => {
    if (typeof window === "undefined") return false;
    return !localStorage.getItem("fth_cookie_choice");
  });

  const acceptAll = () => {
    localStorage.setItem("fth_cookie_choice", JSON.stringify({ essential: true, analytics: true, marketing: true }));
    setVisible(false);
  };
  const rejectAll = () => {
    localStorage.setItem("fth_cookie_choice", JSON.stringify({ essential: true, analytics: false, marketing: false }));
    setVisible(false);
  };

  if (!visible) return null;
  return (
    <div className="fixed inset-x-0 bottom-0 z-50 mx-auto w-full max-w-5xl rounded-t-2xl border bg-white p-4 shadow-2xl dark:border-neutral-800 dark:bg-neutral-900">
      <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
        <p className="text-sm text-neutral-700 dark:text-neutral-300">
          We use cookies to operate this private application, analyze usage, and enhance security. You can manage
          preferences.
        </p>
        <div className="flex items-center gap-2">
          <button onClick={() => setOpen(true)} className="rounded-xl border px-3 py-2 text-sm hover:bg-neutral-50 dark:hover:bg-neutral-800">Preferences</button>
          <button onClick={rejectAll} className="rounded-xl border px-3 py-2 text-sm hover:bg-neutral-50 dark:hover:bg-neutral-800">Reject non‑essential</button>
          <button onClick={acceptAll} className="rounded-xl bg-neutral-900 px-3 py-2 text-sm text-white hover:bg-black dark:bg-white dark:text-black dark:hover:bg-neutral-200">Accept all</button>
        </div>
      </div>
      {open && <CookieModal onClose={() => setOpen(false)} />}
    </div>
  );
};

const CookieManagerButton: React.FC = () => {
  return (
    <button
      onClick={() => {
        if (typeof window !== "undefined") {
          localStorage.removeItem("fth_cookie_choice");
          window.dispatchEvent(new Event("storage"));
          window.scrollTo({ top: document.body.scrollHeight, behavior: "smooth" });
        }
      }}
      className="rounded-xl px-2 py-1 text-neutral-700 hover:text-neutral-900 hover:underline dark:text-neutral-300 dark:hover:text-white"
    >
      Manage cookies
    </button>
  );
};

const CookieManagerLink: React.FC<{ href: string }> = ({ href }) => (
  <Link
    href={href}
    className="rounded-xl px-2 py-1 text-neutral-700 hover:text-neutral-900 hover:underline dark:text-neutral-300 dark:hover:text-white"
  >
    Manage cookies
  </Link>
);

const CookieModal: React.FC<{ onClose: () => void }> = ({ onClose }) => {
  const [prefs, setPrefs] = React.useState<{ essential: boolean; analytics: boolean; marketing: boolean }>(() => {
    if (typeof window === "undefined") return { essential: true, analytics: false, marketing: false };
    try {
      return JSON.parse(localStorage.getItem("fth_cookie_choice") || "");
    } catch {
      return { essential: true, analytics: false, marketing: false };
    }
  });

  const save = () => {
    localStorage.setItem("fth_cookie_choice", JSON.stringify(prefs));
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-black/40 p-4">
      <div className="w-full max-w-lg rounded-2xl border bg-white p-4 shadow-xl dark:border-neutral-800 dark:bg-neutral-900">
        <div className="mb-2 flex items-center justify-between">
          <h3 className="text-base font-semibold">Cookie preferences</h3>
          <button onClick={onClose} className="rounded-full p-2 hover:bg-neutral-100 dark:hover:bg-neutral-800" aria-label="Close">✕</button>
        </div>
        <div className="space-y-3 text-sm">
          <label className="flex items-start gap-3">
            <input type="checkbox" checked={true} disabled className="mt-1" />
            <span>
              <span className="font-medium">Essential</span> — required for authentication, security, and basic functionality.
            </span>
          </label>
          <label className="flex items-start gap-3">
            <input type="checkbox" checked={prefs.analytics} onChange={(e) => setPrefs({ ...prefs, analytics: e.target.checked })} className="mt-1" />
            <span>
              <span className="font-medium">Analytics</span> — anonymous usage metrics to improve reliability.
            </span>
          </label>
          <label className="flex items-start gap-3">
            <input type="checkbox" checked={prefs.marketing} onChange={(e) => setPrefs({ ...prefs, marketing: e.target.checked })} className="mt-1" />
            <span>
              <span className="font-medium">Marketing</span> — only for communications you opt into.
            </span>
          </label>
        </div>
        <div className="mt-4 flex items-center justify-end gap-2">
          <button onClick={onClose} className="rounded-xl border px-3 py-2 text-sm">Cancel</button>
          <button onClick={save} className="rounded-xl bg-neutral-900 px-3 py-2 text-sm text-white hover:bg-black dark:bg-white dark:text-black dark:hover:bg-neutral-200">Save preferences</button>
        </div>
      </div>
    </div>
  );
};