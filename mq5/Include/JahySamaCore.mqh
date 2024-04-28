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

void ComputeExtremes(
  const bool objDelete,
  const int index,
  const double &ma5Highs[],
  const double &ma5Lows[],
  const double &upperBands[],
  const double &lowerBands[],
  int &highExtremeIndices[],
  int &lowExtremeIndices[]
) {
  ComputeHighExtremes(objDelete, index, ma5Highs, upperBands, highExtremeIndices);
  ComputeLowExtremes(objDelete, index, ma5Lows, lowerBands, lowExtremeIndices);
}

void ComputeHighExtremes(
  const bool objDelete,
  const int index,
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
      if (objDelete) {
        ObjectDelete(ChartID(), "MA5 High Extreme " + (string)i);
      }
      highExtremeIndices[i] = -1;
    }
  }
}

void ComputeLowExtremes(
  const bool objDelete,
  const int index,
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
      if (objDelete) {
        ObjectDelete(ChartID(), "MA5 Low Extreme " + (string)i);
      }
      lowExtremeIndices[i] = -1;
    }
  }
}

void ComputeUpTpwajib(
  const bool objDelete,
  const int index,
  int &indices[],
  const int &extremeHighIndices[],
  const int &mhvUpIndices[],
  const double &lowest[],
  const double &low[],
  const double &close[],
  const double &open[]
) {
  indices[index] = -1;
  int lastExtremeHigh = LastNonNegative(extremeHighIndices, index);
  int lastMhv = LastNonNegative(mhvUpIndices, index);

  // If there is no extreme or mhv, then skip.
  if (lastExtremeHigh < 0 || lastMhv < 0) return;

  // If there is no printed MHV, skip computation.
  if (lastExtremeHigh > lastMhv) return;

  // If there's none, then let's continue finding tpw
  int tpwCandidate = FindUpTpwCandidate(low, close, open, lowest, lastExtremeHigh, lastMhv);
  if (tpwCandidate > -1) {
    for (int i = index; i >= lastExtremeHigh; i--) {
      if (tpwCandidate == i) {
        indices[i] = tpwCandidate;
      } else {
        if (objDelete) {
          ObjectDelete(ChartID(), "TPW (Up) " + (string)i);
        }
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
  const bool objDelete,
  const int index,
  int &indices[],
  const int &extremeHighIndices[],
  const int &csmBuyIndices[],
  const double &topBb[],
  const double &low[],
  const double &close[],
  const double &open[]
) {
  indices[index] = -1;
  int lastExtremeHigh = LastNonNegative(extremeHighIndices, index);
  int lastCsmBuy = LastNonNegative(csmBuyIndices, index);

  // If lastExtremeHigh is equal to index, then skip.
  if (lastExtremeHigh == index) return;

  // If there is no extreme or mhv, then skip.
  if (lastExtremeHigh < 0 || lastExtremeHigh < 0) return;

  // If there is CSM Buy after extreme, then we skip finding MHV.
  if (lastCsmBuy >= lastExtremeHigh) return;

  // Find MHV
  int highestIndex = -1;
  for (int i = lastExtremeHigh + 1; i <= index; i++) {
    // Delete duplicate MHVs
    if (objDelete) {
      ObjectDelete(ChartID(), "MHV (Up) " + (string)i);
    }

    // Clear MHV within the range
    indices[i] = -1;

    // Set default value for highestIndex
    highestIndex = highestIndex < 0 ? i : highestIndex;

    // If close is below top bollinger band, then it's an MHV
    if (topBb[i] > close[i]) {

      // Find the highest MHV
      if (close[i] > close[highestIndex]) {
        highestIndex = i;
      }
    };
  }

  // Set the final MHV from EXT setup
  indices[highestIndex] = highestIndex;
}

void ComputeCSM(
  const int index,
  const double &topBb[],
  const double &lowBb[],
  const double &close[],
  const double &open[],
  int &csmBuyIndices[],
  int &csmBuyFakeoutIndices[],
  int &csmSellIndices[],
  int &csmSellFakeoutIndices[]
) {
  ComputeCSMBuy(index, topBb, close, open, csmBuyIndices, csmBuyFakeoutIndices);
  ComputeCSMSell(index, lowBb, close, open, csmSellIndices, csmSellFakeoutIndices);
}

void ComputeCSMBuy(
  const int index,
  const double &topBb[],
  const double &close[],
  const double &open[],
  int &indices[],
  int &indexFakeouts[]
) {
  indexFakeouts[index] = -1;
  const bool closeAboveBb = close[index] > topBb[index];
  const bool candleIsGreen = close[index] > open[index];
  const bool closeBelowBb = close[index] < topBb[index];
  const bool candleIsRed = close[index] < open[index];
  const bool isCsm = closeAboveBb && candleIsGreen;
  indices[index] = isCsm ? index : -1;
  if (index > 0) {
    const int i = index - 1;
    const bool isPreviousCsm = indices[i] > -1;
    const bool isFakeout = candleIsRed && closeBelowBb && isPreviousCsm;
    if (isFakeout) {
      indexFakeouts[i] = indices[i];
      indices[i] = -1;
      return;
    }
  }
  if (index > 1) {
    const int i = index - 2;
    const bool isPreviousCandleRed = close[index - 1] < open[index - 1];
    const bool isPreviousCsm = indices[i] > -1;
    const bool isFakeout = isPreviousCandleRed && candleIsRed && closeBelowBb && isPreviousCsm;
    if (isFakeout) {
      indexFakeouts[i] = indices[i];
      indices[i] = -1;
      return;
    }
  }
  const int lastFakeoutIndex = LastNonNegative(indexFakeouts, index);
  if (lastFakeoutIndex > -1) {
    if (close[index] > close[lastFakeoutIndex]) {
      indices[lastFakeoutIndex] = lastFakeoutIndex;
      indexFakeouts[lastFakeoutIndex] = -1;
    }
  }
}

void ComputeCSMSell(
  const int index,
  const double &lowBb[],
  const double &close[],
  const double &open[],
  int &indices[],
  int &indexFakeouts[]
) {
  indexFakeouts[index] = -1;
  const bool closeBelowBB = close[index] < lowBb[index];
  const bool candleIsRed = close[index] < open[index];
  const bool closeAboveBB = close[index] > lowBb[index];
  const bool candleIsGreen = close[index] > open[index];
  const bool isCsm = closeBelowBB && candleIsRed;
  indices[index] = isCsm ? index : -1;

  if (index > 0) {
    const int i = index - 1;
    const bool isPreviousCsm = indices[i] > -1;
    const bool isFakeout = candleIsGreen && closeAboveBB && isPreviousCsm;
    if (isFakeout) {
      indexFakeouts[i] = indices[i];
      indices[i] = -1;
      return;
    }
  }

  if (index > 1) {
    const int i = index - 2;
    const bool isPreviousCandleGreen = close[index - 1] > open[index - 1];
    const bool isPreviousCsm = indices[i] > -1;
    const bool isFakeout = isPreviousCandleGreen && candleIsRed && closeAboveBB && isPreviousCsm;
    if (isFakeout) {
      indexFakeouts[i] = indices[i];
      indices[i] = -1;
      return;
    }
  }

  if (index > 1) {
    const int i = index - 2;
    const bool isPreviousCandleRed = close[index - 1] < open[index - 1];
    const bool isPreviousCsm = indices[i] > -1;
    const bool isFakeout = isPreviousCandleRed && candleIsRed && closeAboveBB && isPreviousCsm;
    if (isFakeout) {
      indexFakeouts[i] = indices[i];
      indices[i] = -1;
      return;
    }
  }
  const int lastFakeoutIndex = LastNonNegative(indexFakeouts, index);
  if (lastFakeoutIndex > -1) {
    if (close[index] < close[lastFakeoutIndex]) {
      indices[lastFakeoutIndex] = lastFakeoutIndex;
      indexFakeouts[lastFakeoutIndex] = -1;
    }
  }
}

void ComputeCSASell(
  const bool objDelete,
  const int index,
  const int &mhvIndices[],
  const int &extremeHighIndices[],
  const int &csmBuyIndices[],
  const double &topBb[],
  const double &ma5High[],
  const double &ma10High[],
  const double &close[],
  const double &open[],
  int &indices[]
) {
  indices[index] = -1;
  int lastExtremeHigh = LastNonNegative(extremeHighIndices, index);
  int lastMhv = LastNonNegative(mhvIndices, index);
  int lastCsmBuy = LastNonNegative(csmBuyIndices, index);
  if (lastExtremeHigh < 0 || lastMhv < 0) return;
  if (lastCsmBuy >= lastExtremeHigh) return;
  lastCsmBuy = -1;
  if (index > lastMhv) {
    for (int i = lastExtremeHigh; i <= index; i++) {
      if (i > lastMhv) {
        const bool isCandleRed = open[i] > close[i];
        const bool isCloseBelowMA5 = close[i] < ma5High[i];
        const bool isCloseBelowMA10 = close[i] < ma10High[i];
        const bool isCloseBelowMAHigh = isCloseBelowMA5 || isCloseBelowMA10;
        const bool isOpenAboveMA5 = open[i] > ma5High[i];
        const bool isOpenAboveMA10 = open[i] > ma10High[i];
        const bool isOpenAboveMAHigh = isOpenAboveMA5 || isOpenAboveMA10;
        const bool conditionMatches = isCandleRed && isCloseBelowMAHigh && isOpenAboveMAHigh;
        if (conditionMatches) {
          indices[i] = i;
          break;
        } else {
          indices[i] = -1;
          if (objDelete) {
            ObjectDelete(ChartID(), "CSA Sell " + (string)i);
          }
        }
      } else {
        if (objDelete) {
          ObjectDelete(ChartID(), "CSA Sell " + (string)i);
        }
        indices[i] = -1;
      }
    }
  }
}

void RenderObjects(
  int offset,
  const int max,
  const datetime &time[],
  const double &open[],
  const double &high[],
  const double &low[],
  const double &close[],
  const double &ma5Highs[],
  const double &ma5Lows[],
  const double &ma10Highs[],
  const double &ma10Lows[],
  const int &csmBuyIndices[],
  const int &csmBuyFakeoutIndices[],
  const int &csmSellIndices[],
  const int &csmSellFakeoutIndices[],
  const int &extremeHighIndices[],
  const int &extremeLowIndices[],
  const int &mhvUpIndices[],
  const int &upTpwIndices[],
  const int &csaBuyIndices[],
  const int &cskBuyIndices[],
  const int &csaSellIndices[],
  const int &cskSellIndices[]
) {
  offset = offset < 0 ? 0 : offset;
  for (int index = offset; index < max; index++) {
    if (csmBuyIndices[index] > -1) {
      RenderObject("CSM Buy #", index, time[index], high[index], C'190,255,222', 2, 233);
    }
    if (csmBuyFakeoutIndices[index] > -1) {
      RenderObject("CSM Buy Fakeout!! #", index, time[index], high[index], C'0,179,92', 4, 233);
    }
    if (csmSellIndices[index] > -1) {
      RenderObject("CSM Sell #", index, time[index], low[index], C'245,185,199', 2, 233);
    }
    if (csmSellFakeoutIndices[index] > -1) {
      RenderObject("CSM Sell Fakeout!! #", index, time[index], low[index], C'179,42,0', 4, 233);
    }
    if (extremeHighIndices[index] > -1) {
      RenderObject("MA5 High Extreme #", index, time[index], ma5Highs[index], C'0,255,123', 4, 233);
    }
    if (extremeLowIndices[index] > -1) {
      RenderObject("MA5 Low Extreme #", index, time[index], ma5Lows[index], C'255,68,0', 4, 233);
    }
    if (mhvUpIndices[index] > -1) {
      RenderObject("MHV (Up) #", index, time[index], close[index], C'0,255,123', 1, 233);
    }
    if (upTpwIndices[index] > -1) {
      double price = ma5Lows[index] < ma10Lows[index] ? ma5Lows[index] : ma10Lows[index];
      RenderObject("TPW (Up) #", index, time[index], price, C'0,255,123', 1, 233);
    }
    // if (csaBuyIndices[index] > -1) {
    //   RenderObject("CSA Buy #", index, time[index], close[index], C'0,255,123', 1, 233);
    // }
    // if (cskBuyIndices[index] > -1) {
    //   RenderObject("CSK Buy #", index, time[index], close[index], C'0,255,123', 1, 233);
    // }
    if (csaSellIndices[index] > -1) {
      RenderObject("CSA Sell #", index, time[index], close[index], C'255,68,0', 1, 233);
    }
    // if (cskSellIndices[index] > -1) {
    //   RenderObject("CSK Sell #", index, time[index], close[index], C'255,68,0', 1, 233);
    // }
  }
}

void RenderObject(string label, int id, const datetime time, const double price, const int clrColor, const int width, const int arrowCode) {
  string objName = label + (string)id;
  ObjectCreate(ChartID(), objName, OBJ_ARROW, 0, time, price);
  ObjectSetInteger(ChartID(), objName, OBJPROP_ARROWCODE, arrowCode);
  ObjectSetInteger(ChartID(), objName, OBJPROP_WIDTH, width);
  ObjectSetInteger(ChartID(), objName, OBJPROP_COLOR, clrColor);
}

void DeleteMA5ExtremeObjects() {
  for (int i = ObjectsTotal(ChartID(), 0, OBJ_ARROW) - 1; i >= 0; i--) {
    string name = ObjectName(ChartID(), i, 0, OBJ_ARROW);
    if (StringFind(name, "CSM Buy ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "CSM Buy Fakeout!! ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "CSM Sell ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "CSM Sell Fakeout!! ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "MA5 High Extreme ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "MA5 Low Extreme ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "MHV (Up) ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "TPW (Up) ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "CSA Sell ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "CSK Sell ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "CSA Buy ") != -1) {
      ObjectDelete(ChartID(), name);
    }
    if (StringFind(name, "CSK Buy ") != -1) {
      ObjectDelete(ChartID(), name);
    }
  }
}

int LastNonNegative(const int &integers[], const int startIndex) {
  int length = ArraySize(integers);
  for (int i = startIndex; i >= 0; i--) {
    if (integers[i] > -1) {
      return integers[i];
    }
  }
  return -1;
}

void ArrayResizeWithDefault(string name, int &array[], int newSize, int defaultValue) {
  const int oldSize = ArraySize(array);
  ArrayResize(array, newSize);
  if (newSize > oldSize) {
    for (int i = oldSize; i < newSize; i++) {
      array[i] = defaultValue;
    }
  }
}
