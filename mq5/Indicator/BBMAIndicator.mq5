//+------------------------------------------------------------------+
//|                                               BBMA Indicator.mq5 |
//|                                                          ghabxph |
//|                         https://github.com/ghabxph/jahy-sama.git |
//+------------------------------------------------------------------+
#property copyright "ghabxph"
#property link      "https://github.com/ghabxph/jahy-sama.git"
#property version   "1.00"
#include <JahySamaCore.mqh>
#include <ChartObjects/ChartObjectsArrows.mqh>
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

CChartObjectArrowDown MA5HighExtremes;
int MA5HighExtremeIndices[];
int MA5LowExtremeIndices[];
int UpTpwajibIndices[];
int DownTpwajibIndices[];

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
  const int MAX_LIMIT = 3000;
  double previousEma50 = close[0];
  ArrayResize(MA5HighExtremeIndices, rates_total);
  ArrayResize(MA5LowExtremeIndices, rates_total);
  ArrayResize(UpTpwajibIndices, rates_total);
  ArrayResize(DownTpwajibIndices, rates_total);
  if (prev_calculated == 0) {
    for (int index = 1; index < rates_total; index++) {
      BBMA(
        index, high, low, close,
        EMA50Buffer[index], previousEma50,
        MA5HighBuffer[index], MA6HighBuffer[index], MA7HighBuffer[index], MA8HighBuffer[index], MA9HighBuffer[index], MA10HighBuffer[index],
        MA5LowBuffer[index], MA6LowBuffer[index], MA7LowBuffer[index], MA8LowBuffer[index], MA9LowBuffer[index], MA10LowBuffer[index],
        TopBBBuffer[index], MidBBBuffer[index], LowBBBuffer[index]
      );
      int limit = rates_total - MAX_LIMIT;
      if (index >= limit) {
        ComputeExtremes(
          index,
          ChartID(),
          time,
          MA5HighBuffer,
          MA5LowBuffer,
          TopBBBuffer,
          LowBBBuffer,
          MA5HighExtremeIndices,
          MA5LowExtremeIndices
        );
        ComputeUpTpwajib(index, UpTpwajibIndices, ChartID(), time[index], MA5HighExtremeIndices, MA5LowExtremeIndices, low, close, open);
      }
    }
  }
  int index = rates_total - 1;
  previousEma50 = EMA50Buffer[index - 1];
  BBMA(
    index, high, low, close,
    EMA50Buffer[index], previousEma50,
    MA5HighBuffer[index], MA6HighBuffer[index], MA7HighBuffer[index], MA8HighBuffer[index], MA9HighBuffer[index], MA10HighBuffer[index],
    MA5LowBuffer[index], MA6LowBuffer[index], MA7LowBuffer[index], MA8LowBuffer[index], MA9LowBuffer[index], MA10LowBuffer[index],
    TopBBBuffer[index], MidBBBuffer[index], LowBBBuffer[index]
  );
  ComputeExtremes(
    index,
    ChartID(),
    time,
    MA5HighBuffer,
    MA5LowBuffer,
    TopBBBuffer,
    LowBBBuffer,
    MA5HighExtremeIndices,
    MA5LowExtremeIndices
  );
  ComputeUpTpwajib(index, UpTpwajibIndices, ChartID(), time[index], MA5HighExtremeIndices, MA5LowExtremeIndices, low, close, open);

  RenderObjects(
    rates_total - MAX_LIMIT,
    rates_total,
    time,
    open,
    high,
    low,
    close,
    MA5HighBuffer,
    MA5LowBuffer,
    MA5HighExtremeIndices,
    MA5LowExtremeIndices,
    UpTpwajibIndices
  );
  return(rates_total);
}

//+------------------------------------------------------------------+
//| Indicator deinitialization function                              |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
  DeleteMA5ExtremeObjects(ChartID());
}