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

void deleteMA5ExtremeObjects(long chart_id) {
  for (int i = ObjectsTotal(chart_id, 0, OBJ_ARROW) - 1; i >= 0; i--) {
    string name = ObjectName(chart_id, i, 0, OBJ_ARROW);
    if (StringFind(name, "MA5 High Extreme ") != -1) {
      ObjectDelete(chart_id, name);
    }
    if (StringFind(name, "MA5 Low Extreme ") != -1) {
      ObjectDelete(chart_id, name);
    }
    if (StringFind(name, "TPW (Up) ") != -1) {
      ObjectDelete(chart_id, name);
    }
  }
}

void MarkMA5HighExtreme(const int index, int &indices[], long chart_id, const datetime time, const double &ma5Highs[], const double &upperBands[]) {
  string objName = "MA5 High Extreme " + (string)index;
  indices[index] = -1;
  if (ma5Highs[index] > upperBands[index]) {
    indices[index] = index;
    ObjectCreate(chart_id, objName, OBJ_ARROW, 0, time, ma5Highs[index]);
    ObjectSetInteger(chart_id, objName, OBJPROP_ARROWCODE, 233);
    ObjectSetInteger(chart_id, objName, OBJPROP_WIDTH, 3);
    ObjectSetInteger(chart_id, objName, OBJPROP_COLOR, clrCyan);
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
      ObjectDelete(chart_id, "MA5 High Extreme " + (string)indices[i]);
      indices[i] = -1;
    }
  }
}

void MarkMA5LowExtreme(const int index, int &indices[], long chart_id, const datetime time, const double &ma5Lows[], const double &lowerBands[]) {
  string objName = "MA5 Low Extreme " + (string)index;
  if (ma5Lows[index] < lowerBands[index]) {
    indices[index] = index;
    ObjectCreate(chart_id, objName, OBJ_ARROW, 0, time, ma5Lows[index]);
    ObjectSetInteger(chart_id, objName, OBJPROP_ARROWCODE, 233);
    ObjectSetInteger(chart_id, objName, OBJPROP_WIDTH, 3);
    ObjectSetInteger(chart_id, objName, OBJPROP_COLOR, C'255,98,0');
  } else {
    indices[index] = -1;
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
      ObjectDelete(chart_id, "MA5 Low Extreme " + (string)indices[i]);
      indices[i] = -1;
    }
  }
}

void MarkUpTpwajib(
  const int index,
  int &indices[],
  long chart_id,
  const datetime time,
  const int &extremeHighIndices[],
  const int &extremeLowIndices[],
  const double &low[],
  const double &close[],
  const double &open[]
) {
  indices[index] = -1;
  int lastExtremeHigh = lastNonNegative(extremeHighIndices, index);
  int lastExtremeLow = lastNonNegative(extremeLowIndices, index);

  // Check if there's extreme low after extreme high. It means that we have ranging market and we'll disregard tp wajib here.
  if (lastExtremeHigh < lastExtremeLow) {
    return;
  }

  // If there's none, then let's continue finding tpw
  int tpwCandidate = findRedMinIndex(low, close, open, lastExtremeHigh);
  for (int i = index; i >= lastExtremeHigh; i--) {
    if (tpwCandidate == i) {
      indices[i] = tpwCandidate;
    } else {
      indices[i] = -1;
    }
  }
}

void renderObject(long chart_id, string label, int id, const datetime time, const double price, const int clrColor, const int width, const int arrowCode) {
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

int findRedMinIndex(const double &low[], const double &close[], const double &open[], const int index) {
  int length = ArraySize(low);
  double min = low[length - 1];
  int result = index;
  for (int i = length - 1; i >= index; i--) {
    const bool isRedOrDoji = open[i] >= close[i];
    if (min > low[i] && isRedOrDoji) {
      min = low[i];
      result = i;
    }
  }
  return result;
}