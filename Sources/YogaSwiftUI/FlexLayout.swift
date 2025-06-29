import SwiftUI
import yoga

struct FlexLayout: SwiftUI.Layout {
    public var direction: YGFlexDirection = .row
    public var justifyContent: YGJustify = .flexStart
    public var alignItems: YGAlign = .flexStart
    public var alignContent: YGAlign = .flexStart
    public var wrap: YGWrap = .noWrap
    public var rowGap: CGFloat = 0
    public var columnGap: CGFloat = 0
    public var layoutDirection: YGDirection = .LTR

    public typealias Cache = RootNodeWrapper

    public init(
        direction: YGFlexDirection,
        justifyContent: YGJustify,
        alignItems: YGAlign,
        alignContent: YGAlign,
        wrap: YGWrap,
        rowGap: CGFloat,
        columnGap: CGFloat,
        layoutDirection: YGDirection
    ) {
        self.direction = direction
        self.justifyContent = justifyContent
        self.alignItems = alignItems
        self.alignContent = alignContent
        self.wrap = wrap
        self.rowGap = rowGap
        self.columnGap = columnGap
        self.layoutDirection = layoutDirection
    }

    public func makeCache(subviews _: Subviews) -> RootNodeWrapper {
        let config = createConfig()
        let root = createRoot(withConfig: config)
        return RootNodeWrapper(rootNodeRef: root)
    }

    public func freeRootNodeChildren(cache: inout RootNodeWrapper) {
        let rootNodeRef = cache.rootNodeRef
        let childrenCount = YGNodeGetChildCount(rootNodeRef)

        for item in (0 ..< childrenCount).map({ YGNodeGetChild(rootNodeRef, $0) }) {
            YGNodeRemoveChild(rootNodeRef, item)
            YGNodeFree(item)
        }
    }

