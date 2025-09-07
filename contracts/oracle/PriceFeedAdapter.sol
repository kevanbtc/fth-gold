// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "../access/AccessRoles.sol";
import "../libs/Errors.sol";
import "../libs/Events.sol";

/**
 * @title PriceFeedAdapter
 * @dev Chainlink price feed adapter for XAU/USD with safety checks
 */
contract PriceFeedAdapter is AccessRoles {
    /// @notice Chainlink XAU/USD price feed
    AggregatorV3Interface public priceFeed;
    
    /// @notice Maximum age for price data (1 hour)
    uint256 public constant MAX_PRICE_AGE = 3600;
    
    /// @notice Maximum price deviation threshold (10%)
    uint256 public constant MAX_PRICE_DEVIATION = 1000; // 10% in basis points
    
    /// @notice Minimum valid price (prevents flash crashes)
    uint256 public constant MIN_VALID_PRICE = 1500e8; // $1,500 per oz
    
    /// @notice Maximum valid price (prevents flash pumps)
    uint256 public constant MAX_VALID_PRICE = 10000e8; // $10,000 per oz
    
    /// @notice Last valid price (for deviation checks)
    uint256 public lastValidPrice;
    
    /// @notice Last price update timestamp
    uint256 public lastPriceUpdate;
    
    /// @notice Emergency price override
    bool public emergencyPriceOverride;
    uint256 public emergencyPrice;
    
    /// @notice Circuit breaker status
    bool public circuitBreakerTripped;

    event PriceFeedUpdated(address indexed newFeed);
    event PriceUpdated(uint256 price, uint256 timestamp);
    event EmergencyPriceSet(uint256 price, bool override);
    event CircuitBreakerTripped(uint256 price, uint256 lastPrice, string reason);
    event CircuitBreakerReset();

    constructor(address admin, address _priceFeed) {
        _initializeRoles(admin);
        if (_priceFeed != address(0)) {
            priceFeed = AggregatorV3Interface(_priceFeed);
            _initializePrice();
        }
    }

    /**
     * @dev Set price feed address
     */
    function setPriceFeed(address _priceFeed) external onlyOracle {
        if (_priceFeed == address(0)) revert Errors.InvalidAddress(_priceFeed);
        priceFeed = AggregatorV3Interface(_priceFeed);
        _initializePrice();
        emit PriceFeedUpdated(_priceFeed);
    }

    /**
     * @dev Get current XAU/USD price with safety checks
     * @return price Price in USD with 8 decimals (per ounce)
     */
    function getXAUPrice() external view returns (uint256 price) {
        // Return emergency price if override is active
        if (emergencyPriceOverride) {
            return emergencyPrice;
        }

        // Check circuit breaker
        if (circuitBreakerTripped) {
            return lastValidPrice;
        }

        if (address(priceFeed) == address(0)) {
            revert Errors.InvalidConfiguration();
        }

        try priceFeed.latestRoundData() returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) {
            // Check data freshness
            if (block.timestamp - updatedAt > MAX_PRICE_AGE) {
                revert Errors.OracleStale(updatedAt, MAX_PRICE_AGE);
            }

            // Ensure positive price
            if (answer <= 0) {
                revert Errors.PriceFeedFailure();
            }

            uint256 currentPrice = uint256(answer);

            // Check price bounds
            if (currentPrice < MIN_VALID_PRICE || currentPrice > MAX_VALID_PRICE) {
                revert Errors.PriceFeedFailure();
            }

            return currentPrice;
        } catch {
            revert Errors.PriceFeedFailure();
        }
    }

    /**
     * @dev Get price per kg (1000g = ~32.15 oz)
     * @return pricePerKg Price in USD per kg with 8 decimals
     */
    function getXAUPricePerKg() external view returns (uint256 pricePerKg) {
        uint256 pricePerOz = this.getXAUPrice();
        // 1 kg = 32.1507 troy oz
        return (pricePerOz * 321507) / 10000;
    }

    /**
     * @dev Check if price feed is healthy
     */
    function isPriceFeedHealthy() external view returns (bool) {
        if (emergencyPriceOverride || circuitBreakerTripped) {
            return true; // Using fallback
        }

        if (address(priceFeed) == address(0)) {
            return false;
        }

        try priceFeed.latestRoundData() returns (
            uint80,
            int256 answer,
            uint256,
            uint256 updatedAt,
            uint80
        ) {
            return (
                answer > 0 && 
                answer >= int256(MIN_VALID_PRICE) &&
                answer <= int256(MAX_VALID_PRICE) &&
                block.timestamp - updatedAt <= MAX_PRICE_AGE
            );
        } catch {
            return false;
        }
    }

    /**
     * @dev Update price with deviation check
     */
    function updatePrice() external returns (uint256 newPrice) {
        if (emergencyPriceOverride) {
            return emergencyPrice;
        }

        newPrice = this.getXAUPrice();
        
        // Check for significant deviation if we have a last valid price
        if (lastValidPrice > 0 && !circuitBreakerTripped) {
            uint256 deviation = _calculateDeviation(newPrice, lastValidPrice);
            
            if (deviation > MAX_PRICE_DEVIATION) {
                circuitBreakerTripped = true;
                emit CircuitBreakerTripped(newPrice, lastValidPrice, "Price deviation exceeded");
                return lastValidPrice; // Return last valid price
            }
        }

        // Update tracking variables
        lastValidPrice = newPrice;
        lastPriceUpdate = block.timestamp;
        
        emit PriceUpdated(newPrice, block.timestamp);
        return newPrice;
    }

    /**
     * @dev Set emergency price override
     */
    function setEmergencyPrice(uint256 price, bool override) external onlyGuardian {
        if (override && (price < MIN_VALID_PRICE || price > MAX_VALID_PRICE)) {
            revert Errors.InvalidConfiguration();
        }
        
        emergencyPriceOverride = override;
        if (override) {
            emergencyPrice = price;
        }
        
        emit EmergencyPriceSet(price, override);
    }

    /**
     * @dev Reset circuit breaker
     */
    function resetCircuitBreaker() external onlyGuardian {
        circuitBreakerTripped = false;
        emit CircuitBreakerReset();
    }

    /**
     * @dev Get complete price data
     */
    function getPriceData() external view returns (
        uint256 currentPrice,
        uint256 pricePerKg,
        uint256 lastUpdate,
        bool healthy,
        bool override,
        bool circuitBreaker
    ) {
        return (
            this.getXAUPrice(),
            this.getXAUPricePerKg(),
            lastPriceUpdate,
            this.isPriceFeedHealthy(),
            emergencyPriceOverride,
            circuitBreakerTripped
        );
    }

    /**
     * @dev Calculate percentage deviation between two prices
     */
    function _calculateDeviation(uint256 newPrice, uint256 oldPrice) private pure returns (uint256) {
        if (oldPrice == 0) return 0;
        
        uint256 diff = newPrice > oldPrice ? newPrice - oldPrice : oldPrice - newPrice;
        return (diff * 10000) / oldPrice; // Return in basis points
    }

    /**
     * @dev Initialize price on deployment
     */
    function _initializePrice() private {
        if (address(priceFeed) == address(0)) return;
        
        try this.updatePrice() returns (uint256 price) {
            lastValidPrice = price;
            lastPriceUpdate = block.timestamp;
        } catch {
            // Initialization failed, will need manual setup
        }
    }
}