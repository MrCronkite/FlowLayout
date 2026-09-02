import UIKit

/// Diagnostic utilities for Auto Layout, built entirely on UIKit's own
/// public debugging API (`hasAmbiguousLayout`, `constraintsAffectingLayout`,
/// `exerciseAmbiguityInLayout`) — nothing here touches undocumented
/// internals. FlowLayoutDebug has no dependency on FlowLayoutCore or
/// FlowLayoutDSL: it works on any `UIView`, whether or not its constraints
/// were created through FlowLayout.
@MainActor
public enum FlowLayoutDebugger {
    /// Recursively finds every view in `root`'s subtree (including `root`
    /// itself) whose layout is currently ambiguous.
    ///
    /// - Important: `hasAmbiguousLayout` only reflects reality after a
    ///   layout pass has actually run. Call this after `layoutIfNeeded()`
    ///   on the relevant part of the hierarchy, not immediately after
    ///   creating constraints.
    public static func ambiguousViews(in root: UIView) -> [UIView] {
        var result: [UIView] = []
        if root.hasAmbiguousLayout {
            result.append(root)
        }
        for subview in root.subviews {
            result.append(contentsOf: ambiguousViews(in: subview))
        }
        return result
    }

    /// Every constraint currently affecting `view`'s layout, across both
    /// axes, with duplicates removed.
    public static func affectingConstraints(for view: UIView) -> [NSLayoutConstraint] {
        var seen = Set<ObjectIdentifier>()
        var result: [NSLayoutConstraint] = []
        for axis in [NSLayoutConstraint.Axis.horizontal, .vertical] {
            for constraint in view.constraintsAffectingLayout(for: axis) {
                if seen.insert(ObjectIdentifier(constraint)).inserted {
                    result.append(constraint)
                }
            }
        }
        return result
    }

    /// Captures a point-in-time diagnostic snapshot for a single view.
    public static func diagnostic(for view: UIView) -> LayoutDiagnostic {
        LayoutDiagnostic(
            viewDescription: description(of: view),
            isAmbiguous: view.hasAmbiguousLayout,
            frame: view.frame,
            affectingConstraintIdentifiers: affectingConstraints(for: view).compactMap(\.identifier)
        )
    }

    /// Prints a human-readable ambiguity report for `root`'s subtree to the
    /// console. Compiled out entirely in release builds.
    public static func printAmbiguityReport(in root: UIView) {
        #if DEBUG
        let ambiguous = ambiguousViews(in: root)
        guard !ambiguous.isEmpty else {
            print("FlowLayout: no ambiguous views found in \(description(of: root))'s subtree.")
            return
        }
        print("FlowLayout: found \(ambiguous.count) ambiguous view(s):")
        for view in ambiguous {
            let diagnostic = diagnostic(for: view)
            print("  - \(diagnostic.viewDescription) frame=\(diagnostic.frame)")
            if diagnostic.affectingConstraintIdentifiers.isEmpty {
                print("      (no FlowLayout-created constraints affect this view)")
            } else {
                for identifier in diagnostic.affectingConstraintIdentifiers {
                    print("      \(identifier)")
                }
            }
        }
        #endif
    }

    /// Jiggles every ambiguous view's frame in `root`'s subtree so the
    /// ambiguity becomes visible on screen. Thin wrapper around UIKit's own
    /// `exerciseAmbiguityInLayout()` — a debug-only tool Apple itself warns
    /// must never ship.
    public static func exerciseAmbiguity(in root: UIView) {
        #if DEBUG
        for view in ambiguousViews(in: root) {
            view.exerciseAmbiguityInLayout()
        }
        #endif
    }

    private static func description(of view: UIView) -> String {
        var parts = [String(describing: type(of: view))]
        if let identifier = view.accessibilityIdentifier, !identifier.isEmpty {
            parts.append("#\(identifier)")
        }
        return parts.joined(separator: " ")
    }
}
