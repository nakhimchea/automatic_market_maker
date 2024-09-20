import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _operationBaseController =
      TextEditingController();
  final TextEditingController _operationQuoteController =
      TextEditingController();

  double _currentBase = 0;
  double _currentQuote = 1000000;
  String _alertMessage = '';

  double _base = 9999999900.00;
  double _quote = 40000;
  double _sellNewPrice = 0;
  double _buyNewPrice = 0;
  double _sellSlippage = 0;
  double _buySlippage = 0;

  double? _ammBaseResult;
  double? _ammQuoteResult;

  double _getPrice({required double base, required double quote}) =>
      quote / base;

  double _getSlippage({
    required double currentPrice,
    required double newPrice,
  }) =>
      ((newPrice - currentPrice) / newPrice).abs() * 100;

  double? ammSwap({
    double? buyBase,
    double? sellBase,
    double? buyQuote,
    double? sellQuote,
  }) {
    if (buyBase == null &&
        sellBase == null &&
        buyQuote == null &&
        sellQuote == null) return null;
    if (buyBase != null && buyBase >= _base) return null;
    if (buyQuote != null && buyQuote >= _quote) return null;

    final double constantProduct = _base * _quote;
    if (buyBase != null) {
      final double newBase = _base - buyBase;
      final double newQuote = constantProduct / newBase;

      return newQuote - _quote;
    } else if (sellBase != null) {
      final double newBase = _base + sellBase;
      final double newQuote = constantProduct / newBase;

      return newQuote - _quote;
    } else if (buyQuote != null) {
      final double newQuote = _quote - buyQuote;
      final double newBase = constantProduct / newQuote;

      return newBase - _base;
    } else if (sellQuote != null) {
      final double newQuote = _quote + sellQuote;
      final double newBase = constantProduct / newQuote;

      return newBase - _base;
    }

    return null;
  }

  String _translateResult(double? baseResult, double? quoteResult) {
    if (baseResult != null && baseResult >= 0) {
      return 'You will pay ${baseResult.abs().toStringAsFixed(8)} USDT.';
    } else if (baseResult != null && baseResult < 0) {
      return 'You will get ${baseResult.abs().toStringAsFixed(8)} USDT.';
    } else if (quoteResult != null && quoteResult >= 0) {
      return 'You will get ${quoteResult.abs().toStringAsFixed(8)} TAG.';
    } else if (quoteResult != null && quoteResult < 0) {
      return 'You will pay ${quoteResult.abs().toStringAsFixed(8)} TAG.';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF6F8FA),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 80, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Simulation',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: 120,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${_currentBase.toStringAsFixed(0)} TAG",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        "${_currentQuote.toStringAsFixed(0)} USDT",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TAG:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${_base.toStringAsFixed(0)} TAG',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'USDT:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${_quote.toStringAsFixed(2)} USDT',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Price:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      _getPrice(base: _base, quote: _quote).toStringAsFixed(9),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sell New Price:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      _sellNewPrice.toStringAsFixed(9),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buy New Price:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      _buyNewPrice.toStringAsFixed(9),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sell Slippage:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${_sellSlippage.toStringAsFixed(2)}%',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buy Slippage:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${_buySlippage.toStringAsFixed(2)}%',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _operationBaseController,
                        onTap: () {
                          _ammBaseResult = null;
                          _ammQuoteResult = null;
                        },
                        onChanged: (input) {
                          _operationQuoteController.text = '';
                          _operationBaseController.text = input;
                          double? inputBase = double.tryParse(input);
                          if (inputBase != null) {
                            final double? sellBaseQuote =
                                ammSwap(sellBase: inputBase);
                            if (sellBaseQuote != null) {
                              _sellNewPrice = _getPrice(
                                  base: _base + inputBase,
                                  quote: _quote - sellBaseQuote.abs());
                              _sellSlippage = _getSlippage(
                                  currentPrice:
                                      _getPrice(base: _base, quote: _quote),
                                  newPrice: _sellNewPrice);
                            }
                            final double? buyBaseQuote =
                                ammSwap(buyBase: inputBase);
                            if (buyBaseQuote != null) {
                              _buyNewPrice = _getPrice(
                                  base: _base - inputBase,
                                  quote: _quote + buyBaseQuote);
                              _buySlippage = _getSlippage(
                                  currentPrice:
                                      _getPrice(base: _base, quote: _quote),
                                  newPrice: _buyNewPrice);
                            }
                          } else {
                            _sellNewPrice = 0;
                            _buyNewPrice = 0;
                            _sellSlippage = 0;
                            _buySlippage = 0;
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          hintText: 'TAG',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: _operationQuoteController,
                        onTap: () {
                          _ammBaseResult = null;
                          _ammQuoteResult = null;
                        },
                        onChanged: (input) {
                          _operationBaseController.text = '';
                          _operationQuoteController.text = input;
                          double? inputQuote = double.tryParse(input);
                          if (inputQuote != null) {
                            final double? sellQuoteBase =
                                ammSwap(sellQuote: inputQuote);
                            if (sellQuoteBase != null) {
                              _sellNewPrice = _getPrice(
                                  base: _base - sellQuoteBase.abs(),
                                  quote: _quote + inputQuote);
                              _sellSlippage = _getSlippage(
                                  currentPrice:
                                      _getPrice(base: _base, quote: _quote),
                                  newPrice: _sellNewPrice);
                            }
                            final double? buyQuoteBase =
                                ammSwap(buyQuote: inputQuote);
                            if (buyQuoteBase != null) {
                              _buyNewPrice = _getPrice(
                                  base: _base + buyQuoteBase.abs(),
                                  quote: _quote - inputQuote);
                              _buySlippage = _getSlippage(
                                  currentPrice:
                                      _getPrice(base: _base, quote: _quote),
                                  newPrice: _buyNewPrice);
                            }
                          } else {
                            _sellNewPrice = 0;
                            _buyNewPrice = 0;
                            _sellSlippage = 0;
                            _buySlippage = 0;
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          hintText: 'USDT',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          final double? sellBase = double.tryParse(
                              _operationBaseController.text.trim());
                          final double? sellQuote = double.tryParse(
                              _operationQuoteController.text.trim());

                          if (sellBase != null && sellQuote == null) {
                            _ammBaseResult = ammSwap(sellBase: sellBase);
                            if (_ammBaseResult != null) {
                              if (sellBase > _currentBase) {
                                _alertMessage =
                                    'Your TAG balance is insufficient.';
                                debugPrint(
                                    'Transaction Failed: sellBase > currentBase.');
                                setState(() {
                                  _ammBaseResult = null;
                                  _ammQuoteResult = null;

                                  _sellNewPrice = 0;
                                  _buyNewPrice = 0;
                                  _sellSlippage = 0;
                                  _buySlippage = 0;
                                  _operationBaseController.text = '';
                                  _operationQuoteController.text = '';
                                });
                                return;
                              }
                              _alertMessage = '';
                              _base = _base + sellBase;
                              _quote = _quote - _ammBaseResult!.abs();
                              _currentBase = _currentBase - sellBase;
                              _currentQuote =
                                  _currentQuote + _ammBaseResult!.abs();
                            }
                          } else if (sellQuote != null && sellBase == null) {
                            _ammQuoteResult = ammSwap(sellQuote: sellQuote);
                            if (_ammQuoteResult != null) {
                              if (sellQuote > _currentQuote) {
                                _alertMessage =
                                    'Your USDT balance is insufficient.';
                                debugPrint(
                                    'Transaction Failed: sellQuote > currentQuote.');
                                setState(() {
                                  _ammBaseResult = null;
                                  _ammQuoteResult = null;

                                  _sellNewPrice = 0;
                                  _buyNewPrice = 0;
                                  _sellSlippage = 0;
                                  _buySlippage = 0;
                                  _operationBaseController.text = '';
                                  _operationQuoteController.text = '';
                                });
                                return;
                              }
                              _alertMessage = '';
                              _base = _base - _ammQuoteResult!.abs();
                              _quote = _quote + sellQuote;
                              _currentBase =
                                  _currentBase + _ammQuoteResult!.abs();
                              _currentQuote = _currentQuote - sellQuote;
                            }
                          }
                          setState(() {
                            _sellNewPrice = 0;
                            _buyNewPrice = 0;
                            _sellSlippage = 0;
                            _buySlippage = 0;
                            _operationBaseController.text = '';
                            _operationQuoteController.text = '';
                          });
                        },
                        color: Colors.red,
                        child: Text(
                          'Sell',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          final double? buyBase = double.tryParse(
                              _operationBaseController.text.trim());
                          final double? buyQuote = double.tryParse(
                              _operationQuoteController.text.trim());

                          if (buyBase != null && buyQuote == null) {
                            _ammBaseResult = ammSwap(buyBase: buyBase);
                            if (_ammBaseResult != null) {
                              if (_ammBaseResult!.abs() > _currentQuote) {
                                _alertMessage =
                                    'You don\'t have enough USDT to buy TAG.';
                                debugPrint(
                                    'Transaction Failed: buyBaseQuote > currentQuote.');
                                setState(() {
                                  _ammBaseResult = null;
                                  _ammQuoteResult = null;

                                  _sellNewPrice = 0;
                                  _buyNewPrice = 0;
                                  _sellSlippage = 0;
                                  _buySlippage = 0;
                                  _operationBaseController.text = '';
                                  _operationQuoteController.text = '';
                                });
                                return;
                              }
                              _alertMessage = '';
                              _base = _base - buyBase;
                              _quote = _quote + _ammBaseResult!.abs();
                              _currentBase = _currentBase + buyBase;
                              _currentQuote =
                                  _currentQuote - _ammBaseResult!.abs();
                            }
                          } else if (buyQuote != null && buyBase == null) {
                            _ammQuoteResult = ammSwap(buyQuote: buyQuote);
                            if (_ammQuoteResult != null) {
                              if (_ammQuoteResult!.abs() > _currentBase) {
                                _alertMessage =
                                    'You don\'t have enough TAG to buy USDT.';
                                debugPrint(
                                    'Transaction Failed: buyQuoteBase > currentBase.');
                                setState(() {
                                  _ammBaseResult = null;
                                  _ammQuoteResult = null;

                                  _sellNewPrice = 0;
                                  _buyNewPrice = 0;
                                  _sellSlippage = 0;
                                  _buySlippage = 0;
                                  _operationBaseController.text = '';
                                  _operationQuoteController.text = '';
                                });
                                return;
                              }
                              _alertMessage = '';
                              _base = _base + _ammQuoteResult!.abs();
                              _quote = _quote - buyQuote;
                              _currentBase =
                                  _currentBase - _ammQuoteResult!.abs();
                              _currentQuote = _currentQuote + buyQuote;
                            }
                          }
                          setState(() {
                            _sellNewPrice = 0;
                            _buyNewPrice = 0;
                            _sellSlippage = 0;
                            _buySlippage = 0;
                            _operationBaseController.text = '';
                            _operationQuoteController.text = '';
                          });
                        },
                        color: Colors.green,
                        child: Text(
                          'Buy',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    _alertMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    _translateResult(_ammBaseResult, _ammQuoteResult),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