    // MARK: - Overrided Functions here!

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout RootNodeWrapper
    ) -> CGSize {
        let root = cache.rootNodeRef
        freeRootNodeChildren(cache: &cache)
        setRootDimensions(root: root, proposal: proposal)
        setupNodes(subviews: subviews, root: root, proposal: proposal)

        YGNodeCalculateLayout(cache.rootNodeRef, Float.nan, Float.nan, layoutDirection)

        return CGSize(
            width: CGFloat(YGNodeLayoutGetWidth(root)),
            height: CGFloat(YGNodeLayoutGetHeight(root))
        )
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal _: ProposedViewSize,
        subviews: Subviews,
        cache: inout RootNodeWrapper
    ) {
        setSubviewsPosition(in: bounds, subviews: subviews, cache: &cache)
    }

    private func createConfig() -> YGConfigRef {
        let config = YGConfigNew()
        YGConfigSetUseWebDefaults(config, true)
        YGConfigSetExperimentalFeatureEnabled(config, .webFlexBasis, true)
        YGConfigSetErrata(config, .all)
        return config!
    }

    private func createRoot(withConfig config: YGConfigRef) -> YGNodeRef {
        let root = YGNodeNewWithConfig(config)
        YGNodeStyleSetFlex(root, 1)
        YGNodeStyleSetFlexDirection(root, direction)
        YGNodeStyleSetJustifyContent(root, justifyContent)
        YGNodeStyleSetWidthAuto(root)
        YGNodeStyleSetHeightAuto(root)
        YGNodeStyleSetFlexWrap(root, wrap)
        YGNodeStyleSetGap(root, YGGutter.row, Float(rowGap))
        YGNodeStyleSetGap(root, YGGutter.column, Float(columnGap))
        YGNodeStyleSetAlignItems(root, alignItems)
        YGNodeStyleSetAlignContent(root, alignContent)
        return root!
    }

    private func setRootDimensions(root: YGNodeRef, proposal: ProposedViewSize) {
        if let width = proposal.width {
            YGNodeStyleSetWidth(root, Float(width))
        }

        if let height = proposal.height {
            YGNodeStyleSetHeight(root, Float(height))
        }
    }

    private func setupNodes(subviews: Subviews, root: YGNodeRef, proposal: ProposedViewSize) {
        for (idx, subview) in subviews.enumerated() {
            let subnode = createSubnode(forSubview: subview, proposal: proposal)
            YGNodeInsertChild(root, subnode, idx)
        }
    }

    private func createSubnode(forSubview subview: LayoutSubviews.Element, proposal: ProposedViewSize) -> YGNodeRef {
        let subnode = YGNodeNew()!
        let size = subview.sizeThatFits(proposal)
        let flexGrow = subview[FlexGrowLayoutValueKey.self]
        let flexShrink = subview[FlexShrinkLayoutValueKey.self]
        let alignSelf = subview[AlignSelfLayoutValueKey.self]
        let flexBasis = subview[FlexBasisLayoutValueKey.self]
        let minWidth = subview[MinWidthLayoutValueKey.self]
        let maxWidth = subview[MaxWidthLayoutValueKey.self]
        let width = subview[WidthLayoutValueKey.self]
        let minHeight = subview[MinHeightLayoutValueKey.self]
        let maxHeight = subview[MaxHeightLayoutValueKey.self]
        let height = subview[HeightLayoutValueKey.self]

        // TODO: Add Margin and Positioning, should be a matter of extracting out the parapm
        let position = subview[PositionLayoutValueKey.self]
        let positionTop = subview[PositionTopLayoutValueKey.self]
        let positionBottom = subview[PositionBottomLayoutValueKey.self]
        let positionLeft = subview[PositionLeftLayoutValueKey.self]
        let positionRight = subview[PositionRightLayoutValueKey.self]

        // ! Margins:
        let marginTop = subview[MarginTopLayoutValueKey.self]
        let marginBottom = subview[MarginBottomLayoutValueKey.self]
        let marginLeft = subview[MarginLeftLayoutValueKey.self]
        let marginRight = subview[MarginRightLayoutValueKey.self]

        // Display

        let display  = subview[DisplayLayoutValueKey.self]


        // Debugging and testing:
        setLayoutValuesForSubview(subview)

        YGNodeStyleSetFlexGrow(subnode, Float(flexGrow))
        YGNodeStyleSetFlexShrink(subnode, Float(flexShrink))
        YGNodeStyleSetAlignSelf(subnode, alignSelf)

        if position == .absolute {
            YGNodeStyleSetPositionType(subnode, .absolute)
            switch positionTop.unit {
            case .percent:
                YGNodeStyleSetPosition(subnode, .top, positionTop.value)
            case .point:
                YGNodeStyleSetPosition(subnode, .top, positionTop.value)
            default:
                break
            }
            switch positionBottom.unit {
            case .percent:
                YGNodeStyleSetPosition(subnode, .bottom, positionBottom.value)
            case .point:
                YGNodeStyleSetPosition(subnode, .bottom, positionBottom.value)
            default:
                break
            }
            switch positionRight.unit {
            case .percent:
                YGNodeStyleSetPosition(subnode, .right, positionRight.value)
            case .point:
                YGNodeStyleSetPosition(subnode, .right, positionRight.value)
            default:
                break
            }
            switch positionLeft.unit {
            case .percent:
                YGNodeStyleSetPosition(subnode, .left, positionLeft.value)
            case .point:
                YGNodeStyleSetPosition(subnode, .left, positionLeft.value)
            default:
                break
            }
        }

        switch flexBasis.unit {
        case .auto:
            YGNodeStyleSetFlexBasisAuto(subnode)
        case .percent:
            YGNodeStyleSetFlexBasisPercent(subnode, flexBasis.value)
        case .point:
            YGNodeStyleSetFlexBasis(subnode, flexBasis.value)
        case .undefined:
            break
        @unknown default:
            break
        }

        switch width {
        case .auto:
            YGNodeStyleSetMinWidth(subnode, Float(ceil(size.width)))
        case let .percent(value):
            YGNodeStyleSetWidthPercent(subnode, value)
        case let .point(value):
            YGNodeStyleSetWidth(subnode, value)
        }

        switch height {
        case .auto:
            YGNodeStyleSetMinHeight(subnode, Float(ceil(size.height)))
        case let .percent(value):
            YGNodeStyleSetHeightPercent(subnode, value)
        case let .point(value):
            YGNodeStyleSetHeight(subnode, value)
        }

        switch minWidth {
        case .auto:
            break
        case let .percent(value):
            YGNodeStyleSetMinWidthPercent(subnode, value)
        case let .point(value):
            YGNodeStyleSetMinWidth(subnode, value)
        }

        switch maxWidth {
        case .auto:
            break
        case let .percent(value):
            YGNodeStyleSetMaxWidthPercent(subnode, value)
        case let .point(value):
            YGNodeStyleSetMaxWidth(subnode, value)
        }

        switch minHeight {
        case .auto:
            break
        case let .percent(value):
            YGNodeStyleSetMinHeightPercent(subnode, value)
        case let .point(value):
            YGNodeStyleSetMinHeight(subnode, value)
        }

        switch maxHeight {
        case .auto:
            break
        case let .percent(value):
            YGNodeStyleSetMaxHeightPercent(subnode, value)
        case let .point(value):
            YGNodeStyleSetMaxHeight(subnode, value)
        }

        switch marginBottom.unit {
            case .auto:
                YGNodeStyleSetMarginAuto(subnode, .bottom)
            case .point:
                YGNodeStyleSetMargin(subnode, .bottom, marginBottom.value)
            case .percent:
                YGNodeStyleSetMarginPercent(subnode, .bottom, marginBottom.value)
            default:
                break
        }

        switch marginTop.unit {
            case .auto:
                YGNodeStyleSetMarginAuto(subnode, .top)
            case .point:
                YGNodeStyleSetMargin(subnode, .top, marginTop.value)
            case .percent:
                YGNodeStyleSetMarginPercent(subnode, .top, marginTop.value)
            default:
                break
        }

        switch marginLeft.unit {
            case .auto:
                YGNodeStyleSetMarginAuto(subnode, .left)
            case .point:
                YGNodeStyleSetMargin(subnode, .left, marginLeft.value)
            case .percent:
                YGNodeStyleSetMarginPercent(subnode, .left, marginLeft.value)
            default:
                break
        }

        switch marginRight.unit {
            case .auto:
                YGNodeStyleSetMarginAuto(subnode, .right)
            case .point:
                YGNodeStyleSetMargin(subnode, .right, marginRight.value)
            case .percent:
                YGNodeStyleSetMarginPercent(subnode, .right, marginRight.value)
            default:
                break
        }

        if display == .none {
            YGNodeStyleSetDisplay(subnode, .none)
        }

        return subnode
    }

    private func setSubviewsPosition(
        in bounds: CGRect,
        subviews: Subviews,
        cache: inout Cache
    ) {
        for layoutMetricsResult in calculateLayoutMetricsForSubviews(in: bounds, subviews: subviews, cache: &cache) {
            let layoutMetrics = layoutMetricsResult.layoutMetrics
            let subview = layoutMetricsResult.subview
            let point = CGPoint(
                x: CGFloat(layoutMetrics.x),
                y: CGFloat(layoutMetrics.y)
            )
            let proposedSize = ProposedViewSize(
                width: CGFloat(layoutMetrics.width),
                height: CGFloat(layoutMetrics.height)
            )
            subview.place(at: point, proposal: proposedSize)

            if let flexIntrospectionKey = subview[FlexLayoutMetricsIntrospectionKey.self] {
                FlexLayoutInspector.setLayoutMetricsFor(
                    flexSubViewID: flexIntrospectionKey,
                    layoutMetrics
                )
            }
        }
    }

    private func calculateLayoutMetricsForSubviews(
        in bounds: CGRect,
        subviews: Subviews,
        cache: inout Cache
    ) -> [LayoutMetricsResult] {
        return subviews.enumerated().compactMap { idx, subview in
            if let subnode = YGNodeGetChild(cache.rootNodeRef, idx) {
                let y = YGNodeLayoutGetTop(subnode)
                let x = YGNodeLayoutGetLeft(subnode)
                let width = YGNodeLayoutGetWidth(subnode)
                let height = YGNodeLayoutGetHeight(subnode)

                let xWithBounds = bounds.minX + CGFloat(x)
                let yWithBounds = bounds.minY + CGFloat(y)

                let l = LayoutMetrics(
                    x: Float(xWithBounds),
                    y: Float(yWithBounds),
                    width: width,
                    height: height
                )

                return LayoutMetricsResult(subview: subview, layoutMetrics: l)
            }
            return nil
        }
    }
}

