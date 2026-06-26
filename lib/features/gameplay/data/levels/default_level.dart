import 'package:color_twist/features/gameplay/models/level_definition.dart';
import 'package:color_twist/features/gameplay/models/level_object.dart';

const defaultLevel = LevelDefinition(
  id: 'default',
  groundY: 400,
  playerY: 300,
  objects: [
    LevelObject(type: LevelObjectType.colorSwitcher, positionX: 0, positionY: 180),
    LevelObject(type: LevelObjectType.star, positionX: 0, positionY: 0),
    LevelObject(
      type: LevelObjectType.circleRotator,
      positionX: 0,
      positionY: 0,
      size: 200,
    ),
    LevelObject(type: LevelObjectType.colorSwitcher, positionX: 0, positionY: -200),
    LevelObject(type: LevelObjectType.star, positionX: 0, positionY: -400),
    LevelObject(
      type: LevelObjectType.circleRotator,
      positionX: 0,
      positionY: -400,
      size: 150,
    ),
    LevelObject(
      type: LevelObjectType.circleRotator,
      positionX: 0,
      positionY: -400,
      size: 180,
    ),
  ],
);
