import 'package:flutter/material.dart';
import 'text_and_voice_field.dart';

class ToggleButton extends StatefulWidget {
  final VoidCallback _sendTextMessage;
  final VoidCallback _sendVoiceMessage;
  final InputMode _inputMode;
  final bool _isReplying;
  final bool _isListening;

  const ToggleButton({
    Key? key,
    required InputMode inputMode,
    required VoidCallback sendTextMessage,
    required VoidCallback sendVoiceMessage,
    required bool isReplying,
    required bool isListening,
  })  : _inputMode = inputMode,
        _sendTextMessage = sendTextMessage,
        _sendVoiceMessage = sendVoiceMessage,
        _isReplying = isReplying,
        _isListening = isListening,
        super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = Theme.of(context).colorScheme.onSecondary;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget._isListening)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final value = _animation.value;
              final opacity = 1.0 - value;
              final size = 60.0 + (20.0 * value);
              return Opacity(
                opacity: opacity,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3 * opacity),
                    border: Border.all(
                      width: 3,
                      color: isDarkMode
                          ? Colors.white.withOpacity(opacity)
                          : Colors.black.withOpacity(opacity),
                    ),
                  ),
                ),
              );
            },
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: widget._isReplying ? Colors.grey : iconColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(15),
          ),
          onPressed: widget._isReplying
              ? null
              : widget._inputMode == InputMode.text
                  ? widget._sendTextMessage
                  : widget._sendVoiceMessage,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (widget._isListening)
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Icon(
              widget._inputMode == InputMode.text
                  ? Icons.send
                  : widget._isListening
                      ? Icons.mic_off
                      : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
