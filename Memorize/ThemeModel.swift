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
          items:["🥺","🥳","🫥","🫠","🥹","🤥","😴","🤮","🤠","👺","👹","👻","🤡","💩","💀","☠️","👽","👾","🤖","🎃","🫶🏼","👍🏼","🤌🏼","👌🏻"]),
    Theme(name: "food",
          color: Color.orange,
          dcolor:Color.red,
          items:["🍪","🍩","🍿","🍫","🍬","🍭","🍮","🎂","🍰","🧁","🥧","🍦","🍨","🍡","🍧","🥮","🍗","🍔","🥪","🍟","🍕","🥙"]),
    Theme(name: "plant",
          color: Color.green,
          dcolor:Color(hue: 0.263, saturation: 0.717, brightness: 1.0),
          items:["🌵","🎄","🌲","🌳","🌴","🪵","🌱","🌿","☘️","🍀","🎍","🪴","🎋","🍃","🍂","🍁","🌾","💐","🌷","🌹","🥀","🪷","🌺","🌸","🌼","🌻"])
]
