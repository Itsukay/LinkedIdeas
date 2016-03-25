//
//  Concept.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

//class Concept: NSObject, NSCoding {
//  static let placeholderString = "Insert Concept"
//
//  var stringValue: String = ""
//  var point: NSPoint
//  var added: Bool = false
//  var editing: Bool = false
//  var identifier: Int
//  var rect: NSRect {
//    return NSRect(center: point, size: stringValue.sizeWithAttributes(nil))
//  }


//
//  init(point: NSPoint) {
//    self.point = point
//    self.identifier = random()
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    point = aDecoder.decodePointForKey(pointKey)
//    identifier = aDecoder.decodeIntegerForKey(identifierKey)
//    editing = aDecoder.decodeBoolForKey(editingKey)
//    print("concept editing=\(editing)")
//    let string = aDecoder.decodeObjectForKey(stringValueKey) as? String
//    if let string = string {
//      stringValue = string
//    }
//  }
//
//  func encodeWithCoder(aCoder: NSCoder) {
//    aCoder.encodePoint(point, forKey: pointKey)
//    aCoder.encodeObject(stringValue, forKey: stringValueKey)
//    aCoder.encodeInteger(identifier, forKey: identifierKey)
//    aCoder.encodeBool(editing, forKey: editingKey)
//  }
//
//  func isEmpty() -> Bool {
//    return stringValue == "" || stringValue == Concept.placeholderString
//  }
//
//  func draw() {
//    stringValue.drawAtPoint(rect.origin, withAttributes: nil)
//  }
//
//}

protocol Element {
  var identifier: String { get }
  var stringValue: String { get  set }
  var minimalRect: NSRect { get }
}

protocol VisualElement {
  var isEditable: Bool { get set }
  var isSelected: Bool { get set }
}

class Concept: NSObject, NSCoding, Element, VisualElement {
  var point: NSPoint
  // element
  var identifier: String
  var stringValue: String
  var minimalRect: NSRect { return NSRect(center: point, size: NSMakeSize(60, 20)) }
  // visual element
  var isEditable: Bool = false
  var isSelected: Bool = false
  
  // NSCoding
  let stringValueKey = "stringValueKey"
  let pointKey = "pointKey"
  let identifierKey = "identifierKey"
  let isEditableKey = "isEditableKey"
  
  override var description: String {
    return "[\(identifier)] '\(stringValue)' \(isEditable) \(point)"
  }
  
  convenience init(point: NSPoint) {
    self.init(stringValue: "", point: point)
  }
  
  init(stringValue: String, point: NSPoint) {
    self.point = point
    self.identifier = "\(random())-concept"
    self.stringValue = stringValue
  }
  
  // MARK: - NSCoding
  
  required init?(coder aDecoder: NSCoder) {
    point       = aDecoder.decodePointForKey(pointKey)
    identifier  = aDecoder.decodeObjectForKey(identifierKey) as! String
    isEditable  = aDecoder.decodeBoolForKey(isEditableKey)
    stringValue = aDecoder.decodeObjectForKey(stringValueKey) as! String
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodePoint(point, forKey: pointKey)
    aCoder.encodeObject(stringValue, forKey: stringValueKey)
    aCoder.encodeObject(identifier, forKey: identifierKey)
    aCoder.encodeBool(isEditable, forKey: isEditableKey)
  }
}