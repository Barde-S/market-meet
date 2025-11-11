import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingFlowScreen extends StatefulWidget {
  final Map<String, dynamic> agent;

  const BookingFlowScreen({
    super.key,
    required this.agent,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 0;

  // Booking data
  String _selectedServiceType = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _estimatedHours = 2;
  final _requirementsController = TextEditingController();
  final _shoppingListController = TextEditingController();
  final _budgetController = TextEditingController();
  String _selectedPaymentMethod = '';

  @override
  void dispose() {
    _requirementsController.dispose();
    _shoppingListController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Agent'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: _buildStepContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Row(
        children: [
          _buildProgressStep(0, 'Service', Icons.shopping_bag),
          _buildProgressLine(0),
          _buildProgressStep(1, 'Date & Time', Icons.calendar_today),
          _buildProgressLine(1),
          _buildProgressStep(2, 'Details', Icons.edit_note),
          _buildProgressLine(2),
          _buildProgressStep(3, 'Payment', Icons.payment),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, IconData icon) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300],
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  )
                : null,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey[600],
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(int step) {
    final isActive = _currentStep > step;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildServiceSelectionStep();
      case 1:
        return _buildDateTimeStep();
      case 2:
        return _buildDetailsStep();
      case 3:
        return _buildPaymentStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildServiceSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Service Type',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to shop with ${widget.agent['name']}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          _buildServiceTypeCard(
            type: 'Guided Shopping',
            icon: Icons.video_call,
            description:
                'Shop together via live video call. Get real-time guidance and see products before purchasing.',
            price: widget.agent['hourlyRate'],
            features: [
              'Live video assistance',
              'Real-time product viewing',
              'Instant decision making',
              'Payment processing help',
            ],
          ),
          const SizedBox(height: 16),
          _buildServiceTypeCard(
            type: 'Proxy Shopping',
            icon: Icons.local_shipping,
            description:
                'Agent shops for you and ships items to your location. Perfect when you can\'t be there.',
            price: widget.agent['hourlyRate'],
            features: [
              'Agent purchases for you',
              'Photo/video updates',
              'International shipping',
              'Quality verification',
            ],
          ),
          const SizedBox(height: 16),
          _buildServiceTypeCard(
            type: 'In-Person Guide',
            icon: Icons.person_pin_circle,
            description:
                'Meet the agent in person for a guided shopping tour. Best for travelers.',
            price: widget.agent['hourlyRate'] + 10,
            features: [
              'Personal shopping tour',
              'Local insights & tips',
              'Negotiation assistance',
              'Transportation included',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeCard({
    required String type,
    required IconData icon,
    required String description,
    required int price,
    required List<String> features,
  }) {
    final isSelected = _selectedServiceType == type;

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedServiceType = type;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$$price/hour',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date & Time',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Date Selection
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(
                _selectedDate != null
                    ? DateFormat('EEEE, MMMM d, y').format(_selectedDate!)
                    : 'Select a date',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 12),

          // Time Selection
          Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Time'),
              subtitle: Text(
                _selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Select a time',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Estimated Duration
          Text(
            'Estimated Duration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_estimatedHours hours',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Est. \$${_estimatedHours * (widget.agent['hourlyRate'] as int)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _estimatedHours.toDouble(),
                    min: 1,
                    max: 8,
                    divisions: 7,
                    label: '$_estimatedHours hours',
                    onChanged: (value) {
                      setState(() {
                        _estimatedHours = value.toInt();
                      });
                    },
                  ),
                  Text(
                    'Slide to adjust estimated duration',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Agent Availability Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Agent typically responds within ${widget.agent['responseTime']}',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Requirements
          TextField(
            controller: _requirementsController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Special Requirements',
              hintText: 'Tell the agent about any specific needs...',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Shopping List
          TextField(
            controller: _shoppingListController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: 'Shopping List',
              hintText: 'List items you want to buy...\n\n• Item 1\n• Item 2\n• Item 3',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Budget
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Estimated Budget',
              hintText: 'Enter your budget',
              prefixText: '\$ ',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Booking Summary Card
          Card(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow('Service', _selectedServiceType),
                  _buildSummaryRow(
                    'Date',
                    _selectedDate != null
                        ? DateFormat('MMM d, y').format(_selectedDate!)
                        : '-',
                  ),
                  _buildSummaryRow(
                    'Time',
                    _selectedTime?.format(context) ?? '-',
                  ),
                  _buildSummaryRow('Duration', '$_estimatedHours hours'),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Service Fee',
                    '\$${_estimatedHours * (widget.agent['hourlyRate'] as int)}',
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          _buildPaymentMethodCard(
            method: 'Credit Card',
            icon: Icons.credit_card,
            description: 'Visa, Mastercard, Amex',
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodCard(
            method: 'PayPal',
            icon: Icons.account_balance_wallet,
            description: 'Fast and secure',
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodCard(
            method: 'Apple Pay',
            icon: Icons.apple,
            description: 'Pay with Apple Pay',
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodCard(
            method: 'Google Pay',
            icon: Icons.g_mobiledata,
            description: 'Pay with Google Pay',
          ),

          const SizedBox(height: 24),

          // Final Summary
          Card(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Final Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow('Service Fee', '\$${_estimatedHours * (widget.agent['hourlyRate'] as int)}'),
                  _buildSummaryRow('Platform Fee', '\$5'),
                  _buildSummaryRow('Tax', '\$${((_estimatedHours * (widget.agent['hourlyRate'] as int) + 5) * 0.1).toStringAsFixed(2)}'),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Total',
                    '\$${((_estimatedHours * (widget.agent['hourlyRate'] as int) + 5) * 1.1).toStringAsFixed(2)}',
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You won\'t be charged until the agent confirms your booking',
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String method,
    required IconData icon,
    required String description,
  }) {
    final isSelected = _selectedPaymentMethod == method;

    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
        title: Text(method),
        subtitle: Text(description),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                child: const Text('Back'),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _canProceed() ? _handleNext : null,
                child: Text(_currentStep == 3 ? 'Confirm Booking' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedServiceType.isNotEmpty;
      case 1:
        return _selectedDate != null && _selectedTime != null;
      case 2:
        return true; // Optional fields
      case 3:
        return _selectedPaymentMethod.isNotEmpty;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _confirmBooking();
    }
  }

  void _confirmBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Your booking request has been sent to ${widget.agent['name']}.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll receive a notification once the agent confirms.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close booking screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
