# CHANGELOG

## 0.3.0

* base `dom_classes` / `dom_aria` / `dom_data` / `dom_style` return shared frozen constants instead of fresh empty collections per call
* `has_dom_class` / `has_dom_aria` / `has_dom_data` / `has_dom_style` / `has_dom_attr` prepends switch from `super().tap { mutate }` to non-mutating `super() + [v]` / `super().merge(name => v)` (required by the frozen bases)
* `DomStyle#merge` added so chained `has_dom_style` prepends return `DomStyle`, not plain `Hash`
* `dom_attrs` rewritten to avoid the 4-allocation `{...}.reject.deep_stringify_keys.deep_transform_keys` chain — now a single `result = {}` with per-slot conditional assignments
* Net effect: ~1.5–2 MB fewer allocations per heavy page render in consumer apps; components that don't opt in to `has_dom_*` now pay zero allocation for those slots

## 0.2.0

* bump to Ruby 3.3.4
* add `has_dom_style`

## 0.1.0

* initial version
