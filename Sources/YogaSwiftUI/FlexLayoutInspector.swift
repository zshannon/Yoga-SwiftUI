public class FlexLayoutInspector {
    private static var layoutRegistry: [String: LayoutMetrics] = [:]

    public static func getLayoutMetricsFor(flexIntrospectionKey: String) -> LayoutMetrics? {
        layoutRegistry[flexIntrospectionKey]
    }

    static func setLayoutMetricsFor(flexSubViewID: String, _ layoutMetrics: LayoutMetrics) {
        layoutRegistry[flexSubViewID] = layoutMetrics
    }
}
