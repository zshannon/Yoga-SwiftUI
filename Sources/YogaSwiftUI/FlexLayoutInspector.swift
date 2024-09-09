import SwiftUI

public class FlexLayoutInspector {
    private static var layoutRegistry: [String: LayoutMetrics] = [:]
    private static var layoutValueCollection: [String: LayoutValueCollection] = [:]

    public static func getLayoutMetricsFor(flexIntrospectionKey: String) -> LayoutMetrics? {
        layoutRegistry[flexIntrospectionKey]
    }

    static func setLayoutMetricsFor(flexSubViewID: String, _ layoutMetrics: LayoutMetrics) {
        layoutRegistry[flexSubViewID] = layoutMetrics
    }
    
    public static func getLayoutValueCollectionFor(flexIntrospectionKey: String) -> LayoutValueCollection? {
        layoutValueCollection[flexIntrospectionKey]
    }

    static func setLayoutValueCollectionFor<Key: LayoutValueKey>(flexSubViewID: String, _ value: Key.Value, for key: Key.Type) {
//        if var collection = layoutValueCollection[flexSubViewID] {
//            // TODO: Does this set the collection for the internal method?
//            collection.set(value, for: key)
//        } else {
//            var collection = LayoutValueCollection()
//            collection.set(value, for: key)
//            layoutValueCollection[flexSubViewID] = collection
//        }
        layoutValueCollection[flexSubViewID, default: LayoutValueCollection()].set(value, for: key)
    }
}


// Custom collection struct
public struct LayoutValueCollection {
    private var storage: [ObjectIdentifier: Any] = [:]
    
    mutating func set<Key: LayoutValueKey>(_ value: Key.Value, for key: Key.Type) {
        storage[ObjectIdentifier(key)] = value
    }
    
    public func get<Key: LayoutValueKey>(_ key: Key.Type) -> Key.Value {
        storage[ObjectIdentifier(key)] as? Key.Value ?? Key.defaultValue
    }
    
    public subscript<Key: LayoutValueKey>(_ key: Key.Type) -> Key.Value {
        get { get(key) }
        set { set(newValue, for: key) }
    }
}
