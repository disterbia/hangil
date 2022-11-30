import 'package:hangil/model/menu.dart';

class UpdateDto {
  final Menu? menu;

  UpdateDto({
    this.menu});

  Map<String, dynamic> MenuToJson() =>
      {
        "name": menu?.name,
      };
}