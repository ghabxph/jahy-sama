//+------------------------------------------------------------------+
//|                                                 JahySamaCore.mqh |
//|                                                          ghabxph |
//|                         https://github.com/ghabxph/jahy-sama.git |
//+------------------------------------------------------------------+
#property copyright "ghabxph"
#property link      "https://github.com/ghabxph/jahy-sama.git"

#include <ChartObjects/ChartObjectsArrows.mqh>

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

void DeleteMA5ExtremeObjects(long chart_id) {
  for (int i = ObjectsTotal(chart_id, 0, OBJ_ARROW) - 1; i >= 0; i--) {
    string name = ObjectName(chart_id, i, 0, OBJ_ARROW);
    if (StringFind(name, "MA5 High Extreme ") != -1) {
      ObjectDelete(chart_id, name);
    }
    if (StringFind(name, "MA5 Low Extreme ") != -1) {
      ObjectDelete(chart_id, name);
    }
    if (StringFind(name, "MHV (Up) ") != -1) {
      ObjectDelete(chart_id, name);
    }
    if (StringFind(name, "TPW (Up) ") != -1) {
      ObjectDelete(chart_id, name);
    }
  }
}

void ComputeExtremes(
  const int index,
  long chart_id,
  const datetime &time[],
  const double &ma5Highs[],
  const double &ma5Lows[],
  const double &upperBands[],
  const double &lowerBands[],
  int &highExtremeIndices[],
  int &lowExtremeIndices[]
) {
  ComputeHighExtremes(index, chart_id, time, ma5Highs, upperBands, highExtremeIndices);
  ComputeLowExtremes(index, chart_id, time, ma5Lows, lowerBands, lowExtremeIndices);
}

void ComputeHighExtremes(
  const int index,
  long chart_id,
  const datetime &time[],
  const double &ma5Highs[],
  const double &upperBands[],
  int &highExtremeIndices[]
) {
  highExtremeIndices[index] = -1;
  if (ma5Highs[index] > upperBands[index]) {
    highExtremeIndices[index] = index;
  }
  double highest = 0;
  for (int i = index; i >= 0; i--) {
    bool isExtreme = ma5Highs[i] > upperBands[i];
    if (!isExtreme) break;
    if (ma5Highs[i] > highest) {
      highest = ma5Highs[i];
    }
  }
  for (int i = index; i >= 0; i--) {
    bool isExtreme = ma5Highs[i] > upperBands[i];
    if (!isExtreme) break;
    if (ma5Highs[i] != highest) {
      highExtremeIndices[i] = -1;
    }
  }
}

void ComputeLowExtremes(
  const int index,
  long chart_id,
  const datetime &time[],
  const double &ma5Lows[],
  const double &lowerBands[],
  int &lowExtremeIndices[]
) {
  if (ma5Lows[index] < lowerBands[index]) {
    lowExtremeIndices[index] = index;
  } else {
    lowExtremeIndices[index] = -1;
  }
  double lowest = -1;
  for (int i = index; i >= 0; i--) {
    bool isExtreme = ma5Lows[i] < lowerBands[i];
    if (!isExtreme) break;
    if (ma5Lows[i] < lowest || lowest == -1) {
      lowest = ma5Lows[i];
    }
  }
  for (int i = index; i >= 0; i--) {
    bool isExtreme = ma5Lows[i] < lowerBands[i];
    if (!isExtreme) break;
    if (ma5Lows[i] != lowest) {
      lowExtremeIndices[i] = -1;
    }
  }
}

void ComputeUpTpwajib(
  const int index,
  int &indices[],
  long chart_id,
  const datetime time,
  const int &extremeHighIndices[],
  const int &mhvUpIndices[],
  const double &lowest[],
  const double &low[],
  const double &close[],
  const double &open[]
) {
  indices[index] = -1;
  int lastExtremeHigh = lastNonNegative(extremeHighIndices, index);
  int lastMhv = lastNonNegative(mhvUpIndices, index);

  // If there is no printed MHV, skip computation.
  if (lastExtremeHigh > lastMhv) return;

  // If there's none, then let's continue finding tpw
  int tpwCandidate = FindUpTpwCandidate(low, close, open, lowest, lastExtremeHigh, lastMhv);
  if (tpwCandidate > -1) {
    for (int i = index; i >= lastExtremeHigh; i--) {
      if (tpwCandidate == i) {
        indices[i] = tpwCandidate;
      } else {
        indices[i] = -1;
      }
    }
  }
}

