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
   
    var body: some View {
       NavigationView{
          Canvas(canvas: $canvas)
             .navigationTitle("Dibujo")
             .navigationBarTitleDisplayMode(.inline)
             
       }.navigationViewStyle(StackNavigationViewStyle())
    }
}


struct Canvas: UIViewRepresentable {
   
   @Binding var canvas: PKCanvasView
   
   func makeUIView(context: Context) -> some PKCanvasView {
      /** here we stablished the drawing policy, basically stated that can be drawing with apple pencil or tap gesture with fingers, if we select .pecilOnly then this will only work on an ipad, otherwise we could use it on iPhone too.  */
      canvas.drawingPolicy = .anyInput
      return canvas
   }
   
   func updateUIView(_ uiView: UIViewType, context: Context) {

   }
}
