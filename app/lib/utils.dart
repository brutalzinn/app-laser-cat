class Utils {
  ///Remap like Arduino MAP method to equality with plan cartesian and servo motor angule from 0 to 180.
  static int remapper(double value, double fromStart, double fromEnd,
          double toStart, double toEnd) =>
      ((value - fromStart) * (toEnd - toStart) ~/ (fromEnd - fromStart) +
              toStart)
          .round();
}
