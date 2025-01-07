part of 'main_page_screen.dart';

abstract class _MainPageController extends State<MainPage> {
  final _random = Random();
  final player = AudioPlayer()
    ..audioCache = AudioCache()
    ..setSource(AssetSource("dice_roll.mp3"));

  bool _rollInProgress = false;
  double _animationProgress = 1.0;
  int _current = 0;
  int _previous = 0;

  // Entry point: it rolls a die if one is not already rolling.
  void maybeRollDie() {
    if (_rollInProgress) {
      return;
    }
    _rollInProgress = true;
    _rollDie();
  }

  // Main logic to roll a die
  void _rollDie() async {
    // Start playing the sound immediately
    _playSound();

    // Roll can show between 3 and 5 faces
    int cycles = 3 + _random.nextInt(3);
    for (int i = 0; i < cycles; i++) {
      setState(() {
        _previous = _current;
        _current = _generateDieNumber(_previous);
        _animationProgress = 0;
      });
      await _playAnimation();
    }
    // End of the roll
    _rollInProgress = false;
  }

  // Play the sound of the rolling dice
  void _playSound() async {
    await player.play(AssetSource("dice_roll.mp3"));
  }

  // Play the animation of the rolling die
  Future _playAnimation() async {
    int steps = 20;
    for (int i = 0; i <= steps; i++) {
      setState(() {
        _animationProgress = (i < steps) ? i / steps : 1;
      });
      await Future.delayed(const Duration(milliseconds: 20));
    }
    // Add a small delay after the animation.
    await Future.delayed(const Duration(milliseconds: 25));
  }

  // Generate a random value between 1 and 6 for the die, different from the previous value.
  int _generateDieNumber(int previous) {
    while (true) {
      int v = 1 + _random.nextInt(6);
      if (v != previous) {
        return v;
      }
    }
  }
}
