# FTH Gold Frontend Application

A professional Web3 frontend application for the FTH Gold tokenization system. Built with Next.js, React, and Tailwind CSS for institutional-grade private placement offerings.

## 🏗️ Architecture

This frontend application provides a secure, compliant interface for qualified investors to interact with the FTH Gold smart contracts. It implements:

- **Private Placement UI**: Exclusive access for accredited investors
- **Chainlink PoR Integration**: Real-time vault verification
- **Multi-Signature Wallet Support**: Secure transaction handling
- **KYC/AML Compliance**: Soulbound token verification
- **Legal Compliance**: Comprehensive legal pages and disclaimers

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ and npm/yarn
- Web3 wallet (MetaMask, WalletConnect, etc.)
- Access to the FTH Gold smart contracts (deployed separately)

### Installation

```bash
cd frontend
npm install
# or
yarn install
```

### Environment Setup

Create a `.env.local` file:

```bash
# Blockchain Configuration
NEXT_PUBLIC_CHAIN_ID=137  # Polygon Mainnet
NEXT_PUBLIC_RPC_URL=your_rpc_url
NEXT_PUBLIC_CHAINLINK_POR_ADDRESS=0x...
NEXT_PUBLIC_FTH_GOLD_ADDRESS=0x...
NEXT_PUBLIC_STAKE_LOCKER_ADDRESS=0x...
NEXT_PUBLIC_KYC_SOULBOUND_ADDRESS=0x...

# Application Configuration
NEXT_PUBLIC_APP_ENV=production
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=your_project_id

# Optional: Analytics and Monitoring
NEXT_PUBLIC_GA_MEASUREMENT_ID=your_ga_id
```

### Development

```bash
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) to view the application.

### Production Build

```bash
npm run build
npm start
# or
yarn build
yarn start
```

## 📁 Project Structure

```
frontend/
├── app/                          # Next.js App Router
│   ├── contact/                  # Contact information page
│   ├── legal/                    # Legal documentation
│   │   ├── terms/               # Terms of Service
│   │   ├── privacy/             # Privacy Policy
│   │   └── security/            # Security Policy
│   ├── privacy/                  # Privacy-specific pages
│   │   ├── cookies/             # Cookie preferences
│   │   └── do-not-sell/         # CCPA compliance
│   ├── globals.css              # Global styles and Tailwind
│   ├── layout.tsx               # Root layout
│   └── page.tsx                 # Homepage
├── components/                   # Reusable components
│   ├── Footer.tsx               # Application footer
│   └── Header.tsx               # Application header with Web3
├── hooks/                       # Custom React hooks
│   └── useChainlinkPoR.ts       # Proof of Reserve integration
├── lib/                         # Utilities and configurations
│   └── abi/                     # Smart contract ABIs
│       └── ChainlinkPoRAdapter.ts
├── package.json                 # Dependencies and scripts
└── README.md                    # This file
```

## 🔧 Key Components

### Header Component

Professional navigation header with:
- Wallet connection (SIWE authentication ready)
- Real-time PoR status indicator
- Responsive mobile navigation
- Dark mode support

```tsx
import Header from '@/components/Header';

<Header 
  appName="FTH Exchange"
  isConnected={isConnected}
  walletAddress={address}
  porStatus={porData}
  onConnectWallet={connect}
  onDisconnectWallet={disconnect}
  onSign={signMessage}
  isAuthenticated={isAuthenticated}
/>
```

### Footer Component

Comprehensive footer with:
- Legal navigation and compliance links
- Real-time system status badges
- Cookie management controls
- Multi-jurisdiction regulatory information

```tsx
import Footer from '@/components/Footer';

<Footer 
  appName="FTH Exchange"
  badges={{
    porHealthy: true,
    chainName: "Polygon",
    walletConnected: isConnected
  }}
/>
```

### Chainlink PoR Hook

React hook for real-time Proof of Reserve data:

```tsx
import { useChainlinkPoR, usePoRStatus } from '@/hooks/useChainlinkPoR';

