import React from 'react';

export default function CookiePolicy() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold tracking-tight">Cookie Preferences</h1>
        <p className="mt-2 text-neutral-600 dark:text-neutral-400">
          Manage your cookie settings for the FTH Exchange platform
        </p>
      </div>

      <div className="prose prose-neutral dark:prose-invert max-w-none">
        <div className="rounded-lg border border-blue-200 bg-blue-50 p-4 mb-8 dark:border-blue-800/60 dark:bg-blue-900/20">
          <p className="text-blue-800 dark:text-blue-200">
            <strong>Cookie Controls:</strong> You can manage your cookie preferences below. 
            Essential cookies are required for platform security and cannot be disabled.
          </p>
        </div>

        <CookieManager />

        <section className="mb-8 mt-8">
          <h2>1. How We Use Cookies</h2>
          
          <h3>1.1 Essential Cookies (Required)</h3>
          <p>
            These cookies are necessary for the platform to function securely and cannot be disabled:
          </p>
          <ul>
            <li><strong>Authentication:</strong> Maintain secure login sessions</li>
            <li><strong>Security:</strong> CSRF protection and session validation</li>
            <li><strong>Compliance:</strong> Store cookie consent preferences</li>
            <li><strong>Functionality:</strong> Remember language and display preferences</li>
          </ul>

          <h3>1.2 Analytics Cookies (Optional)</h3>
          <p>
            Help us understand how users interact with the platform (anonymized data only):
          </p>
          <ul>
            <li><strong>Usage Statistics:</strong> Page views, session duration, navigation patterns</li>
            <li><strong>Performance Monitoring:</strong> Load times, error rates, feature usage</li>
            <li><strong>Security Analytics:</strong> Threat detection and prevention</li>
          </ul>

          <h3>1.3 Marketing Cookies (Optional)</h3>
          <p>
            Used only for users who explicitly opt in to communications:
          </p>
          <ul>
            <li><strong>Campaign Attribution:</strong> Track referral sources (private placement only)</li>
            <li><strong>Communication Preferences:</strong> Personalize authorized notifications</li>
            <li><strong>Retargeting:</strong> Platform feature recommendations</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>2. Cookie Details</h2>
          
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-300 dark:divide-gray-700">
              <thead>
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Cookie Name
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Purpose
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Duration
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Type
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                <tr>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-mono">fth_session</td>
                  <td className="px-6 py-4 text-sm">Authentication session</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">24 hours</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200">
                      Essential
                    </span>
                  </td>
                </tr>
                <tr>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-mono">fth_csrf</td>
                  <td className="px-6 py-4 text-sm">CSRF protection</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">Session</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200">
                      Essential
                    </span>
                  </td>
                </tr>
                <tr>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-mono">fth_cookie_choice</td>
                  <td className="px-6 py-4 text-sm">Cookie preferences</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">1 year</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200">
                      Essential
                    </span>
                  </td>
                </tr>
                <tr>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-mono">fth_analytics</td>
                  <td className="px-6 py-4 text-sm">Usage analytics (anonymized)</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">90 days</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200">
                      Analytics
                    </span>
                  </td>
                </tr>
                <tr>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-mono">fth_marketing</td>
                  <td className="px-6 py-4 text-sm">Marketing attribution</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">30 days</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200">
                      Marketing
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section className="mb-8">
          <h2>3. Third-Party Cookies</h2>
          
          <h3>3.1 Service Providers</h3>
          <p>
            We use limited third-party services that may set cookies:
          </p>
          <ul>
            <li><strong>Chainlink:</strong> Oracle data feeds (essential for PoR)</li>
            <li><strong>Web3 Providers:</strong> Wallet connection and blockchain interaction</li>
            <li><strong>CDN Services:</strong> Content delivery and performance</li>
            <li><strong>Security Services:</strong> DDoS protection and threat detection</li>
          </ul>

          <h3>3.2 Third-Party Opt-Out</h3>
          <p>
            You can opt out of third-party tracking through:
          </p>
          <ul>
            <li><a href="https://optout.networkadvertising.org/" target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline dark:text-blue-400">Network Advertising Initiative Opt-Out</a></li>
            <li><a href="https://optout.aboutads.info/" target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline dark:text-blue-400">Digital Advertising Alliance Opt-Out</a></li>
            <li><a href="https://youronlinechoices.com/" target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline dark:text-blue-400">Your Online Choices (EU)</a></li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>4. Browser Controls</h2>
          
          <h3>4.1 Browser Settings</h3>
          <p>
            Most browsers allow you to:
          </p>
          <ul>
            <li>View and delete existing cookies</li>
            <li>Block third-party cookies</li>
            <li>Block all cookies (may break essential functionality)</li>
            <li>Clear cookies when closing the browser</li>
          </ul>

          <h3>4.2 Private Browsing</h3>
          <p>
            Using private/incognito mode will:
          </p>
          <ul>
            <li>Prevent cookies from being stored after session ends</li>
            <li>Require re-authentication for each session</li>
            <li>Reset cookie preferences to defaults</li>
          </ul>

          <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 dark:border-amber-800/60 dark:bg-amber-900/20">
            <p className="text-amber-800 dark:text-amber-200">
              <strong>Important:</strong> Disabling essential cookies will prevent platform 
              authentication and security features from working properly.
            </p>
          </div>
        </section>

        <section className="mb-8">
          <h2>5. Data Protection</h2>
          
          <h3>5.1 Cookie Security</h3>
          <ul>
            <li><strong>Secure Transmission:</strong> All cookies use secure HTTPS connections</li>
            <li><strong>HttpOnly Flags:</strong> Prevent client-side script access to sensitive cookies</li>
            <li><strong>SameSite Protection:</strong> Prevent cross-site request forgery</li>
            <li><strong>Encryption:</strong> Sensitive data in cookies is encrypted</li>
          </ul>

          <h3>5.2 Data Retention</h3>
          <p>
            Cookie data is retained only as long as necessary:
          </p>
          <ul>
            <li><strong>Session Cookies:</strong> Deleted when browser closes</li>
            <li><strong>Persistent Cookies:</strong> Automatic expiration dates set</li>
            <li><strong>Analytics Data:</strong> Anonymized and aggregated</li>
            <li><strong>Marketing Data:</strong> Deleted after campaign completion</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>6. Contact Information</h2>
          <p>For cookie-related questions:</p>
          <ul>
            <li><strong>Privacy Team:</strong> privacy@futuretechholdings.com</li>
            <li><strong>Technical Support:</strong> Available through authenticated portal</li>
            <li><strong>Data Protection Officer:</strong> dpo@futuretechholdings.com</li>
          </ul>
        </section>

        <div className="mt-12 rounded-lg border border-neutral-200 bg-neutral-50 p-6 dark:border-neutral-800 dark:bg-neutral-900">
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            <strong>Updates:</strong> This cookie policy may be updated to reflect changes in 
            our practices or applicable laws. We will notify users of significant changes 
            through the platform.
          </p>
        </div>
      </div>
    </div>
  );
}