private struct LayoutMetricsResult {
    let subview: LayoutSubview
    let layoutMetrics: LayoutMetrics
}

private func setLayoutValuesForSubview(_ subview: LayoutSubviews.Element) {
    // Get the FlexLayoutMetricsIntrospectionKey value from the subview
    let introspectionKey = subview[FlexLayoutMetricsIntrospectionKey.self]

    // If the introspection key is not set, return early
    guard let flexSubViewID = introspectionKey else { return }

    // Explicitly set the value for each LayoutValueKey type
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[AlignContentLayoutValueKey.self], for: AlignContentLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[AlignItemLayoutValueKey.self], for: AlignItemLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[AlignSelfLayoutValueKey.self], for: AlignSelfLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[FlexDirectionLayoutValueKey.self], for: FlexDirectionLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[FlexWrapLayoutValueKey.self], for: FlexWrapLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[FlexBasisLayoutValueKey.self], for: FlexBasisLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[FlexGrowLayoutValueKey.self], for: FlexGrowLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[FlexShrinkLayoutValueKey.self], for: FlexShrinkLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[WidthLayoutValueKey.self], for: WidthLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MaxWidthLayoutValueKey.self], for: MaxWidthLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MinWidthLayoutValueKey.self], for: MinWidthLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[HeightLayoutValueKey.self], for: HeightLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MaxHeightLayoutValueKey.self], for: MaxHeightLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MinHeightLayoutValueKey.self], for: MinHeightLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PositionLayoutValueKey.self], for: PositionLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MarginTopLayoutValueKey.self], for: MarginTopLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MarginRightLayoutValueKey.self], for: MarginRightLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MarginBottomLayoutValueKey.self], for: MarginBottomLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MarginLeftLayoutValueKey.self], for: MarginLeftLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PaddingTopLayoutValueKey.self], for: PaddingTopLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PaddingRightLayoutValueKey.self], for: PaddingRightLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PaddingBottomLayoutValueKey.self], for: PaddingBottomLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PaddingLeftLayoutValueKey.self], for: PaddingLeftLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[BorderWidthLayoutValueKey.self], for: BorderWidthLayoutValueKey.self)

    // Positioning
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PositionTopLayoutValueKey.self], for: PositionTopLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PositionRightLayoutValueKey.self], for: PositionRightLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PositionBottomLayoutValueKey.self], for: PositionBottomLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PositionLeftLayoutValueKey.self], for: PositionLeftLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PositionStartLayoutValueKey.self], for: PositionStartLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PositionEndLayoutValueKey.self], for: PositionEndLayoutValueKey.self)

    // Display
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[DisplayLayoutValueKey.self], for: DisplayLayoutValueKey.self)

    // Start/End stuff
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PaddingStartLayoutValueKey.self], for: PaddingStartLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[PaddingEndLayoutValueKey.self], for: PaddingEndLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MarginStartLayoutValueKey.self], for: MarginStartLayoutValueKey.self)
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[MarginEndLayoutValueKey.self], for: MarginEndLayoutValueKey.self)

    // Aspect Ratio
    FlexLayoutInspector.setLayoutValueCollectionFor(flexSubViewID: flexSubViewID, subview[AspectRatioLayoutValueKey.self], for: AspectRatioLayoutValueKey.self)
}