const porData = useChainlinkPoR(contractAddress);
const porStatus = usePoRStatus(contractAddress);
```

## 🔐 Security Features

### Authentication
- **SIWE Integration**: Sign-In With Ethereum for secure wallet-based auth
- **KYC Verification**: Soulbound token validation for compliance
- **Session Management**: Secure session handling with automatic timeouts

### Data Protection
- **Client-Side Encryption**: Sensitive data encrypted in browser
- **Secure Communications**: All API calls over HTTPS/WSS
- **Privacy Controls**: Granular cookie and tracking preferences

### Smart Contract Security
- **Read-Only Operations**: Frontend focuses on data display and user interaction
- **Transaction Validation**: Pre-transaction checks and confirmations
- **Multi-Sig Support**: Integration with multi-signature wallet flows

## 📋 Legal & Compliance

### Private Placement Compliance
- **Accredited Investor Verification**: KYC/AML integration
- **Disclosure Requirements**: Comprehensive risk disclosures
- **Regulatory Notices**: Multi-jurisdiction compliance notices
- **Terms Acceptance**: Digital terms and conditions acceptance

### Privacy Compliance
- **GDPR Ready**: European privacy regulation compliance
- **CCPA Support**: California Consumer Privacy Act compliance
- **Cookie Management**: Granular consent and preference controls
- **Data Rights**: User access, correction, and deletion rights

### Legal Pages
- **Terms of Service**: Complete private placement terms
- **Privacy Policy**: Comprehensive data handling practices
- **Security Policy**: Security measures and incident response
- **Cookie Policy**: Detailed cookie usage and controls
- **Do Not Sell**: CCPA-compliant data rights page

## 🌐 Web3 Integration

### Wallet Support
- MetaMask, WalletConnect, Coinbase Wallet, and more
- Multi-chain support (Polygon, Ethereum, Arbitrum)
- Hardware wallet compatibility (Ledger, Trezor)

### Smart Contract Integration
```typescript
// Example contract interaction
import { useReadContract } from 'wagmi';
import { ChainlinkPoRAdapterABI } from '@/lib/abi/ChainlinkPoRAdapter';

const { data: totalVaulted } = useReadContract({
  address: porAddress,
  abi: ChainlinkPoRAdapterABI,
  functionName: 'totalVaultedKg',
});
```

### Real-Time Updates
- Block number monitoring for live data
- Oracle feed integration for PoR status
- Event listening for contract updates
- Automatic reconnection handling

## 🎨 Styling & Theming

### Tailwind CSS Configuration
- Custom color palette for gold/financial theme
- Dark mode support with system preference detection
- Responsive design for all screen sizes
- Accessibility-focused design patterns

### Component Styling
- Glass morphism effects for modern UI
- Professional color scheme (gold accents)
- Consistent spacing and typography
- Interactive hover and focus states

## 🚀 Deployment

### Vercel (Recommended)
```bash
npm run build
# Deploy to Vercel via CLI or GitHub integration
```

### Docker
```bash
# Create Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```

### Environment Variables
Ensure all production environment variables are properly configured:
- Smart contract addresses
- RPC endpoints  
- Analytics tracking IDs
- Security tokens and keys

## 🧪 Testing

```bash
# Unit tests
npm run test

# E2E tests  
npm run test:e2e

# Type checking
npm run type-check

# Linting
npm run lint
```

## 📊 Analytics & Monitoring

### Privacy-Compliant Analytics
- Anonymous usage tracking (opt-in only)
- Performance monitoring
- Error tracking and alerting
- User journey analysis

### Security Monitoring
- Wallet connection monitoring
- Transaction success/failure tracking
- Smart contract interaction logging
- Suspicious activity detection

## 🤝 Contributing

This frontend is part of the FTH Gold private placement system. Contributions should maintain:

- **Regulatory Compliance**: All changes must comply with securities regulations
- **Security Standards**: Follow Web3 security best practices
- **Code Quality**: Maintain TypeScript types and testing coverage
- **Documentation**: Update docs for any functional changes

## 📞 Support

For technical support or questions about this frontend application:

- **Technical Issues**: support@futuretechholdings.com
- **Security Concerns**: security@futuretechholdings.com  
- **Compliance Questions**: compliance@futuretechholdings.com

## ⚖️ Legal Notice

This frontend application is designed exclusively for qualified accredited investors participating in FTH Gold private placement offerings. It is not intended for retail investor use and contains no public investment advice or recommendations.

**Important**: This application interfaces with smart contracts containing digital representations of physical assets. All participants must complete KYC/AML verification and accept comprehensive terms and conditions before platform access.

---

**FTH Gold Frontend v1.0.0** | Built with ❤️ for institutional DeFi | Future Tech Holdings © 2024