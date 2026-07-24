//+------------------------------------------------------------------+
//|                    Risk Management Module                        |
//|                    Money Management & Position Sizing            |
//+------------------------------------------------------------------+

class CRiskManager {
private:
    double riskPercentage;
    double accountBalance;
    double fixedLotSize;
    
public:
    CRiskManager(double risk, double balance, double lot) {
        riskPercentage = risk;
        accountBalance = balance;
        fixedLotSize = lot;
    }
    
    // Calculate lot size based on risk
    double CalculateLotSize(double stopLossPips, string symbol) {
        double pipValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
        double risk = (accountBalance * riskPercentage) / 100.0;
        double lot = risk / (stopLossPips * pipValue);
        
        // Normalize to 2 decimals
        return NormalizeDouble(lot, 2);
    }
    
    // Get fixed lot size
    double GetFixedLot() {
        return fixedLotSize;
    }
    
    // Validate lot against broker limits
    bool ValidateLot(double lot, string symbol) {
        double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
        double maxLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
        double step = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
        
        if(lot < minLot || lot > maxLot) return false;
        
        double remainder = lot / step;
        if(remainder != (int)remainder) return false;
        
        return true;
    }
};