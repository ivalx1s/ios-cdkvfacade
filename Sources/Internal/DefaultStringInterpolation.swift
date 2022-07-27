// silences a compilation warning regarding string interpolaton for optional values
// "String interpolation produces a debug description for an optional value; did you mean to make this explicit?"
extension DefaultStringInterpolation {
   mutating func appendInterpolation<T>(_ optional: T?) {
      appendInterpolation(String(describing: optional))
   }
}
