import React from 'react';

export default function PrivacyPolicy() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold tracking-tight">Privacy Policy</h1>
        <p className="mt-2 text-neutral-600 dark:text-neutral-400">
          Last updated: {new Date().toLocaleDateString()}
        </p>
      </div>

      <div className="prose prose-neutral dark:prose-invert max-w-none">
        <section className="mb-8">
          <h2>1. Information Collection</h2>
          
          <h3>1.1 Personal Information</h3>
          <p>
            As part of our private placement offering, we collect personal information required 
            for KYC/AML compliance:
          </p>
          <ul>
            <li>Identity verification documents (passport, ID, proof of address)</li>
            <li>Financial suitability documentation (accredited investor status)</li>
            <li>Blockchain wallet addresses and transaction history</li>
            <li>Contact information (email, phone, physical address)</li>
            <li>Source of funds documentation and beneficial ownership</li>
          </ul>

          <h3>1.2 Technical Data</h3>
          <ul>
            <li>Wallet connection data and transaction signatures</li>
            <li>Platform usage analytics and security logs</li>
            <li>Device information and IP addresses</li>
            <li>Cookies and session data for authenticated sessions</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>2. Information Use</h2>
          
          <div className="rounded-lg border border-blue-200 bg-blue-50 p-4 dark:border-blue-800/60 dark:bg-blue-900/20">
            <p className="text-blue-800 dark:text-blue-200">
              <strong>Private Placement Purpose:</strong> Information is collected and used solely 
              for compliance with securities regulations and platform operations.
            </p>
          </div>
          
          <h3 className="mt-4">2.1 Permitted Uses</h3>
          <ul>
            <li><strong>Regulatory Compliance:</strong> KYC/AML verification, sanctions screening, tax reporting</li>
            <li><strong>Platform Operations:</strong> Account management, transaction processing, customer support</li>
            <li><strong>Security:</strong> Fraud prevention, risk management, audit trail maintenance</li>
            <li><strong>Legal Obligations:</strong> Regulatory reporting, law enforcement cooperation</li>
          </ul>

          <h3>2.2 Prohibited Uses</h3>
          <p>We do not use personal information for:</p>
          <ul>
            <li>Public marketing or advertising campaigns</li>
            <li>Sale or transfer to third-party marketers</li>
            <li>Analytics beyond operational necessity</li>
            <li>Social media profiling or behavioral targeting</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>3. Information Sharing</h2>
          
          <h3>3.1 Regulatory Authorities</h3>
          <p>
            We may share information with regulatory bodies as required by law:
          </p>
          <ul>
            <li>Dubai International Financial Centre (DIFC) and VARA</li>
            <li>US Securities and Exchange Commission (SEC) and CFTC</li>
            <li>European Securities and Markets Authority (ESMA)</li>
            <li>Swiss Financial Market Supervisory Authority (FINMA)</li>
            <li>Financial intelligence units for AML compliance</li>
          </ul>

          <h3>3.2 Service Providers</h3>
          <p>Limited sharing with vetted service providers:</p>
          <ul>
            <li><strong>KYC Providers:</strong> Identity verification and sanctions screening</li>
            <li><strong>Custodial Partners:</strong> Vault operators for gold storage verification</li>
            <li><strong>Technology Providers:</strong> Blockchain infrastructure and security services</li>
            <li><strong>Legal/Compliance:</strong> External counsel and compliance consultants</li>
          </ul>

          <h3>3.3 No Sale of Data</h3>
          <p>
            Future Tech Holdings does not sell, rent, or trade personal information 
            for commercial purposes.
          </p>
        </section>

        <section className="mb-8">
          <h2>4. Data Protection</h2>
          
          <h3>4.1 Security Measures</h3>
          <ul>
            <li>End-to-end encryption for sensitive data transmission</li>
            <li>Multi-signature wallet security and hardware security modules</li>
            <li>Regular security audits and penetration testing</li>
            <li>Access controls with principle of least privilege</li>
            <li>Encrypted data storage with regular backup procedures</li>
          </ul>

          <h3>4.2 Data Retention</h3>
          <p>
            Personal information is retained in accordance with regulatory requirements:
          </p>
          <ul>
            <li><strong>KYC Records:</strong> 7 years after account closure</li>
            <li><strong>Transaction Records:</strong> 7 years from transaction date</li>
            <li><strong>Communications:</strong> 3 years from last contact</li>
            <li><strong>Technical Logs:</strong> 1 year unless required for investigation</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>5. Your Rights</h2>
          
          <h3>5.1 Access and Portability</h3>
          <p>You have the right to:</p>
          <ul>
            <li>Request copies of personal information we hold</li>
            <li>Receive data in a structured, machine-readable format</li>
            <li>Transfer data to another service provider where technically feasible</li>
          </ul>

          <h3>5.2 Correction and Updates</h3>
          <p>You may:</p>
          <ul>
            <li>Update contact and preference information through your account</li>
            <li>Request correction of inaccurate personal information</li>
            <li>Submit updated KYC documentation when required</li>
          </ul>

          <h3>5.3 Limitations</h3>
          <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 dark:border-amber-800/60 dark:bg-amber-900/20">
            <p className="text-amber-800 dark:text-amber-200">
              <strong>Regulatory Requirements:</strong> Some data must be retained for compliance 
              purposes and cannot be deleted during required retention periods.
            </p>
          </div>
        </section>

        <section className="mb-8">
          <h2>6. Cookies and Tracking</h2>
          
          <h3>6.1 Cookie Types</h3>
          <ul>
            <li><strong>Essential:</strong> Required for authentication and security</li>
            <li><strong>Functional:</strong> Remember preferences and settings</li>
            <li><strong>Analytics:</strong> Anonymous usage statistics (opt-in)</li>
          </ul>

          <h3>6.2 Cookie Management</h3>
          <p>
            You can manage cookie preferences through the footer settings or browser controls. 
            Essential cookies cannot be disabled as they are required for platform security.
          </p>
        </section>

        <section className="mb-8">
          <h2>7. International Transfers</h2>
          <p>
            Personal information may be transferred internationally for processing in jurisdictions 
            where we operate, including:
          </p>
          <ul>
            <li>United Arab Emirates (DIFC) - primary operations</li>
            <li>United States - regulatory compliance and technology services</li>
            <li>European Union - compliance monitoring</li>
            <li>Switzerland - banking and custody services</li>
          </ul>
          
          <p>
            All transfers comply with applicable data protection regulations and include 
            appropriate safeguards.
          </p>
        </section>

        <section className="mb-8">
          <h2>8. Contact Information</h2>
          <p>For privacy-related inquiries:</p>
          <ul>
            <li><strong>Privacy Officer:</strong> privacy@futuretechholdings.com</li>
            <li><strong>Data Protection:</strong> Available through authenticated user portal</li>
            <li><strong>Regulatory Inquiries:</strong> compliance@futuretechholdings.com</li>
          </ul>
        </section>

        <div className="mt-12 rounded-lg border border-neutral-200 bg-neutral-50 p-6 dark:border-neutral-800 dark:bg-neutral-900">
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            <strong>Important:</strong> This privacy policy applies to the FTH Exchange platform 
            and FTH-G token private placement. For complete data processing details, refer to 
            the Data Processing Addendum in your investor documentation.
          </p>
        </div>
      </div>
    </div>
  );
}