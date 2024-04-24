//+------------------------------------------------------------------+
//|                                               BBMA Indicator.mq5 |
//|                                                          ghabxph |
//|                         https://github.com/ghabxph/jahy-sama.git |
//+------------------------------------------------------------------+
#property copyright "ghabxph"
#property link      "https://github.com/ghabxph/jahy-sama.git"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 16
#property indicator_plots   16
//--- plot EMA50
#property indicator_label1  "EMA50"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrSkyBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- plot MA5High
#property indicator_label2  "MA5High"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLightGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot MA6High
#property indicator_label3  "MA6High"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrLightGreen
#property indicator_style3  STYLE_DOT
#property indicator_width3  1
//--- plot MA7High
#property indicator_label4  "MA7High"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrLightGreen
#property indicator_style4  STYLE_DOT
#property indicator_width4  1
//--- plot MA8High
#property indicator_label5  "MA8High"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrLightGreen
#property indicator_style5  STYLE_DOT
#property indicator_width5  1
//--- plot MA9High
#property indicator_label6  "MA9High"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrLightGreen
#property indicator_style6  STYLE_DOT
#property indicator_width6  1
//--- plot MA10High
#property indicator_label7  "MA10High"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrDarkGreen
#property indicator_style7  STYLE_SOLID
#property indicator_width7  2
//--- plot MA5Low
#property indicator_label8  "MA5Low"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrRed
#property indicator_style8  STYLE_SOLID
#property indicator_width8  1
//--- plot MA6Low
#property indicator_label9  "MA6Low"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrPink
#property indicator_style9  STYLE_DOT
#property indicator_width9  1
//--- plot MA7Low
#property indicator_label10  "MA7Low"
#property indicator_type10   DRAW_LINE
#property indicator_color10  clrPink
#property indicator_style10  STYLE_DOT
#property indicator_width10  1
//--- plot MA8Low
#property indicator_label11  "MA8Low"
#property indicator_type11   DRAW_LINE
#property indicator_color11  clrPink
#property indicator_style11  STYLE_DOT
#property indicator_width11  1
//--- plot MA9Low
#property indicator_label12  "MA9Low"
#property indicator_type12   DRAW_LINE
#property indicator_color12  clrPink
#property indicator_style12  STYLE_DOT
#property indicator_width12  1
//--- plot MA10Low
#property indicator_label13  "MA10Low"
#property indicator_type13   DRAW_LINE
#property indicator_color13  clrCrimson
#property indicator_style13  STYLE_SOLID
#property indicator_width13  2
//--- plot TopBB
#property indicator_label14  "TopBB"
#property indicator_type14   DRAW_LINE
#property indicator_color14  clrLightSeaGreen
#property indicator_style14  STYLE_SOLID
#property indicator_width14  2
//--- plot MidBB
#property indicator_label15  "MidBB"
#property indicator_type15   DRAW_LINE
#property indicator_color15  clrLightSeaGreen
#property indicator_style15  STYLE_SOLID
#property indicator_width15  1
//--- plot LowBB
#property indicator_label16  "LowBB"
#property indicator_type16   DRAW_LINE
#property indicator_color16  clrLightSeaGreen
#property indicator_style16  STYLE_SOLID
#property indicator_width16  2
//--- indicator buffers
double         EMA50Buffer[];
double         MA5HighBuffer[];
double         MA6HighBuffer[];
double         MA7HighBuffer[];
double         MA8HighBuffer[];
double         MA9HighBuffer[];
double         MA10HighBuffer[];
double         MA5LowBuffer[];
double         MA6LowBuffer[];
double         MA7LowBuffer[];
double         MA8LowBuffer[];
double         MA9LowBuffer[];
double         MA10LowBuffer[];
double         TopBBBuffer[];
double         MidBBBuffer[];
double         LowBBBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
  SetIndexBuffer(0,EMA50Buffer,INDICATOR_DATA);
  SetIndexBuffer(1,MA5HighBuffer,INDICATOR_DATA);
  SetIndexBuffer(2,MA6HighBuffer,INDICATOR_DATA);
  SetIndexBuffer(3,MA7HighBuffer,INDICATOR_DATA);
  SetIndexBuffer(4,MA8HighBuffer,INDICATOR_DATA);
  SetIndexBuffer(5,MA9HighBuffer,INDICATOR_DATA);
  SetIndexBuffer(6,MA10HighBuffer,INDICATOR_DATA);
  SetIndexBuffer(7,MA5LowBuffer,INDICATOR_DATA);
  SetIndexBuffer(8,MA6LowBuffer,INDICATOR_DATA);
  SetIndexBuffer(9,MA7LowBuffer,INDICATOR_DATA);
  SetIndexBuffer(10,MA8LowBuffer,INDICATOR_DATA);
  SetIndexBuffer(11,MA9LowBuffer,INDICATOR_DATA);
  SetIndexBuffer(12,MA10LowBuffer,INDICATOR_DATA);
  SetIndexBuffer(13,TopBBBuffer,INDICATOR_DATA);
  SetIndexBuffer(14,MidBBBuffer,INDICATOR_DATA);
  SetIndexBuffer(15,LowBBBuffer,INDICATOR_DATA);
  return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(
  const int rates_total,
  const int prev_calculated,
  const datetime &time[],
  const double &open[],
  const double &high[],
  const double &low[],
  const double &close[],
  const long &tick_volume[],
  const long &volume[],
  const int &spread[]
) {
  int length = ArraySize(close);
  double previousEma50 = close[0];
  for (int i = 1; i < length; i++) {
    EMA50Buffer[i] = ExponentialMA(i, 50, previousEma50, close);
    previousEma50 = EMA50Buffer[i];
    MidBBBuffer[i] = SimpleMA(i, 20, close);
    MA5HighBuffer[i] = SimpleMA(i, 5, high);
    MA6HighBuffer[i] = SimpleMA(i, 6, high);
    MA7HighBuffer[i] = SimpleMA(i, 7, high);
    MA8HighBuffer[i] = SimpleMA(i, 8, high);
    MA9HighBuffer[i] = SimpleMA(i, 9, high);
    MA10HighBuffer[i] = SimpleMA(i, 10, high);
    MA5LowBuffer[i] = SimpleMA(i, 5, low);
    MA6LowBuffer[i] = SimpleMA(i, 6, low);
    MA7LowBuffer[i] = SimpleMA(i, 7, low);
    MA8LowBuffer[i] = SimpleMA(i, 8, low);
    MA9LowBuffer[i] = SimpleMA(i, 9, low);
    MA10LowBuffer[i] = SimpleMA(i, 10, low);
    BollingerBand(i, 20, 2, close, TopBBBuffer[i], LowBBBuffer[i]);

    BBMA(
      i,
      high,
      low,
      close,
      EMA50Buffer[i],
      previousEma50,
      MA5HighBuffer[i],
      MA6HighBuffer[i],
      MA7HighBuffer[i],
      MA8HighBuffer[i],
      MA9HighBuffer[i],
      MA10HighBuffer[i],
      MA5LowBuffer[i],
      MA6LowBuffer[i],
      MA7LowBuffer[i],
      MA8LowBuffer[i],
      MA9LowBuffer[i],
      MA10LowBuffer[i],
      TopBBBuffer[i],
      MidBBBuffer[i],
      LowBBBuffer[i]
    );
  }
  return(rates_total);
}

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
      result/=period;
    }
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
