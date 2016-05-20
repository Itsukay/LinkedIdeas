//
//  ElementView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 07/04/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol StringEditableView {
  var textField: ResizingTextField { get }
  var textFieldSize: NSSize { get }
  var isTextFieldFocused: Bool { get set }
  
  func editingString() -> Bool
  func toggleTextFieldEditMode()
  func enableTextField()
  func disableTextField()
  func focusTextField()
  
  func drawString()
  
  func typeText(string: String)
  func pressEnterKey()
  func pressDeleteKey()
  func cancelEdition()
}

extension StringEditableView {
  func editingString() -> Bool {
    return !textField.hidden
  }
  
  func enableTextField() {
    textField.hidden = false
    textField.enabled = true
    focusTextField()
  }
  
  func disableTextField() {
    textField.hidden = true
    textField.enabled = false
  }
  
  func typeText(string: String) {
    textField.stringValue = string
  }
}

protocol CanvasElement {
  var canvas: CanvasView { get }
  
  func pointInCanvasCoordinates(point: NSPoint) -> NSPoint
}

extension CanvasElement {
  func pointInCanvasCoordinates(point: NSPoint) -> NSPoint {
    return canvas.pointInCanvasCoordinates(point)
  }
}

protocol ConceptViewProtocol {
  var concept: Concept { get }
  
  func updateFrameToMatchConcept()
}

protocol DraggableElement {
  var isDragging: Bool { get set }
  var initialPoint: NSPoint? { get set }
  var draggableDelegate: DraggableElementDelegate? { get }
  
  func dragStart(initialPoint: NSPoint, performCallback: Bool)
  func dragTo(point: NSPoint, performCallback: Bool)
  func dragEnd(lastPoint: NSPoint, performCallback: Bool)
}

struct DragEvent {
  let fromPoint: NSPoint
  let toPoint: NSPoint
  
  var deltaX: CGFloat { return toPoint.x - fromPoint.x }
  var deltaY: CGFloat { return toPoint.y - fromPoint.y }
  
  func translatePoint(point: NSPoint) -> NSPoint {
    return point.translate(deltaX, deltaY: deltaY)
  }
}

protocol DraggableElementDelegate {
  func dragStartCallback(draggableElementView: DraggableElement, dragEvent: DragEvent)
  func dragToCallback(draggableElementView: DraggableElement, dragEvent: DragEvent)
  func dragEndCallback(draggableElementView: DraggableElement, dragEvent: DragEvent)
}

protocol ClickableView {
  func click(point: NSPoint)
  func doubleClick(point: NSPoint)
  func shiftClick(point: NSPoint)
}

extension ClickableView {
  func shiftClick(point: NSPoint) {}
}

protocol CanvasConceptsActions {
  func deselectConcepts()
  func removeNonSavedConcepts()
  func createConceptAt(point: NSPoint)
  func markConceptsAsNotEditable()
  func unselectConcepts()
  
  func drawConceptViews()
  func drawConceptView(concept: Concept)
  func clickOnConceptView(conceptView: ConceptView, point: NSPoint, multipleSelect: Bool)
  func updateLinkViewsFor(concept: Concept)
  func conceptLinksFor(concept: Concept) -> [Link]
  func isConceptSaved(concept: Concept) -> Bool
  func removeConceptView(conceptView: ConceptView)
}

protocol CanvasLinkActions {
  func showConstructionArrow()
  func removeConstructionArrow()
  
  func drawLinkViews()
  func drawLinkView(link: Link)
  
  func selectTargetConceptView(point: NSPoint, fromConcept originConcept: Concept) -> ConceptView?
  func createLinkBetweenConceptsViews(originConceptView: ConceptView, targetConceptView: ConceptView)
  func removeLinkView(linkView: LinkView)
  func unselectLinks()
}

protocol BasicCanvas {
  var newConcept: Concept? { get }
  var newConceptView: ConceptView? { get }
  
  var concepts: [Concept] { get }
  var conceptViews: [String: ConceptView] { get set }
  
  var links: [Link] { get }
  var linkViews: [String: LinkView] { get set }
  
  func saveConcept(concept: ConceptView)
  
  func pointInCanvasCoordinates(point: NSPoint) -> NSPoint
  func conceptViewFor(concept: Concept) -> ConceptView
  func linkViewFor(link: Link) -> LinkView
}

// Protocol compositions

typealias Canvas = protocol<BasicCanvas, ClickableView, CanvasConceptsActions, CanvasLinkActions>

// MARK: LinkView

protocol ArrowDrawable {
  func constructArrow() -> Arrow
  func drawArrow()
  func drawArrowBorder()
}

protocol LinkViewActions {
  func selectLink()
}

protocol HoveringView {
  var isHoveringView: Bool { get set }
}

extension HoveringView where Self: NSView {
  var hoverDebug: Bool { return true }
  
  var hoverTrackingArea: NSTrackingArea {
    return NSTrackingArea(
      rect: bounds,
      options: [.MouseEnteredAndExited, .ActiveInKeyWindow],
      owner: self,
      userInfo: nil
    )
  }
  
  func drawHoveringState() {
    if (isHoveringView) {
      NSColor.blueColor().set()
      NSBezierPath(rect: bounds).stroke()
    }
  }
  
  func enableTrackingArea() {
    if (hoverDebug) {
      addTrackingArea(hoverTrackingArea)
    }
  }
}

extension NSView {
  func sprint(message: String) {
    Swift.print("\(description): \(message)")
  }
}