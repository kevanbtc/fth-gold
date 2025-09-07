// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../contracts/access/AccessRoles.sol";
import "../contracts/compliance/KYCSoulbound.sol";
import "../contracts/compliance/ComplianceRegistry.sol";
import "../contracts/oracle/ChainlinkPoRAdapter.sol";
import "../contracts/oracle/PriceFeedAdapter.sol";
import "../contracts/tokens/FTHGold.sol";
import "../contracts/tokens/FTHStakeReceipt.sol";
import "../contracts/staking/StakeLocker.sol";

/**
 * @title Deploy
 * @dev Deployment script for FTH Gold system contracts
 */
contract Deploy is Script {
    // Deployment configuration
    struct DeployConfig {
        address admin;           // Multi-sig admin address
        address treasury;        // Treasury for USDT collection
        address usdt;           // USDT token address
        address porFeed;        // Chainlink PoR feed (can be zero for testnet)
        address priceFeed;      // Chainlink XAU/USD feed
        uint256 usdtPerKg;      // USDT per kg (default: $20,000 with 6 decimals)
        uint256 coverageRatio;  // Coverage ratio in bps (default: 12500 = 125%)
    }

    // Deployed contract addresses
    struct DeployedContracts {
        address kyc;
        address compliance;
        address porAdapter;
        address priceFeed;
        address fthGold;
        address stakeReceipt;
        address stakeLocker;
    }

    function run() external returns (DeployedContracts memory) {
        // Load configuration
        DeployConfig memory config = _loadConfig();
        
        // Start deployment
        vm.startBroadcast();
        
        DeployedContracts memory contracts = _deployContracts(config);
        
        vm.stopBroadcast();
        
        // Log deployment addresses
        _logDeployment(contracts);
        
        return contracts;
    }

    function _loadConfig() internal view returns (DeployConfig memory config) {
        // Load from environment variables
        config.admin = vm.envOr("ADMIN_MULTISIG", makeAddr("admin"));
        config.treasury = vm.envOr("TREASURY_ADDRESS", makeAddr("treasury"));
        config.usdt = vm.envOr("USDT_ADDRESS", address(0));
        config.porFeed = vm.envOr("CHAINLINK_POR_FEED", address(0));
        config.priceFeed = vm.envOr("CHAINLINK_XAU_USD", address(0));
        config.usdtPerKg = vm.envOr("USDT_PER_KG", uint256(20000e6)); // $20,000
        config.coverageRatio = vm.envOr("COVERAGE_RATIO_BPS", uint256(12500)); // 125%
        
        // Deploy mock USDT for testnet if not provided
        if (config.usdt == address(0)) {
            config.usdt = address(new MockUSDT());
            console.log("Deployed Mock USDT at:", config.usdt);
        }
    }

    function _deployContracts(DeployConfig memory config) internal returns (DeployedContracts memory contracts) {
        // 1. Deploy KYC Soulbound token
        contracts.kyc = address(new KYCSoulbound(config.admin));
        console.log("KYC Soulbound deployed at:", contracts.kyc);

        // 2. Deploy Compliance Registry
        contracts.compliance = address(new ComplianceRegistry(config.admin));
        console.log("Compliance Registry deployed at:", contracts.compliance);

        // 3. Deploy PoR Adapter
        contracts.porAdapter = address(new ChainlinkPoRAdapter(config.admin, config.porFeed));
        console.log("PoR Adapter deployed at:", contracts.porAdapter);

        // 4. Deploy Price Feed Adapter
        contracts.priceFeed = address(new PriceFeedAdapter(config.admin, config.priceFeed));
        console.log("Price Feed Adapter deployed at:", contracts.priceFeed);

        // 5. Deploy FTH Gold token
        contracts.fthGold = address(new FTHGold(config.admin));
        console.log("FTH Gold deployed at:", contracts.fthGold);

        // 6. Deploy Stake Receipt token
        contracts.stakeReceipt = address(new FTHStakeReceipt(config.admin));
        console.log("Stake Receipt deployed at:", contracts.stakeReceipt);

        // 7. Deploy Stake Locker (main contract)
        contracts.stakeLocker = address(
            new StakeLocker(
                config.admin,
                IERC20(config.usdt),
                FTHGold(contracts.fthGold),
                FTHStakeReceipt(contracts.stakeReceipt),
                KYCSoulbound(contracts.kyc),
                ComplianceRegistry(contracts.compliance),
                ChainlinkPoRAdapter(contracts.porAdapter),
                PriceFeedAdapter(contracts.priceFeed),
                config.treasury
            )
        );
        console.log("Stake Locker deployed at:", contracts.stakeLocker);

        // Configure initial settings
        _configureContracts(contracts, config);
    }

    function _configureContracts(DeployedContracts memory contracts, DeployConfig memory config) internal {
        // Grant necessary roles
        
        // FTH Gold: Grant ISSUER_ROLE to StakeLocker
        FTHGold(contracts.fthGold).grantRole(
            FTHGold(contracts.fthGold).ISSUER_ROLE(),
            contracts.stakeLocker
        );
        
        // Stake Receipt: Grant ISSUER_ROLE to StakeLocker  
        FTHStakeReceipt(contracts.stakeReceipt).grantRole(
            FTHStakeReceipt(contracts.stakeReceipt).ISSUER_ROLE(),
            contracts.stakeLocker
        );

        console.log("Initial configuration completed");
    }

    function _logDeployment(DeployedContracts memory contracts) internal pure {
        console.log("\n=== FTH Gold System Deployment Complete ===");
        console.log("KYC Soulbound:      ", contracts.kyc);
        console.log("Compliance Registry:", contracts.compliance);
        console.log("PoR Adapter:        ", contracts.porAdapter);
        console.log("Price Feed Adapter: ", contracts.priceFeed);
        console.log("FTH Gold Token:     ", contracts.fthGold);
        console.log("Stake Receipt:      ", contracts.stakeReceipt);
        console.log("Stake Locker:       ", contracts.stakeLocker);
        console.log("===========================================\n");
    }
}

/**
 * @title MockUSDT
 * @dev Simple mock USDT for testing
 */
contract MockUSDT is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    uint256 private _totalSupply = 1000000000e6; // 1B USDT
    string public name = "Mock USDT";
    string public symbol = "USDT";
    uint8 public decimals = 6;

    constructor() {
        _balances[msg.sender] = _totalSupply;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external override returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: insufficient allowance");
        
        _transfer(from, to, amount);
        _approve(from, msg.sender, currentAllowance - amount);
        
        return true;
    }

    function mint(address to, uint256 amount) external {
        _balances[to] += amount;
        _totalSupply += amount;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from zero address");
        require(to != address(0), "ERC20: transfer to zero address");
        require(_balances[from] >= amount, "ERC20: insufficient balance");

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from zero address");
        require(spender != address(0), "ERC20: approve to zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}