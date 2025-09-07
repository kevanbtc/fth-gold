import React from 'react';

export default function SecurityPolicy() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold tracking-tight">Security Policy</h1>
        <p className="mt-2 text-neutral-600 dark:text-neutral-400">
          Last updated: {new Date().toLocaleDateString()}
        </p>
      </div>

      <div className="prose prose-neutral dark:prose-invert max-w-none">
        <div className="rounded-lg border border-emerald-200 bg-emerald-50 p-4 mb-8 dark:border-emerald-800/60 dark:bg-emerald-900/20">
          <p className="text-emerald-800 dark:text-emerald-200">
            <strong>Security First:</strong> The FTH Gold system implements institutional-grade 
            security measures to protect your assets and personal information.
          </p>
        </div>

        <section className="mb-8">
          <h2>1. Platform Security Architecture</h2>
          
          <h3>1.1 Smart Contract Security</h3>
          <ul>
            <li><strong>Multi-Signature Governance:</strong> All critical operations require multiple authorized signatures</li>
            <li><strong>Timelock Controls:</strong> Administrative changes have mandatory delay periods</li>
            <li><strong>Pause Mechanisms:</strong> Emergency stops for all token operations</li>
            <li><strong>Audit Requirements:</strong> All smart contracts undergo third-party security audits</li>
            <li><strong>Formal Verification:</strong> Mathematical proofs for critical contract functions</li>
          </ul>

          <h3>1.2 Oracle Security</h3>
          <ul>
            <li><strong>Chainlink Integration:</strong> Decentralized oracle network for price feeds</li>
            <li><strong>Proof of Reserve:</strong> Real-time verification of vaulted gold holdings</li>
            <li><strong>Redundant Data Sources:</strong> Multiple independent price and vault data feeds</li>
            <li><strong>Circuit Breakers:</strong> Automatic safeguards for abnormal price movements</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>2. Custody and Asset Protection</h2>
          
          <h3>2.1 Gold Vault Security</h3>
          <ul>
            <li><strong>DMCC Licensed Vaults:</strong> Dubai Multi Commodities Centre regulated storage</li>
            <li><strong>Segregated Allocation:</strong> Client gold held separately from operational assets</li>
            <li><strong>Insurance Coverage:</strong> Comprehensive coverage for vaulted assets</li>
            <li><strong>Regular Audits:</strong> Independent verification of physical gold holdings</li>
            <li><strong>24/7 Monitoring:</strong> Continuous security surveillance and access controls</li>
          </ul>

          <h3>2.2 Digital Asset Security</h3>
          <ul>
            <li><strong>Cold Storage:</strong> Majority of funds held in offline hardware security modules</li>
            <li><strong>Multi-Signature Wallets:</strong> Required co-signatures for fund movements</li>
            <li><strong>Key Management:</strong> Distributed key storage with secure backup procedures</li>
            <li><strong>Transaction Monitoring:</strong> Real-time analysis of all blockchain transactions</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>3. Access Controls and Authentication</h2>
          
          <h3>3.1 User Authentication</h3>
          <ul>
            <li><strong>SIWE (Sign-In With Ethereum):</strong> Cryptographic wallet-based authentication</li>
            <li><strong>KYC Soulbound Tokens:</strong> Non-transferable verification credentials</li>
            <li><strong>Multi-Factor Authentication:</strong> Additional security layers for sensitive operations</li>
            <li><strong>Session Management:</strong> Secure session handling with automatic timeouts</li>
          </ul>

          <h3>3.2 Administrative Access</h3>
          <ul>
            <li><strong>Principle of Least Privilege:</strong> Minimal necessary access rights</li>
            <li><strong>Role-Based Permissions:</strong> Granular access controls by function</li>
            <li><strong>Activity Logging:</strong> Comprehensive audit trails for all administrative actions</li>
            <li><strong>Regular Access Reviews:</strong> Periodic validation of access rights</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>4. Data Protection and Privacy</h2>
          
          <h3>4.1 Encryption</h3>
          <ul>
            <li><strong>Data at Rest:</strong> AES-256 encryption for stored data</li>
            <li><strong>Data in Transit:</strong> TLS 1.3 for all communications</li>
            <li><strong>Database Encryption:</strong> Field-level encryption for sensitive data</li>
            <li><strong>Key Rotation:</strong> Regular updates to encryption keys</li>
          </ul>

          <h3>4.2 Privacy Protection</h3>
          <ul>
            <li><strong>Data Minimization:</strong> Collection limited to regulatory requirements</li>
            <li><strong>Anonymization:</strong> Non-essential data anonymized where possible</li>
            <li><strong>Secure Deletion:</strong> Cryptographic erasure of expired data</li>
            <li><strong>Privacy by Design:</strong> Built-in privacy protections</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>5. Incident Response</h2>
          
          <h3>5.1 Security Monitoring</h3>
          <ul>
            <li><strong>24/7 SOC:</strong> Security Operations Center monitoring</li>
            <li><strong>Threat Intelligence:</strong> Real-time threat detection and analysis</li>
            <li><strong>Automated Alerts:</strong> Immediate notification of suspicious activities</li>
            <li><strong>Behavioral Analysis:</strong> AI-powered anomaly detection</li>
          </ul>

          <h3>5.2 Incident Procedures</h3>
          <div className="rounded-lg border border-red-200 bg-red-50 p-4 dark:border-red-800/60 dark:bg-red-900/20">
            <p className="text-red-800 dark:text-red-200">
              <strong>Emergency Response:</strong> In case of security incidents, we have established 
              procedures for immediate containment, investigation, and recovery.
            </p>
          </div>
          
          <ul className="mt-4">
            <li><strong>Incident Classification:</strong> Rapid assessment and categorization</li>
            <li><strong>Containment:</strong> Immediate isolation of affected systems</li>
            <li><strong>Investigation:</strong> Forensic analysis by security experts</li>
            <li><strong>Communication:</strong> Timely notification to affected users and regulators</li>
            <li><strong>Recovery:</strong> Secure restoration of services</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>6. Compliance and Auditing</h2>
          
          <h3>6.1 Security Audits</h3>
          <ul>
            <li><strong>Smart Contract Audits:</strong> Third-party security reviews before deployment</li>
            <li><strong>Penetration Testing:</strong> Regular ethical hacking assessments</li>
            <li><strong>Code Reviews:</strong> Comprehensive analysis of all system changes</li>
            <li><strong>Infrastructure Audits:</strong> Cloud and network security assessments</li>
          </ul>

          <h3>6.2 Regulatory Compliance</h3>
          <ul>
            <li><strong>AML/KYC:</strong> Anti-money laundering and know-your-customer procedures</li>
            <li><strong>Data Protection:</strong> GDPR, CCPA, and UAE data protection compliance</li>
            <li><strong>Financial Regulations:</strong> Securities and commodities law adherence</li>
            <li><strong>Reporting:</strong> Regular compliance reporting to authorities</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>7. User Security Best Practices</h2>
          
          <h3>7.1 Wallet Security</h3>
          <ul>
            <li>Use hardware wallets for significant holdings</li>
            <li>Never share private keys or seed phrases</li>
            <li>Verify all transaction details before signing</li>
            <li>Keep wallet software updated</li>
          </ul>

          <h3>7.2 Account Security</h3>
          <ul>
            <li>Use strong, unique passwords</li>
            <li>Enable all available security features</li>
            <li>Regularly review account activity</li>
            <li>Report suspicious activities immediately</li>
          </ul>

          <h3>7.3 Phishing Protection</h3>
          <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 dark:border-amber-800/60 dark:bg-amber-900/20">
            <p className="text-amber-800 dark:text-amber-200">
              <strong>Stay Vigilant:</strong> Always verify website URLs and never enter credentials 
              or sign transactions from suspicious links or emails.
            </p>
          </div>
        </section>

        <section className="mb-8">
          <h2>8. Security Contact</h2>
          <p>For security-related matters:</p>
          <ul>
            <li><strong>Security Team:</strong> security@futuretechholdings.com</li>
            <li><strong>Vulnerability Reports:</strong> Use encrypted communication channels</li>
            <li><strong>Emergency Contact:</strong> Available 24/7 through authenticated portal</li>
            <li><strong>Bug Bounty:</strong> Responsible disclosure program for security researchers</li>
          </ul>
        </section>

        <div className="mt-12 rounded-lg border border-neutral-200 bg-neutral-50 p-6 dark:border-neutral-800 dark:bg-neutral-900">
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            <strong>Continuous Improvement:</strong> Our security measures are continuously updated 
            to address emerging threats and incorporate industry best practices. This policy is 
            reviewed and updated regularly.
          </p>
        </div>
      </div>
    </div>
  );
}