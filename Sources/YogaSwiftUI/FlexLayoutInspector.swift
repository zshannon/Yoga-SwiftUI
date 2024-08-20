public class FlexLayoutInspector {
    private static var layoutRegistry: [String: LayoutMetrics] = [:]

    /// If enabled, will calculate subviews & update in the ``sizeThatFits`` method
    public static var enabled: Bool = false

    public static func getLayoutMetricsFor(flexIntrospectionKey: String) -> LayoutMetrics? {
        layoutRegistry[flexIntrospectionKey]
    }

    static func setLayoutMetricsFor(flexSubViewID: String, _ layoutMetrics: LayoutMetrics) {
        layoutRegistry[flexSubViewID] = layoutMetrics
    }
}
