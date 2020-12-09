import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';

class PaymentGateway extends GetxController {
  Razorpay razorpay;

  @override
  void onInit() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handleError);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handleSuccess);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void handleError(PaymentFailureResponse paymentFailureResponse) {
    Get.snackbar('Error Occured', paymentFailureResponse.message);
  }

  void handleSuccess(PaymentSuccessResponse paymentSuccessResponse) {
    Get.snackbar('Success', paymentSuccessResponse.orderId);
  }

  void handleExternalWallet(ExternalWalletResponse externalWalletResponse) {
    Get.snackbar('External Wallet', externalWalletResponse.walletName);
  }

  void dispatchpayment(int amount, String name, int contact, String email,
      String wallets) async {
    var options = {
      'key': 'rzp_test_7Bbu75jFzeaQaY',
      'amount': amount,
      'name': name,
      'description': 'Payment',
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': [wallets]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }
}
