# SNRZ Bot MT5 - Support & Resistance Zindan Trading Bot

## 📊 خصوصیات (Features)

### ✅ SNRZ Strategy Implementation
- **Support & Resistance Detection** - شناسایی خودکار ناوچە پاڵپشتی و بەرگری
- **PO2 Validation** - Power of 2nd Touch برای تایید سیگنالات
- **Breakout Signals** - SBR (Support Breakout to Resistance) و RBS (Resistance Breakout to Support)
- **Multi-Timeframe Analysis** - تجزیه چند بازه زمانی

### 💰 Risk Management
- **1% Risk per Trade** - ریسک ثابت در هر معامله
- **Fixed Lot Size** - 0.01 Lot
- **Auto Lot Calculator** - محاسبه خودکار Lot بر اساس ریسک
- **Position Management** - حد اکثر 2 معامله باز در هر نماد

### 🎯 Trading Specifications
- **Target 1:** 50 pips
- **Target 2:** 100 pips
- **Stop Loss:** 30 pips
- **Symbols:** XAUUSD (Gold) & Bitcoin (BTCUSD)

### 🤖 Automation
- **Full Automated Trading** - بدون نیاز به دخالت دستی
- **Alert System** - اطلاعات در Experts tab
- **Visual Indicator** - نمایش ناوچە S/R بر روی نمودار

---

## 📁 ساختار پوشه ها (Folder Structure)

```
snrz-bot-mt5/
├── Experts/
│   └── SNRZ_EA.mq5              # Expert Advisor اصلی
├── Indicators/
│   └── SNRZ_Zones.mq5           # Indicator برای نمایش S/R Zones
├── Include/
│   └── RiskManagement.mqh       # ماژول مدیریت ریسک
└── README.md                    # این فایل
```

---

## 🚀 نصب و استفاده (Installation)

### 1. کپی فایل ها
- فایل `SNRZ_EA.mq5` را به پوشه `Experts` کپی کنید
- فایل `SNRZ_Zones.mq5` را به پوشه `Indicators` کپی کنید
- فایل `RiskManagement.mqh` را به پوشه `Include` کپی کنید

### 2. Compile کردن
```
File → Open Data Folder
MQL5/Experts/ (یا Indicators/)
کلیک راست → Compile
```

### 3. اضافه کردن به نمودار
```
Toolbars → Navigator
Experts → SNRZ_EA.mq5 (double click)
```

### 4. تنظیمات
```
Inputs tab میں:
- RiskPercentage: 1.0
- FixedLotSize: 0.01
- FirstTargetPips: 50
- TradeSymbols: XAUUSD,BTCUSD
```

---

## 📈 نحوه کار (How It Works)

### 1. Detection Phase
- بوت S/R levels را در آخرین 20 شمعدان تشخیص می‌دهد
- برای تایید، حداقل 2 touch نیاز است (PO2)

### 2. Signal Generation
- **BUY Signal:** قیمت از Resistance فراتر رفته و به Support بازگشته
- **SELL Signal:** قیمت از Support فراتر پایین رفته و به Resistance بازگشته

### 3. Trade Execution
```
Entry → Stop Loss → Target 1 (50 pips) → Target 2 (100 pips)
```

### 4. Risk Management
- Lot: 0.01 (fixed)
- Risk per Trade: 1% of account
- Max Positions: 2 per symbol

---

## ⚙️ پارامترهای تنظیم (Parameters)

| پارامتر | مقدار | توضیح |
|---------|-------|-------|
| RiskPercentage | 1.0% | درصد ریسک |
| FixedLotSize | 0.01 | حجم Lot |
| FirstTargetPips | 50 | تارگت اول |
| SecondTargetPips | 100 | تارگت دوم |
| StopLossPips | 30 | Stop Loss |
| TradeSymbols | XAUUSD,BTCUSD | نمادهای ترید |
| MaxOpenPositions | 2 | حد اکثر معاملات باز |
| ShowDebug | true | نمایش اطلاعات debug |

---

## 🔧 بهینه سازی (Optimization)

### برای XAUUSD (طلا)
```
Timeframe: H1 (1 Hour)
Lookback: 50 bars
SL: 30 pips
TP1: 50 pips
```

### برای Bitcoin
```
Timeframe: H4 (4 Hour)
Lookback: 50 bars
SL: 30 pips (تطبیق شده برای Crypto)
TP1: 50 pips
```

---

## 📊 مثال مصور

```
Price Chart:

        ██ RESISTANCE (PO2 Valid)
        ██
        ██ ← قیمت از اینجا خارج شده
        ██
    ════════ Zone Box (S/R Area)
        ██
        ██ ← قیمت برای RBS Breakout منتظر
        ██ SUPPORT (PO2 Valid)
        ██
```

---

## ⚠️ نکات مهم (Important Notes)

1. **Test در Demo Account ابتدا** - قبل از Real Account
2. **اطلاعات Debug را بررسی کنید** - Experts tab میں
3. **Risk Management اهم ترین است** - هیچگاه 1% بیش‌تر ریسک نکنید
4. **Back Testing کنید** - استراتژی را تست کنید

---

## 🐛 حل مشکلات (Troubleshooting)

### مشکل: بوت سیگنال نمی‌دهد
**حل:** 
- Bars کافی (حداقل 50) منتظر بمانید
- ShowDebug را true کنید
- Experts tab را بررسی کنید

### مشکل: Error دریافت می‌کنید
**حل:**
- MT5 را restart کنید
- Account credentials را بررسی کنید
- Permissions را چک کنید

### مشکل: Lot size خیلی بزرگ/کوچک است
**حل:**
- UseAutoLot را false کنید
- FixedLotSize را تنظیم کنید
- یا UseAutoLot را true کنید برای خودکار

---

## 📞 پشتیبانی (Support)

برای سوالات و مشکلات:
- Email: support@snrztrading.com
- Website: https://snrztrading.com

---

## 📜 لایسنس (License)

STNRZ Bot MT5 © 2026 - All Rights Reserved

---

**ورژن:** 1.0  
**تاریخ:** July 2026  
**نویسنده:** SNRZ Team
