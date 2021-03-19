part of '../../pay.dart';

typedef PayGestureTapCallback = void Function(Pay client);

class PayButtonStyle {
  final GooglePayButtonColor? googlePayColor;
  final GooglePayButtonType? googlePayType;
  final ApplePayButtonStyle? applePayStyle;
  final ApplePayButtonType? applePayType;

  const PayButtonStyle({
    this.googlePayColor,
    this.googlePayType,
    this.applePayStyle,
    this.applePayType,
  });

  static const PayButtonStyle defaultStyle = PayButtonStyle(
    googlePayColor: GooglePayButtonColor.black,
    googlePayType: GooglePayButtonType.pay,
    applePayType: ApplePayButtonType.buy,
    applePayStyle: ApplePayButtonStyle.automatic,
  );
}

class PayButton extends StatefulWidget {
  final Pay client;
  final Function(Object?)? onError;
  final Widget? childOnError;
  final Widget? childOnLoading;
  final PayGestureTapCallback onPressed;
  final List<Provider>? allowedProviders;
  final PayButtonStyle? style;

  const PayButton({
    Key? key,
    required this.client,
    required this.onPressed,
    this.onError,
    this.childOnError,
    this.childOnLoading,
    this.allowedProviders,
    this.style,
  }) : super(key: key);

  PayButton.fromAsset({
    Key? key,
    required String assetName,
    required this.onPressed,
    this.onError,
    this.childOnError,
    this.childOnLoading,
    this.allowedProviders,
    this.style,
  })  : client = Pay.fromAsset(assetName),
        super(key: key);

  @override
  _PayButtonState createState() => _PayButtonState();
}

class _PayButtonState extends State<PayButton> {
  late final Future<bool> _userCanPayFuture;

  @override
  void initState() {
    super.initState();
    _userCanPayFuture = widget.client.userCanPay();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _userCanPayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return widget.childOnLoading ?? SizedBox.shrink();
        }

        if (snapshot.hasError) {
          widget.onError?.call(snapshot.error);
          return widget.childOnError ?? SizedBox.shrink();
        } else if (snapshot.data == true) {
          final provider = widget.client.paymentConfiguration.provider;
          final supported = widget.allowedProviders?.contains(provider) ?? true;
          if (!supported) {
            return widget.childOnError ?? SizedBox.shrink();
          }
          switch (provider) {
            case Provider.google_pay:
              return RawGooglePayButton(
                type: widget.style?.googlePayType,
                color: widget.style?.googlePayColor,
                onPressed: () => widget.onPressed(widget.client),
              );
            case Provider.apple_pay:
              return RawApplePayButton(
                type: widget.style?.applePayType,
                style: widget.style?.applePayStyle,
                onPressed: () => widget.onPressed(widget.client),
              );
          }
        } else {
          return widget.childOnError ?? SizedBox.shrink();
        }
      },
    );
  }
}
