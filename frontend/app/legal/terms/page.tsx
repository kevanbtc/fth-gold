import React from 'react';

export default function TermsOfService() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold tracking-tight">Terms of Service</h1>
        <p className="mt-2 text-neutral-600 dark:text-neutral-400">
          Last updated: {new Date().toLocaleDateString()}
        </p>
      </div>

      <div className="prose prose-neutral dark:prose-invert max-w-none">
        <section className="mb-8">
          <h2>1. Private Placement Offering</h2>
          <p>
            The FTH Gold (FTH-G) tokens are offered exclusively through private placement to qualified 
            participants only. This offering is not available to retail investors and is not a public 
            securities offering.
          </p>
          
          <h3>1.1 Eligibility Requirements</h3>
          <ul>
            <li>Must be an accredited investor as defined by applicable securities regulations</li>
            <li>Must complete KYC/AML verification and receive a soulbound verification token</li>
            <li>Must be invited by Future Tech Holdings through official channels</li>
            <li>Must comply with jurisdiction-specific requirements (UAE/DMCC, US Reg D/S, EU MiCA, Swiss FINMA)</li>
          </ul>

          <h3>1.2 Token Structure</h3>
          <ul>
            <li>Each FTH-G token represents ownership of 1 kilogram of vaulted gold</li>
            <li>Gold is stored in DMCC-licensed vaults in Dubai with verified Proof of Reserve</li>
            <li>5-month lock period before token issuance and yield distribution</li>
            <li>Monthly yield distribution subject to program cash flows and policy limits</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>2. Risks and Disclaimers</h2>
          
          <h3>2.1 Investment Risks</h3>
          <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 dark:border-amber-800/60 dark:bg-amber-900/20">
            <p className="text-amber-800 dark:text-amber-200">
              <strong>High Risk Investment:</strong> FTH-G tokens involve substantial risk and may not be 
              suitable for all investors. You may lose some or all of your investment.
            </p>
          </div>
          
          <ul className="mt-4">
            <li><strong>Gold Price Volatility:</strong> Token value subject to gold price fluctuations</li>
            <li><strong>Operational Risk:</strong> Mining operations, vault security, regulatory changes</li>
            <li><strong>Technology Risk:</strong> Smart contract vulnerabilities, oracle failures</li>
            <li><strong>Liquidity Risk:</strong> Limited redemption options, internal market only</li>
            <li><strong>Regulatory Risk:</strong> Changes in cryptocurrency or securities regulations</li>
          </ul>

          <h3>2.2 No Guarantees</h3>
          <p>
            Future Tech Holdings makes no guarantees regarding:
          </p>
          <ul>
            <li>Future returns or yield distributions</li>
            <li>Token value appreciation or depreciation</li>
            <li>Continuous availability of redemption options</li>
            <li>Uninterrupted platform operations</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>3. Platform Usage</h2>
          
          <h3>3.1 Permitted Use</h3>
          <p>You may use the FTH Exchange platform solely for:</p>
          <ul>
            <li>Participating in authorized private placement offerings</li>
            <li>Managing your token positions and distributions</li>
            <li>Executing permitted redemptions and transfers</li>
            <li>Accessing authorized documentation and support</li>
          </ul>

          <h3>3.2 Prohibited Activities</h3>
          <ul>
            <li>Attempting to circumvent KYC/AML verification requirements</li>
            <li>Using the platform for money laundering or illicit activities</li>
            <li>Attempting to exploit smart contract vulnerabilities</li>
            <li>Sharing access credentials or transferring verification tokens</li>
            <li>Reverse engineering or unauthorized access to platform systems</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>4. Compliance and Regulations</h2>
          
          <h3>4.1 KYC/AML Requirements</h3>
          <p>
            All participants must maintain current KYC/AML verification. Expired or invalid 
            verification will result in suspension of platform access and distribution eligibility.
          </p>

          <h3>4.2 Tax Obligations</h3>
          <p>
            Participants are solely responsible for determining and fulfilling their tax obligations 
            related to token ownership, distributions, and redemptions in their jurisdiction of residence.
          </p>

          <h3>4.3 Regulatory Cooperation</h3>
          <p>
            Future Tech Holdings reserves the right to cooperate with regulatory authorities and may 
            disclose participant information as required by applicable law or regulation.
          </p>
        </section>

        <section className="mb-8">
          <h2>5. Limitation of Liability</h2>
          
          <div className="rounded-lg border border-red-200 bg-red-50 p-4 dark:border-red-800/60 dark:bg-red-900/20">
            <p className="text-red-800 dark:text-red-200">
              <strong>Important:</strong> Future Tech Holdings' liability is limited to the maximum extent 
              permitted by applicable law. We are not liable for indirect, incidental, or consequential damages.
            </p>
          </div>

          <p className="mt-4">
            Future Tech Holdings is not liable for losses resulting from:
          </p>
          <ul>
            <li>Market fluctuations in gold prices or token values</li>
            <li>Third-party failures (oracles, infrastructure providers, vault operators)</li>
            <li>Force majeure events beyond our reasonable control</li>
            <li>Participant errors or security breaches on their end</li>
            <li>Regulatory changes or legal developments</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2>6. Termination and Modifications</h2>
          
          <h3>6.1 Service Termination</h3>
          <p>
            Future Tech Holdings may suspend or terminate platform access for violations of these terms 
            or applicable regulations. Participants may be entitled to redemption rights subject to 
            applicable policies.
          </p>

          <h3>6.2 Terms Updates</h3>
          <p>
            These terms may be updated periodically. Continued platform use constitutes acceptance of 
            updated terms. Material changes will be communicated to participants in advance.
          </p>
        </section>

        <section className="mb-8">
          <h2>7. Governing Law and Disputes</h2>
          
          <h3>7.1 Governing Law</h3>
          <p>
            These terms are governed by the laws of the Dubai International Financial Centre (DIFC) 
            and the United Arab Emirates, without regard to conflict of law principles.
          </p>

          <h3>7.2 Dispute Resolution</h3>
          <p>
            Disputes will be resolved through binding arbitration administered by the DIFC-LCIA 
            Arbitration Centre in accordance with the LCIA Arbitration Rules. Proceedings will be 
            conducted in English in Dubai, UAE.
          </p>
        </section>

        <section className="mb-8">
          <h2>8. Contact Information</h2>
          <p>
            For questions about these terms or platform usage:
          </p>
          <ul>
            <li><strong>Email:</strong> legal@futuretechholdings.com</li>
            <li><strong>Address:</strong> Future Tech Holdings, DIFC, Dubai, UAE</li>
            <li><strong>Platform Support:</strong> Available through authenticated user portal</li>
          </ul>
        </section>

        <div className="mt-12 rounded-lg border border-neutral-200 bg-neutral-50 p-6 dark:border-neutral-800 dark:bg-neutral-900">
          <p className="text-sm text-neutral-600 dark:text-neutral-400">
            <strong>Important Notice:</strong> Please read the complete Private Placement Memorandum (PPM) 
            for comprehensive terms, conditions, and risk disclosures. These Terms of Service provide a 
            summary and do not replace the full legal documentation governing your participation.
          </p>
        </div>
      </div>
    </div>
  );
}