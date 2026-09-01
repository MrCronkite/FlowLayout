// FlowLayoutDSL's public API (FlowLayoutProxy's pin* methods) exposes
// FlowLayoutCore types directly in its method signatures — `LayoutPriority`,
// `LayoutRelation`, `FlowLayoutTarget`. Re-exporting Core here means anyone
// who writes `import FlowLayoutDSL` can spell `.high` or `.greaterThanOrEqual`
// without a second, easy-to-forget `import FlowLayoutCore`.
@_exported import FlowLayoutCore
