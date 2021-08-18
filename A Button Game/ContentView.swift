//
//  ContentView.swift
//  A Button Game
//
//  Created by Luke Drushell on 8/17/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLongPressing = false
    @State private var counter: Double = 0
    @State private var timer: Timer?
    
    @State var goal: Int = Int.random(in: 1...25)
    @State var lastScore: Int = 0
    @State var issue = ""
    var body: some View {
        VStack {
            Text("\(goal)")
                .font(.title)
                .bold()
                .padding(40)
            if issue != "" {
                Text("\(issue)")
                Text("Last Score: \(lastScore)")
                    .padding()
            }
            
            ZStack {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 170, height: 170, alignment: .center)
                Button {
                    if isLongPressing {
                        self.isLongPressing.toggle()
                        self.timer?.invalidate()
                        
                        lastScore = giveScore(counter: counter, goal: Double(goal))
                        if lastScore == 100 {
                            issue = "Too- wait, you got it?"
                        } else if counter > Double(goal) {
                            issue = "Too Long!"
                        } else if counter < Double(goal) {
                            issue = "Too Soon!"
                        }
                        counter = 0
                        goal = Int.random(in: 1...25)
                    }
                } label: {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 150, height: 150, alignment: .center)
                    .scaleEffect(isLongPressing ? 0.95 : 1)
                    .shadow(color: .black, radius: 5, x: 10, y: 10)
                    .background(Color.clear)
                }
                .simultaneousGesture(LongPressGesture(minimumDuration: 0.01).onEnded { _ in
                    self.isLongPressing = true
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                        counter += 0.1
                    })
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func giveScore(counter: Double, goal: Double) -> Int {
    let number = counter.distance(to: goal)
    var output = Int(100-(abs(number)*10))
    if output < 0 {
        output = 0
    }
    return output
}
