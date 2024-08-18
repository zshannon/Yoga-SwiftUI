import Yoga

/// Use this wrapper to free the node automatically when dropped by Swift
class RootNodeWrapper {
  let rootNodeRef: YGNodeRef

  init(rootNodeRef: YGNodeRef) {
    self.rootNodeRef = rootNodeRef
  }

  deinit {
    YGNodeFree(rootNodeRef)
  }
}
