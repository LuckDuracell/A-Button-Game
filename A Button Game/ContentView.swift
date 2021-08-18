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
    @State var showRetry = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(goal)")
                .font(.title)
                .bold()
                .padding(40)
            if issue != "" {
                Text("\(issue)")
                Text("Score: \(lastScore)")
                    .padding()
            } else {
                Text(" ")
                Text(" ")
                    .padding()
            }
            
            ZStack {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 170, height: 170, alignment: .center)
                Button {
                    if isLongPressing {
                        if showRetry == false {
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
                            showRetry = true
                        }
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
                    if showRetry == false {
                        self.isLongPressing = true
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                            counter += 0.1
                        })
                    }
                })
            }
            Spacer()
            Button {
                if showRetry {
                    counter = 0
                    goal = Int.random(in: 1...25)
                    issue = ""
                    showRetry = false
                }
            } label: {
                Text(showRetry ? "Retry" : " ")
                    .padding()
            }
            Spacer()
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
