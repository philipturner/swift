// RUN: %target-swift-frontend -parse-as-library -O -module-name=test %s -emit-sil | %FileCheck %s
// REQUIRES: optimized_stdlib,swift_stdlib_no_asserts

final class Item {}

final public class Escaper {
  var myItem: Item = Item()

  @inline(never)
  func update(items: [Item]) {
    myItem = items[0]
  }

// CHECK-LABEL: sil [noinline] @$s4test7EscaperC15badStuffHappensyyF : $@convention(method) (@guaranteed Escaper) -> () {
// CHECK: %2 = alloc_ref $Item
// CHECK: alloc_ref_dynamic [stack] [tail_elems $Item * %{{[0-9]+}} : $Builtin.Word]{{.*}} $_ContiguousArrayStorage<Item>
// CHECK: return
  @inline(never)
  public func badStuffHappens() {
    // Check that 'item' is not stack promoted, because it escapes to myItem.
    let item = Item()
    // On the other hand, the array buffer of the array literal should be stack promoted.
    update(items:[item])
  }
}

