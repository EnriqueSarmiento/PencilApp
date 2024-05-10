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
   
    var body: some View {
       NavigationView{
//          Canvas(canvas: $canvas, color: $color, type: $type)
          Canvas($canvas, $color, $type)
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
   
   /** here we declare de binding variables, THIS WAS WE DO NOT NEED TO CALL OUR STRUCT LIKE Canvas(canvas: $canvas, color: $color) BUT AS Canvas($canvas, $color) this will work for anything like view Models, functions, etc*/
   init(_ canvas: Binding<PKCanvasView>, _ color: Binding<Color>, _ type: Binding<PKInkingTool.InkType>){
     _canvas = canvas
     _color = color
     _type = type
   }
   
   /** here we define our type of pencil or tool for our canvas*/
   //let pencil = PKInkingTool(.pencil, color: .black)
   var pencil: PKInkingTool {
      PKInkingTool(type, color: UIColor(color))
   }
   
   func makeUIView(context: Context) -> some PKCanvasView {
      /** here we stablished the drawing policy, basically stated that can be drawing with apple pencil or tap gesture with fingers, if we select .pecilOnly then this will only work on an ipad, otherwise we could use it on iPhone too.  */
      canvas.drawingPolicy = .anyInput
      /** to change the type of tool or pencil we need to pass it to our canvas*/
      canvas.tool = pencil
   
      return canvas
   }
   
   /** here we assure us that the view will update when pencil is changed*/
   func updateUIView(_ uiView: UIViewType, context: Context) {
      uiView.tool = pencil
   }
}
