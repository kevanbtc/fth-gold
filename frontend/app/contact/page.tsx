import React from 'react';

export default function ContactPage() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold tracking-tight">Contact Information</h1>
        <p className="mt-2 text-neutral-600 dark:text-neutral-400">
          Get in touch with Future Tech Holdings for qualified investor inquiries
        </p>
      </div>

      <div className="prose prose-neutral dark:prose-invert max-w-none">
        <div className="rounded-lg border border-blue-200 bg-blue-50 p-4 mb-8 dark:border-blue-800/60 dark:bg-blue-900/20">
          <p className="text-blue-800 dark:text-blue-200">
            <strong>Private Placement Only:</strong> Communications are available exclusively to 
            qualified accredited investors participating in our private placement offering.
          </p>
        </div>

        <section className="mb-8">
          <h2>1. Primary Contact</h2>
          
          <div className="grid gap-6 md:grid-cols-2">
            <div className="rounded-xl border border-neutral-200 p-6 dark:border-neutral-800">
              <h3 className="font-semibold mb-3 flex items-center gap-2">
                <svg className="h-5 w-5 text-blue-600 dark:text-blue-400" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75" />
                </svg>
                Email Support
              </h3>
              <div className="space-y-2 text-sm">
                <p><strong>General Inquiries:</strong><br/>
                <a href="mailto:info@futuretechholdings.com" className="text-blue-600 hover:underline dark:text-blue-400">
                  info@futuretechholdings.com
                </a></p>
                
                <p><strong>Investor Relations:</strong><br/>
                <a href="mailto:investors@futuretechholdings.com" className="text-blue-600 hover:underline dark:text-blue-400">
                  investors@futuretechholdings.com
                </a></p>
                
                <p><strong>Compliance:</strong><br/>
                <a href="mailto:compliance@futuretechholdings.com" className="text-blue-600 hover:underline dark:text-blue-400">
                  compliance@futuretechholdings.com
                </a></p>
              </div>
            </div>

            <div className="rounded-xl border border-neutral-200 p-6 dark:border-neutral-800">
              <h3 className="font-semibold mb-3 flex items-center gap-2">
                <svg className="h-5 w-5 text-emerald-600 dark:text-emerald-400" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z" />
                </svg>
                Physical Address
              </h3>
              <div className="space-y-2 text-sm">
                <p>
                  <strong>Future Tech Holdings</strong><br/>
                  Dubai International Financial Centre (DIFC)<br/>
                  Level 5, Gate Village Building 3<br/>
                  DIFC, Dubai, UAE
                </p>
                
                <p className="text-neutral-600 dark:text-neutral-400">
                  <strong>Postal Code:</strong> 506724<br/>
                  <strong>Hours:</strong> Sunday - Thursday, 9:00 AM - 6:00 PM GST
                </p>
              </div>
            </div>
          </div>
        </section>

        <section className="mb-8">
          <h2>2. Specialized Support</h2>
          
          <div className="grid gap-4 md:grid-cols-3">
            <div className="rounded-lg border border-neutral-200 p-4 dark:border-neutral-800">
              <h3 className="font-medium text-amber-600 dark:text-amber-400 mb-2">Technical Support</h3>
              <p className="text-sm text-neutral-600 dark:text-neutral-400 mb-2">
                Platform access, wallet connection, smart contract interactions
              </p>
              <p className="text-sm">
                <a href="mailto:support@futuretechholdings.com" className="text-blue-600 hover:underline dark:text-blue-400">
                  support@futuretechholdings.com
                </a>
              </p>
            </div>

            <div className="rounded-lg border border-neutral-200 p-4 dark:border-neutral-800">
              <h3 className="font-medium text-red-600 dark:text-red-400 mb-2">Security Issues</h3>
              <p className="text-sm text-neutral-600 dark:text-neutral-400 mb-2">
                Security incidents, suspicious activity, vulnerability reports
              </p>
              <p className="text-sm">
                <a href="mailto:security@futuretechholdings.com" className="text-blue-600 hover:underline dark:text-blue-400">
                  security@futuretechholdings.com
                </a>
              </p>
            </div>

            <div className="rounded-lg border border-neutral-200 p-4 dark:border-neutral-800">
              <h3 className="font-medium text-purple-600 dark:text-purple-400 mb-2">Privacy Matters</h3>
              <p className="text-sm text-neutral-600 dark:text-neutral-400 mb-2">
                Data protection rights, privacy policy questions
              </p>
              <p className="text-sm">
                <a href="mailto:privacy@futuretechholdings.com" className="text-blue-600 hover:underline dark:text-blue-400">
                  privacy@futuretechholdings.com
                </a>
              </p>
            </div>
          </div>
        </section>

        <section className="mb-8">
          <h2>3. Regulatory and Legal</h2>
          
          <div className="rounded-xl border border-neutral-200 p-6 dark:border-neutral-800">
            <h3 className="font-semibold mb-3">Regulatory Information</h3>
            <div className="grid gap-4 md:grid-cols-2">
              <div>
                <p className="text-sm">
                  <strong>Dubai Financial Services Authority (DFSA):</strong><br/>
                  Licensed for providing financial services in the DIFC
                </p>
              </div>
              <div>
                <p className="text-sm">
                  <strong>Virtual Assets Regulatory Authority (VARA):</strong><br/>
                  Registered for virtual asset activities in Dubai
                </p>
              </div>
              <div>
                <p className="text-sm">
                  <strong>US Securities Compliance:</strong><br/>
                  Private placement under Regulation D/S exemptions
                </p>
              </div>
              <div>
                <p className="text-sm">
                  <strong>EU MiCA Compliance:</strong><br/>
                  Market in Crypto-Assets regulatory framework
                </p>
              </div>
            </div>
          </div>
        </section>

        <section className="mb-8">
          <h2>4. Platform Access</h2>
          
          <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 dark:border-amber-800/60 dark:bg-amber-900/20">
            <h3 className="font-medium text-amber-800 dark:text-amber-200 mb-2">Authenticated Portal</h3>
            <p className="text-sm text-amber-700 dark:text-amber-300">
              For existing participants with verified KYC status:
            </p>
            <ul className="text-sm text-amber-700 dark:text-amber-300 mt-2 space-y-1">
              <li>• Direct support chat available after wallet connection</li>
              <li>• Account-specific assistance and documentation</li>
              <li>• Real-time transaction support and guidance</li>
              <li>• Priority response times for verified users</li>
            </ul>
          </div>
        </section>

        <section className="mb-8">
          <h2>5. Response Times</h2>
          
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-300 dark:divide-gray-700">
              <thead>
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Inquiry Type
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    Business Hours Response
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-400">
                    After Hours Response
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 dark:divide-gray-700 text-sm">
                <tr>
                  <td className="px-6 py-4 font-medium">Security Incidents</td>
                  <td className="px-6 py-4">Within 1 hour</td>
                  <td className="px-6 py-4">Within 2 hours</td>
                </tr>
                <tr>
                  <td className="px-6 py-4 font-medium">Technical Support</td>
                  <td className="px-6 py-4">Within 4 hours</td>
                  <td className="px-6 py-4">Next business day</td>
                </tr>
                <tr>
                  <td className="px-6 py-4 font-medium">Compliance Matters</td>
                  <td className="px-6 py-4">Within 24 hours</td>
                  <td className="px-6 py-4">Within 48 hours</td>
                </tr>
                <tr>
                  <td className="px-6 py-4 font-medium">General Inquiries</td>
                  <td className="px-6 py-4">Within 24 hours</td>
                  <td className="px-6 py-4">Within 72 hours</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section className="mb-8">
          <h2>6. Important Notes</h2>
          
          <div className="space-y-4">
            <div className="rounded-lg border border-red-200 bg-red-50 p-4 dark:border-red-800/60 dark:bg-red-900/20">
              <p className="text-red-800 dark:text-red-200 text-sm">
                <strong>Qualified Investors Only:</strong> Our services are available exclusively to 
                accredited investors who have completed KYC verification. We cannot provide 
                investment advice to retail investors.
              </p>
            </div>
            
            <div className="rounded-lg border border-blue-200 bg-blue-50 p-4 dark:border-blue-800/60 dark:bg-blue-900/20">
              <p className="text-blue-800 dark:text-blue-200 text-sm">
                <strong>Encrypted Communications:</strong> For sensitive matters, we recommend using 
                our authenticated platform portal or requesting encrypted email communication channels.
              </p>
            </div>
            
            <div className="rounded-lg border border-emerald-200 bg-emerald-50 p-4 dark:border-emerald-800/60 dark:bg-emerald-900/20">
              <p className="text-emerald-800 dark:text-emerald-200 text-sm">
                <strong>Multi-Language Support:</strong> Communications are available in English and Arabic. 
                Additional language support may be available for qualified participants upon request.
              </p>
            </div>
          </div>
        </section>

        <div className="mt-12 rounded-lg border border-neutral-200 bg-neutral-50 p-6 dark:border-neutral-800 dark:bg-neutral-900">
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            <strong>Business Hours:</strong> Sunday through Thursday, 9:00 AM to 6:00 PM Gulf Standard Time (GST). 
            Emergency security matters are monitored 24/7. All communications are subject to regulatory 
            compliance requirements and may be recorded for quality assurance purposes.
          </p>
        </div>
      </div>
    </div>
  );
}