//+------------------------------------------------------------------+
//|                    SNRZ Expert Advisor MT5                       |
//|                    Support & Resistance Zindan                   |
//|                    XAUUSD & Bitcoin Optimized                    |
//+------------------------------------------------------------------+
#property copyright "SNRZ Trading Bot 2026"
#property link      "https://snrztrading.com"
#property version   "1.0"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>

// ==================== ENUMS ====================
enum TRADE_TYPE { BUY = 1, SELL = -1, NONE = 0 };
enum SNRZ_ZONE { SUPPORT = 1, RESISTANCE = -1 };

// ==================== INPUT PARAMETERS ====================
input string        EA_Name             = "SNRZ Bot v1.0";
input double        RiskPercentage      = 1.0;           // Risk per trade (%)
input double        FixedLotSize        = 0.01;          // Lot size (fixed)
input int           FirstTargetPips     = 50;            // First target (pips)
input int           SecondTargetPips    = 100;           // Second target (pips)
input int           StopLossPips        = 30;            // Stop loss (pips)
input int           PeriodShort         = 5;             // Short MA period
input int           PeriodMedium        = 14;            // Medium MA period
input int           PeriodLong          = 50;            // Long MA period
input bool          UseAutoLot          = false;         // Calculate lot from risk (%)
input bool          ShowDebug           = true;          // Show debug info
input string        TradeSymbols        = "XAUUSD,BTCUSD"; // Symbols to trade
input int           MaxOpenPositions    = 2;             // Max positions per symbol

// ==================== GLOBAL VARIABLES ====================
CTrade         trade;
CPositionInfo  posInfo;
CSymbolInfo    symInfo;
ulong          lastOrderTicket        = 0;
double         accountBalance         = 0;
double         accountEquity          = 0;
int            magicNumber            = 12345;

// ==================== STRUCTURES ====================
struct SNRZLevel {
    double price;
    int touchCount;
    datetime lastTouch;
    bool isValid;
    SNRZ_ZONE zoneType;
};

struct TradeSignal {
    TRADE_TYPE type;
    double entryPrice;
    double stopLoss;
    double targetPrice1;
    double targetPrice2;
    bool isValid;
};

// ==================== INITIALIZATION ====================
int OnInit() {
    Print("═══════════════════════════════════════════════");
    Print("SNRZ Expert Advisor Initialized");
    Print("Version: ", EA_Name);
    Print("Risk: ", RiskPercentage, "%");
    Print("Lot: ", FixedLotSize);
    Print("Target: ", FirstTargetPips, " pips");
    Print("═══════════════════════════════════════════════");
    
    trade.SetExpertMagicNumber(magicNumber);
    return(INIT_SUCCEEDED);
}

// ==================== MAIN TICK FUNCTION ====================
void OnTick() {
    accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    
    // Parse symbols from input string
    string symbols[];
    int symbolCount = StringSplit(TradeSymbols, ',', symbols);
    
    for(int i = 0; i < symbolCount; i++) {
        string symbol = StringTrim(symbols[i]);
        
        if(symbol == "") continue;
        if(!SymbolSelect(symbol, true)) {
            if(ShowDebug) Print("Warning: Cannot select symbol ", symbol);
            continue;
        }
        
        ProcessSymbol(symbol);
    }
}

// ==================== PROCESS EACH SYMBOL ====================
void ProcessSymbol(string symbol) {
    // Get current price data
    double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
    double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
    double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    
    if(bid == 0 || ask == 0) return;
    
    // Check if we already have max positions
    if(CountOpenPositions(symbol) >= MaxOpenPositions) return;
    
    // Detect S/R Levels
    SNRZLevel support = DetectSupport(symbol, 20);
    SNRZLevel resistance = DetectResistance(symbol, 20);
    
    // Generate Trade Signal
    TradeSignal signal = GenerateSignal(symbol, support, resistance, bid, ask, point, digits);
    
    // Execute Trade
    if(signal.isValid && signal.type != NONE) {
        ExecuteTrade(symbol, signal, bid, ask, point, digits);
    }
}

// ==================== DETECT SUPPORT LEVEL ====================
SNRZLevel DetectSupport(string symbol, int bars) {
    SNRZLevel support;
    support.price = 0;
    support.touchCount = 0;
    support.isValid = false;
    support.zoneType = SUPPORT;
    
    double minPrice = DBL_MAX;
    int minBar = 0;
    
    // Find lowest point in last N bars
    for(int i = 1; i < bars; i++) {
        double low = iLow(symbol, PERIOD_CURRENT, i);
        if(low < minPrice) {
            minPrice = low;
            minBar = i;
        }
    }
    
    support.price = minPrice;
    
    // Count touches
    for(int i = 0; i < bars; i++) {
        double low = iLow(symbol, PERIOD_CURRENT, i);
        if(MathAbs(low - minPrice) < SymbolInfoDouble(symbol, SYMBOL_POINT) * 5) {
            support.touchCount++;
        }
    }
    
    // Valid if at least 2 touches (PO2 - Power of 2)
    support.isValid = (support.touchCount >= 2);
    support.lastTouch = iTime(symbol, PERIOD_CURRENT, minBar);
    
    return support;
}

