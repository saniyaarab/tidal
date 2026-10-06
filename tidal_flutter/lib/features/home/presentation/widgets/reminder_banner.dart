import 'package:flutter/material.dart';

import '../../../../theme.dart';

/// "Ibuprofen due now", with "Log dose" and "Dismiss".
class ReminderBanner extends StatelessWidget {
  final String medicationName;
  final VoidCallback onLogDose;
  final VoidCallback onDismiss;

  const ReminderBanner({
    super.key,
    required this.medicationName,
    required this.onLogDose,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: TidalColors.lavenderBand,
        borderRadius: BorderRadius.circular(TidalRadius.large),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: TidalColors.lavender,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$medicationName due now',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(onPressed: onLogDose, child: const Text('Log dose')),
          TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
        ],
      ),
    );
  }
}
