//+------------------------------------------------------------------+
//|                                               BBMA Indicator.mq5 |
//|                                                          ghabxph |
//|                         https://github.com/ghabxph/jahy-sama.git |
//+------------------------------------------------------------------+
#property copyright "ghabxph"
#property link      "https://github.com/ghabxph/jahy-sama.git"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 DeepSkyBlue
#property indicator_color2 Green
#property indicator_color3 DarkGreen
#property indicator_color4 Red
#property indicator_color5 DarkOrange
#property indicator_color6 DarkGray
#property indicator_width1 3 // Thick for EMA 50
#property indicator_width2 1 // Thin for MA High 5
#property indicator_width3 2 // Thick for MA High 10
#property indicator_width4 1 // Thin for MA Low 5
#property indicator_width5 2 // Thick for MA Low 10
#property indicator_width6 1 // Bollinger Bands

//--- indicator buffers
double bbUpperBuffer[];
double bbLowerBuffer[];
double maHigh5Buffer[];
double maHigh10Buffer[];
double maLow5Buffer[];
double maLow10Buffer[];
double emaBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0,emaBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,maHigh5Buffer,INDICATOR_DATA);
   SetIndexBuffer(2,maHigh10Buffer,INDICATOR_DATA);
   SetIndexBuffer(3,maLow5Buffer,INDICATOR_DATA);
   SetIndexBuffer(4,maLow10Buffer,INDICATOR_DATA);
   SetIndexBuffer(5,bbUpperBuffer,INDICATOR_DATA);
   SetIndexBuffer(6,bbLowerBuffer,INDICATOR_DATA);

   IndicatorSetString(INDICATOR_SHORTNAME, "BBMA Indicator");
   PlotIndexSetString(0, PLOT_LABEL, "EMA 50");
   PlotIndexSetString(1, PLOT_LABEL, "MA High 5");
   PlotIndexSetString(2, PLOT_LABEL, "MA High 10");
   PlotIndexSetString(3, PLOT_LABEL, "MA Low 5");
   PlotIndexSetString(4, PLOT_LABEL, "MA Low 10");
   PlotIndexSetString(5, PLOT_LABEL, "Bollinger Upper");
   PlotIndexSetString(6, PLOT_LABEL, "Bollinger Lower");
   return(INIT_SUCCEEDED);
  }
 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
    // Calculate EMA
   for(int i = 0; i < rates_total; i++)
     {
      emaBuffer[i] = iMA(NULL, PERIOD_CURRENT, 50, 0, MODE_EMA, PRICE_CLOSE);
      maHigh5Buffer[i] = iMA(NULL, PERIOD_CURRENT, 5, 0, MODE_SMA, PRICE_HIGH);
      maHigh10Buffer[i] = iMA(NULL, PERIOD_CURRENT, 10, 0, MODE_SMA, PRICE_HIGH);
      maLow5Buffer[i] = iMA(NULL, PERIOD_CURRENT, 5, 0, MODE_SMA, PRICE_LOW);
      maLow10Buffer[i] = iMA(NULL, PERIOD_CURRENT, 10, 0, MODE_SMA, PRICE_LOW);
     }

   // Calculate Bollinger Bands
   for(int i = 0; i < rates_total; i++)
     {
      bbUpperBuffer[i] = iBands(NULL, PERIOD_CURRENT, 20, 0, 2, 1);
      bbUpperBuffer[i] = iBands(NULL, PERIOD_CURRENT, 20, 0, 2, 2);
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
