import Foundation

enum AuthDataFlags {
   static let up: UInt8   = 0x01
   static let rfu1: UInt8 = 0x02
   static let uv: UInt8   = 0x04
   static let be: UInt8   = 0x08
   static let bs: UInt8   = 0x10
   static let rfu2: UInt8 = 0x20
   static let at: UInt8   = 0x40
   static let ed: UInt8   = 0x80
}
