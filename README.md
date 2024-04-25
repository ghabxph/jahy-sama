# Jahy's Trading Strategy

## Roadmap

* Development of BBMA Indicator
  - [ ] Basic BBMA Indicator (no signals yet)
  - [ ] BBMA Cycle
    - [x] 1. Extreme
    - [ ] 2. TPW
    - [ ] 3. MHV
    - [ ] 4. CSK
    - [ ] 5. Re-entry
    - [ ] 6. CSM
  - [ ] Trending Movement
    - [ ] Re-entry
    - [ ] CSM
  - [ ] Multi-timeframe Signals (Advanced)
* Trading Bot Development
  - [ ] Application of BBMA
  - [ ] Backtesting the strategy
* Implementing naked chart analyzer
  - [ ] Bearish Engulfing
    - [ ] Initial Break
    - [ ] Dominant Break
  - [ ] Quasimodo Pattern / Head and shoulder
  - [ ] QM Manipulation

## Extreme

**Candle is extreme if:**
  * MA5/10 HIGH Breaking top BB
    * MA5 High Breaking top BB is Extreme
    * MA5 and MA10 High breaking top BB is Magic Extreme
  * CSM immediately followed by bearish engulfing (Initial Break)
    * Followed by TPW
    * Followed by MHV (candle fails to close above BB)
