# تنظیمات SNRZ Bot - Configuration Guide

## 🎯 تنظیمات پیش فرض (Default Configuration)

### XAUUSD (طلا) 
```
EA_Name: SNRZ Bot v1.0
RiskPercentage: 1.0%
FixedLotSize: 0.01
FirstTargetPips: 50
SecondTargetPips: 100
StopLossPips: 30
MaxOpenPositions: 2
TradeSymbols: XAUUSD,BTCUSD
```

### Bitcoin (BTCUSD)
```
Timeframe: H4 (توجیز شده)
RiskPercentage: 1.0%
FixedLotSize: 0.01
FirstTargetPips: 50
StopLossPips: 30 (تنظیم شده برای Volatility)
```

---

## ⚙️ Advanced Settings

### اگر می خواهید Lot را خودکار حساب کنید:
```
UseAutoLot: true
RiskPercentage: 1.0 (پایه برای محاسبه)
```

### اگر می خواهید Lot ثابت استفاده کنید:
```
UseAutoLot: false
FixedLotSize: 0.01
```

### برای دیباگ و نظارت:
```
ShowDebug: true (برای دیدن جزئیات در Expert tab)
```

---

## 📊 تنظیمات بر اساس استراتژی SNRZ

### 1. Support & Resistance Detection
- LookbackBars: 50 (آخرین 50 شمعدان)
- MinimumTouches: 2 (PO2 - Power of 2)

### 2. Entry Conditions
- **BUY**: Price > Resistance + Pullback to Support
- **SELL**: Price < Support + Pullback to Resistance

### 3. Exit Strategy
- Target 1: 50 pips (نیمی از position بسته می شود)
- Target 2: 100 pips (باقی مانده بسته می شود)
- Stop Loss: 30 pips (Loss محدود می شود)

---

## 🔄 Multi-Symbol Configuration

```
TradeSymbols: XAUUSD,BTCUSD
```

بوت به صورت خودکار:
- دو نماد را نظارت می کند
- برای هر نماد سیگنال تولید می کند
- حد اکثر 2 معاملە باز در هر نماد نگاه می دارد

---

## 💾 ذخیره تنظیمات برای Profile مختلف

### Profile 1: Conservative (محافظه کارانه)
```
RiskPercentage: 0.5%
FixedLotSize: 0.001
FirstTargetPips: 30
StopLossPips: 20
MaxOpenPositions: 1
```

### Profile 2: Aggressive (پرتجرش)
```
RiskPercentage: 2.0%
FixedLotSize: 0.05
FirstTargetPips: 100
StopLossPips: 50
MaxOpenPositions: 3
```

### Profile 3: Balanced (متوازن - پیشنهاد شده)
```
RiskPercentage: 1.0%
FixedLotSize: 0.01
FirstTargetPips: 50
StopLossPips: 30
MaxOpenPositions: 2
```

---

## ⏰ تنظیمات بر اساس Timeframe

### M5 (5 Minute)
```
Bars: 50
TP1: 30 pips
SL: 15 pips
```

### H1 (1 Hour) - پیشنهاد شده برای XAUUSD
```
Bars: 50
TP1: 50 pips
SL: 30 pips
زمان بهینه: 24 ساعت
```

### H4 (4 Hour) - پیشنهاد شده برای Bitcoin
```
Bars: 50
TP1: 50 pips (تطبیق شده)
SL: 30 pips
زمان بهینه: 2-3 روز
```

### Daily
```
Bars: 50
TP1: 100 pips
SL: 50 pips
```

---

## 🔐 Account Settings

### برای Account کوچک (1000$ - 5000$)
```
FixedLotSize: 0.001 - 0.01
RiskPercentage: 0.5% - 1.0%
MaxOpenPositions: 1 - 2
```

### برای Account متوسط (5000$ - 50000$)
```
FixedLotSize: 0.01 - 0.1
RiskPercentage: 1.0% - 2.0%
MaxOpenPositions: 2 - 3
```

### برای Account بزرگ (50000$+)
```
FixedLotSize: 0.1 - 1.0
RiskPercentage: 1.0% - 3.0%
MaxOpenPositions: 3 - 5
```

---

## ✅ Checklist قبل از شروع

- [ ] MT5 به روز شده است
- [ ] Internet Connection پایدار است
- [ ] Account Demo یا Real انتخاب شده است
- [ ] Symbols نمایش داده می شوند (Market Watch)
- [ ] EA permissions فعال شده اند
- [ ] Optimization تکمیل شده است
- [ ] تنظیمات برای استراتژی شما انتخاب شده اند

---

## 🧪 Testing

### Step 1: Demo Account Testing
```
1. Demo Account را باز کنید
2. EA را اضافه کنید
3. 2-3 هفته نظارت کنید
4. نتایج را تحلیل کنید
```

### Step 2: Backtesting
```
Tools → Strategy Tester
Expert: SNRZ_EA.mq5
Symbol: XAUUSD
Period: H1
Start: 1 ماه پیش
End: امروز
```

### Step 3: Real Account (اختیاری)
```
- کم شروع کنید
- Daily performance بررسی کنید
- Logs را چک کنید
```

---

## 📞 نیاز به کمک؟

برای مشاوره تنظیمات بهتر:
1. Performance logs را جمع کنید
2. Account balance را بررسی کنید
3. بازار شرایط را تحلیل کنید
4. پشتیبانی تماس بگیرید
