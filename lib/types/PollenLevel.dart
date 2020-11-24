import 'dart:ui';
import 'package:flutter/material.dart';

class PollenLevel {
  static const PollenLevel VeryLow = PollenLevel('Very Low', Colors.green,
      'No action required. Pollen levels pose no risk to allergy sufferers.');

  static const PollenLevel Low = PollenLevel('Low', Colors.yellow,
      'Less than 20% of pollen allergy sufferers will experience symptoms. Known seasonal allergy sufferers should commence preventative therapies e.g. nasal steroid sprays.');

  static const PollenLevel Moderate = PollenLevel('Moderate', Colors.orange,
      'More than 50% of pollen allergy sufferers will experience symptoms. Need for increased use of acute treatments e.g. non-sedating antihistamines.');

  static const PollenLevel High = PollenLevel('High', Colors.deepOrange,
      'More than 90% of pollen allergy sufferers will experience symptoms. Very allergic patients and asthmatics should limit outdoor activities and keep indoor areas free from wind exposure. Check section on pollen and day-to-day weather changes for planning activities.');

  static const PollenLevel VeryHigh = PollenLevel('Very High', Colors.red,
      'These levels are potentially very dangerous for pollen allergy sufferers, especially asthmatics. Outdoor activities should be avoided.');

  final String name;
  final String description;
  final Color color;

  const PollenLevel(this.name, this.color, this.description);
}
