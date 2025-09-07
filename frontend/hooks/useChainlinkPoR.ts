import { useState, useEffect } from 'react';
import { useReadContract, useBlockNumber } from 'wagmi';
import { ChainlinkPoRAdapterABI } from '../lib/abi/ChainlinkPoRAdapter';

/**
 * Hook to read Chainlink Proof of Reserve data from FTH Gold system
 * Integrates with the ChainlinkPoRAdapter contract
 */

export type PoRData = {
  totalVaultedKg: bigint;
  isHealthy: boolean;
  lastUpdate: bigint;
  coverageRatio: number;
  loading: boolean;
  error: string | null;
};

export const useChainlinkPoR = (
  contractAddress: `0x${string}` | undefined,
  refreshInterval: number = 30000 // 30 seconds
): PoRData => {
  const [error, setError] = useState<string | null>(null);
  const { data: blockNumber } = useBlockNumber({ watch: true });

  // Read total vaulted kg
  const {
    data: totalVaultedKg,
    isLoading: loadingVaulted,
    error: vaultedError,
  } = useReadContract({
    address: contractAddress,
    abi: ChainlinkPoRAdapterABI,
    functionName: 'totalVaultedKg',
    query: {
      enabled: !!contractAddress,
    },
  });

  // Read oracle health status
  const {
    data: isHealthy,
    isLoading: loadingHealth,
    error: healthError,
  } = useReadContract({
    address: contractAddress,
    abi: ChainlinkPoRAdapterABI,
    functionName: 'isHealthy',
    query: {
      enabled: !!contractAddress,
    },
  });

  // Read last update timestamp
  const {
    data: lastUpdate,
    isLoading: loadingUpdate,
    error: updateError,
  } = useReadContract({
    address: contractAddress,
    abi: ChainlinkPoRAdapterABI,
    functionName: 'lastUpdate',
    query: {
      enabled: !!contractAddress,
    },
  });

  // Calculate coverage ratio (would need FTH-G total supply)
  // For now, we'll mock this or make it configurable
  const calculateCoverageRatio = (vaultedKg: bigint): number => {
    // This would typically compare against FTH-G total supply
    // For demo purposes, returning a mock ratio
    const mockOutstandingKg = 100000n; // 100,000 kg outstanding
    if (mockOutstandingKg === 0n) return 0;
    return Number((vaultedKg * 10000n) / mockOutstandingKg) / 100; // Convert to percentage
  };

  // Handle errors
  useEffect(() => {
    const errors = [vaultedError, healthError, updateError].filter(Boolean);
    if (errors.length > 0) {
      setError(errors[0]?.message || 'Failed to fetch PoR data');
    } else {
      setError(null);
    }
  }, [vaultedError, healthError, updateError]);

  return {
    totalVaultedKg: totalVaultedKg || 0n,
    isHealthy: isHealthy || false,
    lastUpdate: lastUpdate || 0n,
    coverageRatio: totalVaultedKg ? calculateCoverageRatio(totalVaultedKg) : 0,
    loading: loadingVaulted || loadingHealth || loadingUpdate,
    error,
  };
};

// Hook to get formatted PoR status for UI components
export const usePoRStatus = (contractAddress: `0x${string}` | undefined) => {
  const porData = useChainlinkPoR(contractAddress);

  return {
    healthy: porData.isHealthy && !porData.loading && !porData.error,
    coverageRatio: porData.coverageRatio,
    lastUpdate: Number(porData.lastUpdate),
    status: porData.loading
      ? 'loading'
      : porData.error
      ? 'error'
      : porData.isHealthy
      ? 'healthy'
      : 'unhealthy',
    displayText: porData.loading
      ? 'Loading...'
      : porData.error
      ? 'Error'
      : `${porData.coverageRatio.toFixed(1)}% Coverage`,
  };
};

// Example usage in components:
/*
import { usePoRStatus } from '@/hooks/useChainlinkPoR';

const MyComponent = () => {
  const porStatus = usePoRStatus('0x...' as `0x${string}`);
  
  return (
    <div>
      <StatusPill 
        healthy={porStatus.healthy}
        text={porStatus.displayText}
      />
    </div>
  );
};
*/