const CookieManager: React.FC = () => {
  const [prefs, setPrefs] = React.useState<{ essential: boolean; analytics: boolean; marketing: boolean }>(() => {
    if (typeof window === 'undefined') return { essential: true, analytics: false, marketing: false };
    try {
      const stored = localStorage.getItem('fth_cookie_choice');
      return stored ? JSON.parse(stored) : { essential: true, analytics: false, marketing: false };
    } catch {
      return { essential: true, analytics: false, marketing: false };
    }
  });

  const [saved, setSaved] = React.useState(false);

  const updatePrefs = (category: 'analytics' | 'marketing', enabled: boolean) => {
    const newPrefs = { ...prefs, [category]: enabled };
    setPrefs(newPrefs);
    localStorage.setItem('fth_cookie_choice', JSON.stringify(newPrefs));
    setSaved(true);
    setTimeout(() => setSaved(false), 3000);
  };

  return (
    <div className="rounded-xl border border-neutral-200 bg-neutral-50 p-6 dark:border-neutral-800 dark:bg-neutral-900">
      <h3 className="text-lg font-semibold mb-4">Cookie Preferences</h3>
      
      <div className="space-y-4">
        <div className="flex items-center justify-between p-4 rounded-lg border border-neutral-200 dark:border-neutral-700">
          <div className="flex-1">
            <h4 className="font-medium text-neutral-900 dark:text-neutral-100">Essential Cookies</h4>
            <p className="text-sm text-neutral-600 dark:text-neutral-400 mt-1">
              Required for authentication, security, and basic functionality.
            </p>
          </div>
          <div className="ml-4">
            <input
              type="checkbox"
              checked={true}
              disabled
              className="h-4 w-4 text-neutral-400"
            />
            <span className="ml-2 text-sm text-neutral-500">Required</span>
          </div>
        </div>

        <div className="flex items-center justify-between p-4 rounded-lg border border-neutral-200 dark:border-neutral-700">
          <div className="flex-1">
            <h4 className="font-medium text-neutral-900 dark:text-neutral-100">Analytics Cookies</h4>
            <p className="text-sm text-neutral-600 dark:text-neutral-400 mt-1">
              Anonymous usage metrics to improve platform reliability.
            </p>
          </div>
          <div className="ml-4">
            <input
              type="checkbox"
              checked={prefs.analytics}
              onChange={(e) => updatePrefs('analytics', e.target.checked)}
              className="h-4 w-4 text-blue-600 focus:ring-blue-500"
            />
          </div>
        </div>

        <div className="flex items-center justify-between p-4 rounded-lg border border-neutral-200 dark:border-neutral-700">
          <div className="flex-1">
            <h4 className="font-medium text-neutral-900 dark:text-neutral-100">Marketing Cookies</h4>
            <p className="text-sm text-neutral-600 dark:text-neutral-400 mt-1">
              Only for communications you opt into (private placement updates).
            </p>
          </div>
          <div className="ml-4">
            <input
              type="checkbox"
              checked={prefs.marketing}
              onChange={(e) => updatePrefs('marketing', e.target.checked)}
              className="h-4 w-4 text-green-600 focus:ring-green-500"
            />
          </div>
        </div>
      </div>

      {saved && (
        <div className="mt-4 p-3 rounded-lg bg-emerald-100 text-emerald-800 text-sm dark:bg-emerald-900/20 dark:text-emerald-200">
          ✓ Cookie preferences saved successfully
        </div>
      )}
    </div>
  );
};