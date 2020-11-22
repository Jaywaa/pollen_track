import 'dart:ui';

import 'package:flutter/material.dart';

class PollenLevel {
  static PollenLevel VeryLow = new PollenLevel('Very Low', Colors.green,
      'No action required. Pollen levels pose no risk to allergy sufferers.');

  static PollenLevel Low = new PollenLevel('Low', Colors.yellow,
      'Less than 20% of pollen allergy sufferers will experience symptoms. Known seasonal allergy sufferers should commence preventative therapies e.g. nasal steroid sprays.');

  static PollenLevel Moderate = new PollenLevel('Moderate', Colors.orange,
      'More than 50% of pollen allergy sufferers will experience symptoms. Need for increased use of acute treatments e.g. non-sedating antihistamines.');

  static PollenLevel High = new PollenLevel('High', Colors.deepOrange,
      'More than 90% of pollen allergy sufferers will experience symptoms. Very allergic patients and asthmatics should limit outdoor activities and keep indoor areas free from wind exposure. Check section on pollen and day-to-day weather changes for planning activities.');

  static PollenLevel VeryHigh = new PollenLevel('Very High', Colors.red,
      'These levels are potentially very dangerous for pollen allergy sufferers, especially asthmatics. Outdoor activities should be avoided.');

  String name;
  String description;
  Color color;

  PollenLevel(String name, Color color, String description) {
    this.name = name;
    this.description = description;
    this.color = color;
  }
}