// ==================== DETECT RESISTANCE LEVEL ====================
SNRZLevel DetectResistance(string symbol, int bars) {
    SNRZLevel resistance;
    resistance.price = 0;
    resistance.touchCount = 0;
    resistance.isValid = false;
    resistance.zoneType = RESISTANCE;
    
    double maxPrice = -DBL_MAX;
    int maxBar = 0;
    
    // Find highest point in last N bars
    for(int i = 1; i < bars; i++) {
        double high = iHigh(symbol, PERIOD_CURRENT, i);
        if(high > maxPrice) {
            maxPrice = high;
            maxBar = i;
        }
    }
    
    resistance.price = maxPrice;
    
    // Count touches
    for(int i = 0; i < bars; i++) {
        double high = iHigh(symbol, PERIOD_CURRENT, i);
        if(MathAbs(high - maxPrice) < SymbolInfoDouble(symbol, SYMBOL_POINT) * 5) {
            resistance.touchCount++;
        }
    }
    
    // Valid if at least 2 touches (PO2)
    resistance.isValid = (resistance.touchCount >= 2);
    resistance.lastTouch = iTime(symbol, PERIOD_CURRENT, maxBar);
    
    return resistance;
}

// ==================== GENERATE TRADE SIGNAL ====================
TradeSignal GenerateSignal(string symbol, SNRZLevel support, SNRZLevel resistance, 
                          double bid, double ask, double point, int digits) {
    TradeSignal signal;
    signal.isValid = false;
    signal.type = NONE;
    
    double spread = ask - bid;
    
    // ===== BUY SIGNAL (RBS - Resistance Breakout to Support) =====
    // Condition: Price breaks above resistance + Pullback to support
    if(resistance.isValid && bid > resistance.price && bid < (resistance.price + 20 * point)) {
        if(support.isValid) {
            signal.type = BUY;
            signal.entryPrice = ask;
            signal.stopLoss = support.price - (StopLossPips * point);
            signal.targetPrice1 = ask + (FirstTargetPips * point);
            signal.targetPrice2 = ask + (SecondTargetPips * point);
            signal.isValid = true;
            
            if(ShowDebug) {
                Print("═══ BUY SIGNAL DETECTED ═══");
                Print("Symbol: ", symbol);
                Print("Entry: ", signal.entryPrice);
                Print("SL: ", signal.stopLoss);
                Print("TP1: ", signal.targetPrice1);
                Print("TP2: ", signal.targetPrice2);
            }
            return signal;
        }
    }
    
    // ===== SELL SIGNAL (SBR - Support Breakout to Resistance) =====
    // Condition: Price breaks below support + Pullback to resistance
    if(support.isValid && bid < support.price && bid > (support.price - 20 * point)) {
        if(resistance.isValid) {
            signal.type = SELL;
            signal.entryPrice = bid;
            signal.stopLoss = resistance.price + (StopLossPips * point);
            signal.targetPrice1 = bid - (FirstTargetPips * point);
            signal.targetPrice2 = bid - (SecondTargetPips * point);
            signal.isValid = true;
            
            if(ShowDebug) {
                Print("═══ SELL SIGNAL DETECTED ═══");
                Print("Symbol: ", symbol);
                Print("Entry: ", signal.entryPrice);
                Print("SL: ", signal.stopLoss);
                Print("TP1: ", signal.targetPrice1);
                Print("TP2: ", signal.targetPrice2);
            }
            return signal;
        }
    }
    
    return signal;
}

// ==================== EXECUTE TRADE ====================
void ExecuteTrade(string symbol, TradeSignal signal, double bid, double ask, 
                 double point, int digits) {
    
    if(!signal.isValid) return;
    
    double lotSize = FixedLotSize;
    
    // Calculate lot from risk if enabled
    if(UseAutoLot) {
        double risk = (accountBalance * RiskPercentage) / 100.0;
        double pipValue = GetPipValue(symbol);
        double pipsRisk = StopLossPips;
        lotSize = risk / (pipsRisk * pipValue);
        lotSize = NormalizeDouble(lotSize, 2);
    }
    
    // Validate lot size
    double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
    
    if(lotSize < minLot) lotSize = minLot;
    if(lotSize > maxLot) lotSize = maxLot;
    
    // Place order
    if(signal.type == BUY) {
        if(trade.Buy(lotSize, symbol, ask, signal.stopLoss, signal.targetPrice1, "SNRZ BUY")) {
            lastOrderTicket = trade.ResultOrder();
            if(ShowDebug) Print("BUY ORDER PLACED: Ticket=", lastOrderTicket);
        } else {
            if(ShowDebug) Print("BUY ORDER FAILED: ", trade.ResultRetcode());
        }
    } 
    else if(signal.type == SELL) {
        if(trade.Sell(lotSize, symbol, bid, signal.stopLoss, signal.targetPrice1, "SNRZ SELL")) {
            lastOrderTicket = trade.ResultOrder();
            if(ShowDebug) Print("SELL ORDER PLACED: Ticket=", lastOrderTicket);
        } else {
            if(ShowDebug) Print("SELL ORDER FAILED: ", trade.ResultRetcode());
        }
    }
}

// ==================== COUNT OPEN POSITIONS ====================
int CountOpenPositions(string symbol) {
    int count = 0;
    int total = PositionsTotal();
    
    for(int i = 0; i < total; i++) {
        if(posInfo.SelectByIndex(i)) {
            if(posInfo.Symbol() == symbol && posInfo.Magic() == magicNumber) {
                count++;
            }
        }
    }
    
    return count;
}

// ==================== GET PIP VALUE ====================
double GetPipValue(string symbol) {
    return SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
}

// ==================== STRING TRIM UTILITY ====================
string StringTrim(string str) {
    string trimmed = "";
    int len = StringLen(str);
    
    for(int i = 0; i < len; i++) {
        int ch = StringGetCharacter(str, i);
        if(ch != 32 && ch != 9) { // Not space or tab
            trimmed += CharToString(ch);
        }
    }
    
    return trimmed;
}

// ==================== DEINIT ====================
void OnDeinit(const int reason) {
    Print("SNRZ EA Deinitialized - Reason: ", reason);
}