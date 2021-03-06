/**
 * Provides a taint tracking configuration for reasoning about
 * tainted-path vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `TaintedPath::Configuration` is needed, otherwise
 * `TaintedPathCustomizations` should be imported instead.
 */

import javascript

module TaintedPath {
  import TaintedPathCustomizations::TaintedPath

  /**
   * A taint-tracking configuration for reasoning about tainted-path vulnerabilities.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "TaintedPath" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      label = source.(Source).getAFlowLabel()
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      label = sink.(Sink).getAFlowLabel()
    }

    override predicate isBarrier(DataFlow::Node node) {
      super.isBarrier(node) or
      node instanceof Sanitizer
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      guard instanceof BarrierGuardNode
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
      DataFlow::FlowLabel dstlabel
    ) {
      isAdditionalTaintedPathFlowStep(src, dst, srclabel, dstlabel)
    }
  }
}
