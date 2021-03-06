//
//  ThemeModel.swift
//  Memorize
//
//  Created by Ken Wang on 2022/5/8.
//

import Foundation
import SwiftUI

struct Theme {
    var name: String
    var color: Color
    var dcolor:Color
    var numberOfPairs: Int?
    var items: [String]
}
let themes: [Theme] = [
    Theme(name: "mood",
          color: Color.yellow,
          dcolor:Color.orange,
          items:["ðĨš","ðĨģ","ðŦĨ","ðŦ ","ðĨđ","ðĪĨ","ðī","ðĪŪ","ðĪ ","ðš","ðđ","ðŧ","ðĪĄ","ðĐ","ð","â ïļ","ð―","ðū","ðĪ","ð","ðŦķðž","ððž","ðĪðž","ððŧ"]),
    Theme(name: "food",
          color: Color.orange,
          dcolor:Color.red,
          items:["ðŠ","ðĐ","ðŋ","ðŦ","ðŽ","ð­","ðŪ","ð","ð°","ð§","ðĨ§","ðĶ","ðĻ","ðĄ","ð§","ðĨŪ","ð","ð","ðĨŠ","ð","ð","ðĨ"]),
    Theme(name: "plant",
          color: Color.green,
          dcolor:Color(hue: 0.263, saturation: 0.717, brightness: 1.0),
          items:["ðĩ","ð","ðē","ðģ","ðī","ðŠĩ","ðą","ðŋ","âïļ","ð","ð","ðŠī","ð","ð","ð","ð","ðū","ð","ð·","ðđ","ðĨ","ðŠ·","ðš","ðļ","ðž","ðŧ"])
]
