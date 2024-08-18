public struct LayoutMetrics {
  var x: Float
  var y: Float
  var width: Float
  var height: Float

  public static func zero() -> LayoutMetrics {
    .init(x: 0, y: 0, width: 0, height: 0)
  }
}
