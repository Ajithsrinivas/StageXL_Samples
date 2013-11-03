library mask;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part 'source/flower_field.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  //---------------------------------------------
  // Initialize the Display List

  stage = new Stage("myStage", html.querySelector('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  //---------------------------------------------
  // define three different masks

  var starPath = new List<Point>();

  for(int i = 0; i < 6; i++) {
    num a1 = (i * 60) * math.PI / 180;
    num a2 = (i * 60 + 30) * math.PI / 180;
    starPath.add(new Point(470 + 200 * math.cos(a1), 250 + 200 * math.sin(a1)));
    starPath.add(new Point(470 + 100 * math.cos(a2), 250 + 100 * math.sin(a2)));
  }

  var rectangleMask = new Mask.rectangle(100, 100, 740, 300);
  var circleMask = new Mask.circle(470, 250, 200);
  var customMask = new Mask.custom(starPath);

  //---------------------------------------------
  // add html-button event listeners

  var flowerField = new Sprite();

  html.querySelector('#mask-none').onClick.listen((e) => flowerField.mask = null);
  html.querySelector('#mask-rectangle').onClick.listen((e) => flowerField.mask = rectangleMask);
  html.querySelector('#mask-circle').onClick.listen((e) => flowerField.mask = circleMask);
  html.querySelector('#mask-custom').onClick.listen((e) => flowerField.mask = customMask);
  html.querySelector('#mask-spin').onClick.listen((e) {
    stage.juggler.tween(flowerField, 2.0, TransitionFunction.easeInOutBack)
      ..animate.rotation.to(math.PI * 4.0)
      ..onComplete = () => flowerField.rotation = 0.0;
    });

  //---------------------------------------------
  // Load the flower images

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager = new ResourceManager()
    ..addBitmapData('flower1', 'images/Flower1.png')
    ..addBitmapData('flower2', 'images/Flower2.png')
    ..addBitmapData('flower3', 'images/Flower3.png')
    ..load().then((_) {
      flowerField = new FlowerField();
      flowerField.x = 470;
      flowerField.y = 250;
      stage.addChild(flowerField);
    });
}
