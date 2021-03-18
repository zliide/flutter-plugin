part of '../../pay.dart';

class ApplePayButton extends StatelessWidget {
  const ApplePayButton({
    Key? key,
    required this.client,
    required this.onPressed,
    this.onError,
    this.childOnError,
    this.childOnLoading,
    this.type,
    this.style,
  }) : super(key: key);

  ApplePayButton.fromAsset({
    Key? key,
    required String assetName,
    required this.onPressed,
    this.onError,
    this.childOnError,
    this.childOnLoading,
    this.type,
    this.style,
  })  : client = Pay.fromAsset(assetName),
        super(key: key);

  final Pay client;
  final Function(Object?)? onError;
  final Widget? childOnError;
  final Widget? childOnLoading;
  final PayGestureTapCallback onPressed;

  final ApplePayButtonType? type;
  final ApplePayButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return PayButton(
      client: client,
      onPressed: onPressed,
      onError: onError,
      childOnError: childOnError,
      childOnLoading: childOnLoading,
      allowedProviders: [
        Provider.google_pay,
      ],
      style: PayButtonStyle(
        applePayStyle: style,
        applePayType: type,
      ),
    );
  }
}
