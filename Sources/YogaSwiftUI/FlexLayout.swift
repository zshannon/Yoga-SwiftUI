import SwiftUI
import Yoga

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

    for item in (0..<childrenCount).map({ YGNodeGetChild(rootNodeRef, $0) }) {
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
    setupNodes(subviews: subviews, root: root)

    YGNodeCalculateLayout(cache.rootNodeRef, Float.nan, Float.nan, layoutDirection)

    return CGSize(
      width: CGFloat(YGNodeLayoutGetWidth(root)),
      height: CGFloat(YGNodeLayoutGetHeight(root)))
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

  private func setupNodes(subviews: Subviews, root: YGNodeRef) {
    for (idx, subview) in subviews.enumerated() {
      let subnode = createSubnode(forSubview: subview)
      YGNodeInsertChild(root, subnode, UInt32(idx))
    }
  }

  private func createSubnode(forSubview subview: LayoutSubviews.Element) -> YGNodeRef {
    let subnode = YGNodeNew()!
    let size = subview.sizeThatFits(.unspecified)
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

    YGNodeStyleSetFlexGrow(subnode, Float(flexGrow))
    YGNodeStyleSetFlexShrink(subnode, Float(flexShrink))
    YGNodeStyleSetAlignSelf(subnode, alignSelf)

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

    return subnode
  }

  private func setSubviewsPosition(
    in bounds: CGRect,
    subviews: Subviews,
    cache: inout Cache
  ) {
    for (idx, subview) in subviews.enumerated() {
      if let subnode = YGNodeGetChild(cache.rootNodeRef, UInt32(idx)) {
        let y = YGNodeLayoutGetTop(subnode)
        let x = YGNodeLayoutGetLeft(subnode)
        let width = YGNodeLayoutGetWidth(subnode)
        let height = YGNodeLayoutGetHeight(subnode)

        let xWithBounds = bounds.minX + CGFloat(x)
        let yWithBounds = bounds.minY + CGFloat(y)

        if let flexIntrospectionKey = subview[FlexLayoutMetricsIntrospectionKey.self] {
          FlexLayoutInspector.setLayoutMetricsFor(
            flexSubViewID: flexIntrospectionKey,
            LayoutMetrics(
              x: Float(xWithBounds),
              y: Float(yWithBounds),
              width: width,
              height: height
            )
          )
        }

        subview.place(
          at: CGPoint(
            x: xWithBounds,
            y: yWithBounds),
          proposal: .init(
            CGSize(
              width: CGFloat(width),
              height: CGFloat(height))))
      }
    }
  }
}
