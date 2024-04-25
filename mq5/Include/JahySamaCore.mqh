//+------------------------------------------------------------------+
//|                                                 JahySamaCore.mqh |
//|                                                          ghabxph |
//|                         https://github.com/ghabxph/jahy-sama.git |
//+------------------------------------------------------------------+
#property copyright "ghabxph"
#property link      "https://github.com/ghabxph/jahy-sama.git"

//+------------------------------------------------------------------+
//| BBMA                                                             |
//+------------------------------------------------------------------+
void BBMA(
  const int index,
  const double &high[],
  const double &low[], 
  const double &close[],
  double &ema50,
  double &previousEma50,
  double &ma5High,
  double &ma6High,
  double &ma7High,
  double &ma8High,
  double &ma9High,
  double &ma10High,
  double &ma5Low,
  double &ma6Low,
  double &ma7Low,
  double &ma8Low,
  double &ma9Low,
  double &ma10Low,
  double &upperBb,
  double &midBb,
  double &lowerBb
) {
    ema50 = ExponentialMA(index, 50, previousEma50, close);
    previousEma50 = ema50;
    ma5High = SimpleMA(index, 5, high);
    ma6High = SimpleMA(index, 6, high);
    ma7High = SimpleMA(index, 7, high);
    ma8High = SimpleMA(index, 8, high);
    ma9High = SimpleMA(index, 9, high);
    ma10High = SimpleMA(index, 10, high);
    ma5Low = SimpleMA(index, 5, low);
    ma6Low = SimpleMA(index, 6, low);
    ma7Low = SimpleMA(index, 7, low);
    ma8Low = SimpleMA(index, 8, low);
    ma9Low = SimpleMA(index, 9, low);
    ma10Low = SimpleMA(index, 10, low);
    midBb = SimpleMA(index, 20, close);
    BollingerBand(index, 20, 2, close, upperBb, lowerBb);
}


//+------------------------------------------------------------------+
//| Simple Moving Average                                            |
//+------------------------------------------------------------------+
double SimpleMA(const int position,const int period,const double &price[]) {
  double result=0.0;
  if (period>0 && period<=(position+1)) {
    for (int i=0; i<period; i++) {
      result+=price[position-i];
    }
    result/=period;
  }
  return(result);
}
  
 //+------------------------------------------------------------------+
//| Exponential Moving Average                                       |
//+------------------------------------------------------------------+
double ExponentialMA(const int position,const int period,const double prev_value,const double &price[]) {
  double result=0.0;
  if (period>0) {
    double pr=2.0/(period+1.0);
    result=price[position]*pr+prev_value*(1-pr);
  }
  return(result);
}

//+------------------------------------------------------------------+
//| Calculate Bollinger Bands for a single bar using existing SMA    |
//+------------------------------------------------------------------+
void BollingerBand(int index, int maPeriod, double deviation, const double &price[], double &upperBand, double &lowerBand) {
  // Calculate the Simple Moving Average for the current bar
  double sma = SimpleMA(index, maPeriod, price);

  // Calculate standard deviation
  double variance = 0.0;
  for(int j = index; j > index - maPeriod && j >= 0; j--) {
    variance += MathPow(price[j] - sma, 2);
  }
  double stDev = MathSqrt(variance / maPeriod); // Assume full period for simplicity

  // Calculate the upper and lower Bollinger Bands
  upperBand = sma + (deviation * stDev);
  lowerBand = sma - (deviation * stDev);
}
