import 'package:flutter/material.dart';
import '../qr_ticket/qr_ticket_screen.dart';

/// Payment Screen for train ticket booking
class PaymentScreen extends StatefulWidget {
  final String source;
  final String destination;
  final String ticketClass;
  final String ticketType;
  final int ticketQuantity;
  final double fare;
  final String? selectedRoute;

  const PaymentScreen({
    super.key,
    required this.source,
    required this.destination,
    required this.ticketClass,
    required this.ticketType,
    this.ticketQuantity = 1,
    required this.fare,
    this.selectedRoute,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  late String selectedPaymentMethod;
  late double totalFare;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    selectedPaymentMethod = 'card';
    totalFare = widget.fare * widget.ticketQuantity;
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _upiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool _validateUpi(String upi) {
    // Valid UPI format: name@bankname
    final upiRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z]{2,}$');
    return upiRegex.hasMatch(upi);
  }

  void _processPayment() {
    if (selectedPaymentMethod == 'card') {
      if (_cardNumberController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty ||
          _nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all card details')),
        );
        return;
      }
    } else if (selectedPaymentMethod == 'upi') {
      if (_upiController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your UPI ID')),
        );
        return;
      }
      if (!_validateUpi(_upiController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid UPI format. Use format: name@bank'),
          ),
        );
        return;
      }
    }

    // Start animation and process payment
    setState(() => _isProcessing = true);
    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      // Generate ticket reference
      String ticketRef = _generateRefNumber();

      // Navigate to QR Ticket Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QRTicketScreen(
            source: widget.source,
            destination: widget.destination,
            ticketClass: widget.ticketClass,
            ticketType: widget.ticketType,
            ticketQuantity: widget.ticketQuantity,
            fare: totalFare,
            bookingReference: ticketRef,
            selectedRoute: widget.selectedRoute ?? 'Unknown',
          ),
        ),
      );
    });
  }

  String _generateRefNumber() {
    return 'TKT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: _isProcessing
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: _isProcessing
          ? _buildPaymentAnimation()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking Summary Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Booking Summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Route:'),
                                Text(
                                  '${widget.source} → ${widget.destination}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Class:'),
                                Text(
                                  widget.ticketClass,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Type:'),
                                Text(
                                  widget.ticketType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tickets:'),
                                Text(
                                  '${widget.ticketQuantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Fare per Ticket:'),
                                Text(
                                  '₹${widget.fare.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₹${totalFare.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E88E5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Method Selection
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentMethodTile(
                      'card',
                      Icons.credit_card,
                      'Debit/Credit Card',
                    ),
                    _buildPaymentMethodTile('upi', Icons.phone_android, 'UPI'),
                    _buildPaymentMethodTile(
                      'wallet',
                      Icons.account_balance_wallet,
                      'Digital Wallet',
                    ),
                    _buildPaymentMethodTile(
                      'netbanking',
                      Icons.security,
                      'Net Banking',
                    ),
                    const SizedBox(height: 24),

                    // Card Details (if card selected)
                    if (selectedPaymentMethod == 'card') ...[
                      const Text(
                        'Card Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Cardholder Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _cardNumberController,
                        decoration: InputDecoration(
                          hintText: 'Card Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.credit_card),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _expiryController,
                              decoration: InputDecoration(
                                hintText: 'MM/YY',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _cvvController,
                              decoration: InputDecoration(
                                hintText: 'CVV',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.lock),
                              ),
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    // UPI Details (if UPI selected)
                    if (selectedPaymentMethod == 'upi') ...[
                      const Text(
                        'UPI Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.withAlpha(100)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Enter your UPI ID (e.g., yourname@upi)',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _upiController,
                        decoration: InputDecoration(
                          hintText: 'name@bankname',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.phone_android),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Payment Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Pay ₹${totalFare.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Payment is secured with 256-bit encryption',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPaymentAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Circle Progress
          ScaleTransition(
            scale: _animation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1E88E5), width: 4),
              ),
              child: const Center(
                child: Icon(Icons.check, size: 60, color: Color(0xFF1E88E5)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Animated Text
          FadeTransition(
            opacity: _animation,
            child: Column(
              children: [
                const Text(
                  'Processing Payment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${totalFare.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Loading dots animation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1E88E5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String value, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => selectedPaymentMethod = value),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selectedPaymentMethod == value
                  ? const Color(0xFF1E88E5)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          elevation: selectedPaymentMethod == value ? 2 : 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selectedPaymentMethod == value
                      ? const Color(0xFF1E88E5)
                      : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selectedPaymentMethod == value
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selectedPaymentMethod == value
                          ? const Color(0xFF1E88E5)
                          : Colors.black,
                    ),
                  ),
                ),
                if (selectedPaymentMethod == value)
                  const Icon(Icons.check_circle, color: Color(0xFF1E88E5))
                else
                  Icon(Icons.radio_button_unchecked, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
