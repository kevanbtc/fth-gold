export const ChainlinkPoRAdapterABI = [
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "admin",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "_porFeed",
        "type": "address"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "inputs": [],
    "name": "totalVaultedKg",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "batchId",
        "type": "uint256"
      }
    ],
    "name": "batchKg",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "lastUpdate",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "isHealthy",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_porFeed",
        "type": "address"
      }
    ],
    "name": "setPoRFeed",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "batchId",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "kgAmount",
        "type": "uint256"
      },
      {
        "internalType": "bytes32",
        "name": "attestationHash",
        "type": "bytes32"
      }
    ],
    "name": "verifyBatch",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "batchId",
        "type": "uint256"
      }
    ],
    "name": "getBatchAttestation",
    "outputs": [
      {
        "internalType": "bytes32",
        "name": "",
        "type": "bytes32"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "bool",
        "name": "enabled",
        "type": "bool"
      },
      {
        "internalType": "uint256",
        "name": "overrideAmount",
        "type": "uint256"
      }
    ],
    "name": "setEmergencyOverride",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "updateCache",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getPoRData",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "vaultTotalKg",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "updateTime",
        "type": "uint256"
      },
      {
        "internalType": "bool",
        "name": "healthy",
        "type": "bool"
      },
      {
        "internalType": "bool",
        "name": "override",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalVerifiedKg",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "total",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "newFeed",
        "type": "address"
      }
    ],
    "name": "PoRFeedUpdated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "bool",
        "name": "enabled",
        "type": "bool"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "overrideAmount",
        "type": "uint256"
      }
    ],
    "name": "EmergencyOverrideToggled",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "uint256",
        "name": "batchId",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "kgAmount",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "bytes32",
        "name": "attestationHash",
        "type": "bytes32"
      }
    ],
    "name": "BatchVerified",
    "type": "event"
  }
] as const;