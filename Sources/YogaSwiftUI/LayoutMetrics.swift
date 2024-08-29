public struct LayoutMetrics: Equatable {
    public var x: Float
    public var y: Float
    public var width: Float
    public var height: Float

    public static func zero() -> LayoutMetrics {
        .init(x: 0, y: 0, width: 0, height: 0)
    }

    public init(x: Float, y: Float, width: Float, height: Float) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}
