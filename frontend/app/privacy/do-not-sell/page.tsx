import React from 'react';

export default function DoNotSell() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold tracking-tight">Do Not Sell or Share My Personal Information</h1>
        <p className="mt-2 text-neutral-600 dark:text-neutral-400">
          California Consumer Privacy Rights (CCPA/CPRA)
        </p>
      </div>

      <div className="prose prose-neutral dark:prose-invert max-w-none">
        <div className="rounded-lg border border-blue-200 bg-blue-50 p-4 mb-8 dark:border-blue-800/60 dark:bg-blue-900/20">
          <p className="text-blue-800 dark:text-blue-200">
            <strong>Your Privacy Rights:</strong> As a California resident, you have specific rights 
            regarding the sale and sharing of your personal information under the California Consumer Privacy Act (CCPA).
          </p>
        </div>

        <section className="mb-8">
          <h2>1. FTH Holdings' Data Practices</h2>
          
          <h3>1.1 We Do Not Sell Personal Information</h3>
          <p>
            Future Tech Holdings does <strong>NOT</strong> sell personal information to third parties 
            for monetary consideration. This includes:
          </p>
          <ul>
            <li>Identity and KYC verification data</li>
            <li>Financial information and transaction history</li>
            <li>Contact information and communications</li>
            <li>Wallet addresses and blockchain activity</li>
            <li>Usage analytics and behavioral data</li>
          </ul>

          <h3>1.2 Limited Sharing for Business Operations</h3>
          <p>
            We share personal information only as necessary for:
          </p>
          <ul>
            <li><strong>Regulatory Compliance:</strong> KYC/AML verification, tax reporting, regulatory filings</li>
            <li><strong>Service Providers:</strong> Technology infrastructure, vault operations, compliance services</li>
            <li><strong>Legal Requirements:</strong> Court orders, law enforcement requests, regulatory investigations</li>
            <li><strong>Business Operations:</strong> Customer support, security monitoring, fraud prevention</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>2. Your California Privacy Rights</h2>
          
          <h3>2.1 Right to Know</h3>
          <p>You have the right to request information about:</p>
          <ul>
            <li>Categories of personal information collected</li>
            <li>Sources of personal information</li>
            <li>Business purposes for collection and sharing</li>
            <li>Categories of third parties who receive information</li>
            <li>Specific pieces of personal information collected</li>
          </ul>

          <h3>2.2 Right to Delete</h3>
          <p>
            You may request deletion of personal information, subject to regulatory retention requirements 
            for financial services and securities compliance.
          </p>

          <h3>2.3 Right to Correct</h3>
          <p>
            You can request correction of inaccurate personal information through your account settings 
            or by contacting our privacy team.
          </p>

          <h3>2.4 Right to Opt-Out</h3>
          <div className="rounded-lg border border-emerald-200 bg-emerald-50 p-4 dark:border-emerald-800/60 dark:bg-emerald-900/20">
            <p className="text-emerald-800 dark:text-emerald-200">
              <strong>Already Protected:</strong> Since we don't sell personal information, 
              no opt-out action is required. This right is automatically respected.
            </p>
          </div>
        </section>

        <section className="mb-8">
          <h2>3. Sensitive Personal Information</h2>
          
          <h3>3.1 Collection and Use</h3>
          <p>
            We collect sensitive personal information for regulatory compliance:
          </p>
          <ul>
            <li><strong>Government IDs:</strong> For identity verification (KYC)</li>
            <li><strong>Financial Information:</strong> For accredited investor verification</li>
            <li><strong>Biometric Data:</strong> For enhanced security verification (optional)</li>
          </ul>

          <h3>3.2 Limited Use</h3>
          <p>
            Sensitive information is used only for:
          </p>
          <ul>
            <li>Regulatory compliance and reporting</li>
            <li>Account security and fraud prevention</li>
            <li>Customer service and support</li>
            <li>Legal obligations and law enforcement</li>
          </ul>

          <h3>3.3 Right to Limit Use</h3>
          <p>
            You may request to limit the use of sensitive personal information, though this may 
            affect your ability to participate in our private placement offerings due to regulatory requirements.
          </p>
        </section>

        <section className="mb-8">
          <h2>4. How to Exercise Your Rights</h2>
          
          <h3>4.1 Submit a Request</h3>
          <p>To exercise your privacy rights, contact us through:</p>
          <ul>
            <li><strong>Email:</strong> privacy@futuretechholdings.com</li>
            <li><strong>Authenticated Portal:</strong> Privacy settings in your account dashboard</li>
            <li><strong>Phone:</strong> Available through verified account contact</li>
          </ul>

          <h3>4.2 Verification Process</h3>
          <p>
            To protect your privacy, we will verify your identity before processing requests:
          </p>
          <ul>
            <li>Account holder verification through existing authentication</li>
            <li>Additional identity verification for sensitive requests</li>
            <li>Authorized representative verification if applicable</li>
          </ul>

          <h3>4.3 Response Timeline</h3>
          <ul>
            <li><strong>Acknowledgment:</strong> Within 10 business days</li>
            <li><strong>Response:</strong> Within 45 calendar days (may extend to 90 days for complex requests)</li>
            <li><strong>No Fee:</strong> We don't charge fees for reasonable requests</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>5. Third-Party Cookies and Tracking</h2>
          
          <h3>5.1 Analytics and Performance</h3>
          <p>
            We use limited third-party services for:
          </p>
          <ul>
            <li>Website performance monitoring</li>
            <li>Security threat detection</li>
            <li>Technical error tracking</li>
          </ul>

          <h3>5.2 Opt-Out of Third-Party Tracking</h3>
          <p>
            You can opt out of third-party analytics through:
          </p>
          <ul>
            <li>Cookie preferences in the website footer</li>
            <li>Browser settings and privacy controls</li>
            <li>Industry opt-out tools (NAI, DAA)</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>6. Authorized Agents</h2>
          
          <h3>6.1 Agent Authorization</h3>
          <p>
            You may authorize an agent to make privacy requests on your behalf by providing:
          </p>
          <ul>
            <li>Signed written authorization</li>
            <li>Proof of agent's identity</li>
            <li>Verification of your identity</li>
          </ul>

          <h3>6.2 Agent Responsibilities</h3>
          <p>
            Authorized agents must:
          </p>
          <ul>
            <li>Provide valid authorization documentation</li>
            <li>Act only within the scope of authorization</li>
            <li>Maintain confidentiality of your information</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>7. Non-Discrimination</h2>
          
          <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 dark:border-amber-800/60 dark:bg-amber-900/20">
            <p className="text-amber-800 dark:text-amber-200">
              <strong>Equal Treatment:</strong> We will not discriminate against you for exercising 
              your privacy rights under California law.
            </p>
          </div>
          
          <p className="mt-4">
            We will not:
          </p>
          <ul>
            <li>Deny goods or services</li>
            <li>Charge different prices or rates</li>
            <li>Provide different quality of services</li>
            <li>Suggest different terms or conditions</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>8. Contact Information</h2>
          <p>For privacy rights requests and questions:</p>
          <ul>
            <li><strong>Privacy Officer:</strong> privacy@futuretechholdings.com</li>
            <li><strong>Phone:</strong> Available through authenticated account portal</li>
            <li><strong>Address:</strong> Future Tech Holdings, DIFC, Dubai, UAE</li>
          </ul>
        </section>

        <div className="mt-12 rounded-lg border border-neutral-200 bg-neutral-50 p-6 dark:border-neutral-800 dark:bg-neutral-900">
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            <strong>California Residents Only:</strong> This page addresses rights specific to California 
            residents under CCPA/CPRA. For general privacy practices, see our 
            <a href="/legal/privacy" className="text-blue-600 hover:underline dark:text-blue-400"> Privacy Policy</a>.
          </p>
        </div>
      </div>
    </div>
  );
}