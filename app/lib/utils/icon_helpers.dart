import 'package:flutter/material.dart';

const availableListIcons = <(String, IconData)>[
  ('person_outline', Icons.person_outline),
  ('work_outline', Icons.work_outline),
  ('shopping_cart_outlined', Icons.shopping_cart_outlined),
  ('favorite_outline', Icons.favorite_outline),
  ('school_outlined', Icons.school_outlined),
  ('home_outlined', Icons.home_outlined),
  ('fitness_center', Icons.fitness_center),
  ('restaurant_outlined', Icons.restaurant_outlined),
  ('directions_car_outlined', Icons.directions_car_outlined),
  ('flight_outlined', Icons.flight_outlined),
  ('pets_outlined', Icons.pets_outlined),
  ('music_note_outlined', Icons.music_note_outlined),
  ('code', Icons.code),
  ('attach_money', Icons.attach_money),
  ('star_outline', Icons.star_outline),
  ('list', Icons.list),
];

final _iconMap = {
  for (final (name, icon) in availableListIcons) name: icon,
};

IconData iconFromName(String name) {
  return _iconMap[name] ?? Icons.list;
}
