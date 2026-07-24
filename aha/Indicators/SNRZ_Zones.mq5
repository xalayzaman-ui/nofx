//+------------------------------------------------------------------+
//|                    SNRZ Zones Indicator MT5                      |
//|                    Visual Support & Resistance Display           |
//+------------------------------------------------------------------+
#property copyright "SNRZ 2026"
#property link      "https://snrztrading.com"
#property version   "1.0"
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

input int   LookbackBars        = 50;    // Number of bars to analyze
input color ColorSupport        = clrGreen;
input color ColorResistance     = clrRed;
input int   LineWidth           = 2;
input bool  ShowZoneBoxes       = true;

// ==================== INIT ====================
int OnInit() {
    return(INIT_SUCCEEDED);
}

// ==================== CALCULATE ====================
int OnCalculate(const int rates_total, const int prev_calculated, 
                const datetime &time[], const double &open[], const double &high[], 
                const double &low[], const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[]) {
    
    string symbol = _Symbol;
    ENUM_TIMEFRAMES timeframe = _Period;
    double point = _Point;
    
    // Detect Support
    double supportPrice = 0;
    int supportTouches = 0;
    double minLow = DBL_MAX;
    
    for(int i = 1; i < LookbackBars; i++) {
        if(low[rates_total - i] < minLow) {
            minLow = low[rates_total - i];
        }
    }
    
    for(int i = 0; i < LookbackBars; i++) {
        if(MathAbs(low[rates_total - i] - minLow) < point * 5) {
            supportTouches++;
        }
    }
    
    supportPrice = minLow;
    
    // Detect Resistance
    double resistancePrice = 0;
    int resistanceTouches = 0;
    double maxHigh = -DBL_MAX;
    
    for(int i = 1; i < LookbackBars; i++) {
        if(high[rates_total - i] > maxHigh) {
            maxHigh = high[rates_total - i];
        }
    }
    
    for(int i = 0; i < LookbackBars; i++) {
        if(MathAbs(high[rates_total - i] - maxHigh) < point * 5) {
            resistanceTouches++;
        }
    }
    
    resistancePrice = maxHigh;
    
    // Draw Support Line (if valid - PO2)
    if(supportTouches >= 2) {
        DrawLine("SNRZ_Support", supportPrice, ColorSupport);
    }
    
    // Draw Resistance Line (if valid - PO2)
    if(resistanceTouches >= 2) {
        DrawLine("SNRZ_Resistance", resistancePrice, ColorResistance);
    }
    
    // Draw Zone Boxes
    if(ShowZoneBoxes && supportTouches >= 2 && resistanceTouches >= 2) {
        DrawZoneBox(supportPrice, resistancePrice, ColorSupport, ColorResistance);
    }
    
    return(rates_total);
}

// ==================== DRAW HORIZONTAL LINE ====================
void DrawLine(string name, double price, color lineColor) {
    if(ObjectFind(0, name) >= 0) {
        ObjectDelete(0, name);
    }
    
    ObjectCreate(0, name, OBJ_HLINE, 0, 0, price);
    ObjectSetInteger(0, name, OBJPROP_COLOR, lineColor);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, LineWidth);
    ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
}

// ==================== DRAW ZONE BOX ====================
void DrawZoneBox(double support, double resistance, color colorS, color colorR) {
    string boxName = "SNRZ_Zone_Box";
    
    if(ObjectFind(0, boxName) >= 0) {
        ObjectDelete(0, boxName);
    }
    
    datetime time1 = iTime(_Symbol, _Period, 100);
    datetime time2 = iTime(_Symbol, _Period, 0);
    
    ObjectCreate(0, boxName, OBJ_RECTANGLE, 0, time1, support, time2, resistance);
    ObjectSetInteger(0, boxName, OBJPROP_FILL, true);
    ObjectSetInteger(0, boxName, OBJPROP_BACK, true);
    ObjectSetInteger(0, boxName, OBJPROP_BGCOLOR, C'200,200,200');
    ObjectSetInteger(0, boxName, OBJPROP_BORDER_COLOR, clrBlack);
}