int FindUpTpwCandidate(const double &low[], const double &close[], const double &open[], const double &lowest[], const int lastExtremeHigh, const int lastMhv) {
  double min = low[lastMhv];
  int result = -1;
  for (int i = lastMhv; i >= lastExtremeHigh; i--) {
    const bool isRedOrDoji = open[i] >= close[i];
    const bool closeNotPastLowest = close[i] > lowest[i];
    if (min > low[i] && isRedOrDoji && closeNotPastLowest) {
      min = low[i];
      result = i;
    }
  }
  return result;
}

void ComputeUpMhv(
  const int index,
  int &indices[],
  long chart_id,
  const datetime time,
  const int &extremeHighIndices[],
  const double &topBb[],
  const double &low[],
  const double &close[],
  const double &open[]
) {
  indices[index] = -1;
  int lastExtremeHigh = lastNonNegative(extremeHighIndices, index);

  // If there's none, then let's continue finding tpw
  int mhvCandidate = FindUpMhvCandidate(close, open, topBb, lastExtremeHigh);
  for (int i = index; i >= lastExtremeHigh; i--) {
    if (mhvCandidate == i) {
      indices[i] = mhvCandidate;
    } else {
      indices[i] = -1;
    }
  }
}

int FindUpMhvCandidate(const double &close[], const double &open[], const double &topBb[], const int index) {
  int length = ArraySize(close);
  double highestClose = close[length - 1];
  int result = -1;
  for (int i = length - 1; i >= index; i--) {
    const double closeIsHigher = highestClose < close[i];
    const bool isGreenOrDoji = close[i] >= open[i];
    const bool closeNotPastTopBb = topBb[i] >= close[i];
    if (closeIsHigher && isGreenOrDoji && closeNotPastTopBb) {
      highestClose = close[i];
      result = i;
    }
  }
  return result;
}

void RenderObjects(
  const int offset,
  const int max,
  const datetime &time[],
  const double &open[],
  const double &high[],
  const double &low[],
  const double &close[],
  const double &ma5Highs[],
  const double &ma5Lows[],
  const int &extremeHighIndices[],
  const int &extremeLowIndices[],
  const int &mhvUpIndices[],
  const int &upTpwIndices[]
) {
  for (int index = offset; index < max; index++) {
    if (extremeHighIndices[index] > -1) {
      RenderObject(ChartID(), "MA5 High Extreme ", index, time[index], ma5Highs[index], clrCyan, 3, 233);
    }
    if (extremeLowIndices[index] > -1) {
      RenderObject(ChartID(), "MA5 Low Extreme ", index, time[index], ma5Lows[index], C'255,98,0', 3, 233);
    }
    if (mhvUpIndices[index] > -1) {
      RenderObject(ChartID(), "MHV (Up) ", index, time[index], close[index], C'53,104,255', 2, 233);
    }
    if (upTpwIndices[index] > -1) {
      RenderObject(ChartID(), "TPW (Up) ", index, time[index], close[index], C'53,181,255', 2, 233);
    }
  }
}

void RenderObject(long chart_id, string label, int id, const datetime time, const double price, const int clrColor, const int width, const int arrowCode) {
  string objName = label + (string)id;
  ObjectCreate(chart_id, objName, OBJ_ARROW, 0, time, price);
  ObjectSetInteger(chart_id, objName, OBJPROP_ARROWCODE, arrowCode);
  ObjectSetInteger(chart_id, objName, OBJPROP_WIDTH, width);
  ObjectSetInteger(chart_id, objName, OBJPROP_COLOR, clrColor);
}

int lastNonNegative(const int &integers[], const int startIndex) {
  int length = ArraySize(integers);
  for (int i = startIndex; i >= 0; i--) {
    if (integers[i] > -1) {
      return integers[i];
    }
  }
  return -1;
}
