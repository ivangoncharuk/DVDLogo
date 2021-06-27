//
//  ContentView.swift
//  DVDLogo
//
//  Created by Ivan Goncharuk on 6/25/21.
//

import SwiftUI
struct ContentView: View {
    let timer = Timer.publish(every: 0.005, on: .main, in: .common).autoconnect()
    //2560 × 1600
    let geoWidth: CGFloat = 2560/4
    let geoHeight: CGFloat = 1600/4
    @State var pos = (x: CGFloat.random(in: 50...600), y: CGFloat.random(in: 50...400))
    @State var xspeed: CGFloat = 0.6 // * 1.5 (to make it hit corner)
    @State var yspeed: CGFloat = 0.5
    @State var color: Color = randomColor()
    @State var wallHits = 0
    @State var cornerHits = 0
    
    static func randomColor() -> Color {
        return Color(.displayP3,
                     red: Double.random(in: 0.3...1),
                     green: Double.random(in: 0.3...1),
                     blue: Double.random(in: 0.3...1),
                     opacity: 1)
    }
    func updateColor() {
        color = ContentView.randomColor()
        wallHits += 1
    }
    
    var body: some View {
        //w: 600, h: 400
        
        GeometryReader {_ in
            ZStack {
                let height: CGFloat = geoHeight/5
                let width: CGFloat = geoWidth/5
                Color(#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1))
                Image("dvdlogo")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(color)
                    .frame(width: width, height: height)
                    .position(x: CGFloat(pos.x), y: CGFloat(pos.y))
                    .onReceive(timer){ _ in
                        
                        pos.x += xspeed
                        pos.y += yspeed
                        if pos.x >= geoWidth - width/2 {
                            xspeed = -xspeed
                            pos.x = geoWidth - width/2
                            updateColor()
                            
                        } else if pos.x <= 0 + width/2 {
                            xspeed = -xspeed
                            pos.x = 0 + width/2
                            updateColor()
                        }
                        
                        if pos.y >= geoHeight - height/2 {
                            yspeed = -yspeed
                            pos.y = geoHeight - height/2
                            updateColor()
                            
                        } else if pos.y <= 0 + height/2{
                            yspeed = -yspeed
                            pos.y = 0 + height/2
                            updateColor()
                        }
                        
                        if (pos.x >= geoWidth - width/2 &&
                                pos.y >= geoHeight - height/2) ||
                            (pos.x <= 0 + width/2 &&
                                pos.y <= 0 + height/2) {
                            cornerHits += 1
                            wallHits -= 2 // 2 because it counts as 2 wall hits
                        }
                        
                    }
                
                VStack(alignment: .trailing){
                    Text("wall hits: \(wallHits)")
                    Text("corner hits: \(cornerHits)")
                }
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)))
            
            }
        }
        .frame(width: geoWidth, height: geoHeight, alignment: .center)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
