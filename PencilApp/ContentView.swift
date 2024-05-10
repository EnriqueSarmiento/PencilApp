//
//  ContentView.swift
//  PencilApp
//
//  Created by Enrique Sarmiento on 10/5/24.
//

import SwiftUI
import PencilKit

struct ContentView: View {
   
   @State private var canvas = PKCanvasView()
   /** varriable to allow user to select a tool type and color*/
   @State private var color: Color = .black
   @State private var type : PKInkingTool.InkType = .pencil
   @State private var isDrawing: Bool = true
   
   func saveImage(){
      let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
   }
   
    var body: some View {
       NavigationView{
//          Canvas(canvas: $canvas, color: $color, type: $type)
          Canvas($canvas, $color, $type, $isDrawing)
             .navigationTitle("Dibujo")
             .navigationBarTitleDisplayMode(.inline)
             .toolbar{
                HStack{
                   ColorPicker("",selection: $color)
                   ButtonView(action: {
                      type = .pencil
                   }, icon: "pencil")
                   
                   ButtonView(action: {
                      type = .pen
                   }, icon: "pencil.tip")  
                   ButtonView(action: {
                      type = .marker
                   }, icon: "highlighter")
                   ButtonView(action: {
                      isDrawing.toggle()
                   }, icon: "pencil.slash")
                   /** this button ERASE ALL CONTENT*/
                   ButtonView(action: {
                      canvas.drawing = PKDrawing()
                   }, icon: "trash")
                   
                   ButtonView(action: {
                     saveImage()
                   }, icon: "square.and.arrow.down.fill" )
                }
             }
             
       }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ButtonView : View {
   
   var action: (() -> Void)
   var icon: String

   
   var body: some View {
      Button {
         action()
      } label: {
         Image(systemName: icon)
      }

   }
}


struct Canvas: UIViewRepresentable {
   
   @Binding var canvas: PKCanvasView
   @Binding var color: Color
   @Binding var type : PKInkingTool.InkType
   @Binding var isDrawing: Bool
   
   @State private var toolPicker = PKToolPicker()
   
   /** here we declare de binding variables, THIS WAS WE DO NOT NEED TO CALL OUR STRUCT LIKE Canvas(canvas: $canvas, color: $color) BUT AS Canvas($canvas, $color) this will work for anything like view Models, functions, etc*/
   init(_ canvas: Binding<PKCanvasView>, _ color: Binding<Color>, _ type: Binding<PKInkingTool.InkType>, _ isDrawing: Binding<Bool>){
     _canvas = canvas
     _color = color
     _type = type
      _isDrawing = isDrawing
   }
   
   /** here we define our type of pencil or tool for our canvas*/
   //let pencil = PKInkingTool(.pencil, color: .black)
   var pencil: PKInkingTool {
      PKInkingTool(type, color: UIColor(color))
   }
   
   /** to earese content */
   let eraser = PKEraserTool(.bitmap)
   
   func makeUIView(context: Context) -> some PKCanvasView {
      /** here we stablished the drawing policy, basically stated that can be drawing with apple pencil or tap gesture with fingers, if we select .pecilOnly then this will only work on an ipad, otherwise we could use it on iPhone too.  */
      canvas.drawingPolicy = .anyInput
      /** to change the type of tool or pencil we need to pass it to our canvas*/
      canvas.tool = isDrawing ? pencil : eraser
      /** we call the function that will render the native tool picker*/
      showToolPicker()
      return canvas
   }
   
   /** here we assure us that the view will update when pencil is changed*/
   func updateUIView(_ uiView: UIViewType, context: Context) {
      uiView.tool = isDrawing ? pencil : eraser
   }
}

extension Canvas{
   
   /** we will add an extension function that will popup the native tool picker from PencilKit*/
   func showToolPicker(){
      toolPicker.setVisible(true, forFirstResponder: canvas)
      toolPicker.addObserver(canvas)
      canvas.becomeFirstResponder()
   }
   
}
