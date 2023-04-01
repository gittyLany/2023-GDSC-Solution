import 'package:flutter/cupertino.dart';

/// Utility methods for movement of turtle
class Movement {
  /// Returns x coordinate depending of the following factors:
  /// <p>
  /// width -> screen width or boundary or total length
  /// <p>
  /// maxSteps -> how many steps does it take for turtle to cross screen (horizontally).
  /// This number is used to split the screen width.
  /// Ex: If screen width is 100px and you want it to take 100 steps for turtle to cross the entire screen, pass 100 to maxSteps.
  /// Must be greater than 0
  /// <p>
  /// userStep -> how many steps the user has taken. Or where is the user?
  /// Ex: Continuing from earlier example, let's they are halfway across the screen,
  /// pass 50 because they took 50 out of the 100 steps
  /// <p>
  /// Returned x value will range from (-1 to 1). If outside this range, the turtle will be out of the screen
  /// <p>
  /// For reference, (-1,-1) is top left of rectangle, (1,1) is bottom right of rectangle, (0,0) is center
  static double getX(double width, double maxSteps, double userStep) {
    // Handling errors
    if (maxSteps < 0) {
      throw Exception('Max steps must be greater than 0');
    }

    // Gets where user is in terms of cartesian plane
    double xPoint = (width / maxSteps) * userStep;

    // --- Converting to -1.0 to 1.0 scale
    double mid = width / 2.0;

    // Formula to convert to -1 to 1 scale
    return (xPoint / mid) - 1;
  }
}
