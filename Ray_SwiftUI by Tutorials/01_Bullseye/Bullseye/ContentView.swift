//
//  ContentView.swift
//  Bullseye
//
//  Created by Михаил Дмитриев on 08.04.2020.
//  Copyright © 2020 Mikhail Dmitriev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // Colors
    let midnightBlue = Color(red: 0, green: 0.2, blue: 0.4)
    
    // Properties
    // ==========
    // Game Stats
    @State var score = 0
    @State var round = 1
    
    
    // User interface views
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    var sliderValueRounded: Int {
        return Int(sliderValue.rounded())
    }
    var sliderTargetDifference: Int {
        return abs(Int(sliderValueRounded) - target)
    }
    
    
    // User interface content and layout
    var body: some View {
        NavigationView {
            VStack {
                Spacer().navigationBarTitle(" 🍎Bullseye🍎 ")
                
                // Target row
                HStack {
                    Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
                    Text("\(target)").modifier(ValueStyle())
                }
                
                Spacer()
                
                // Slider row
                HStack {
                    Text("1").modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 1...100)
                        .animation(.easeOut)
                        .accentColor(Color.green)
                    Text("100").modifier(LabelStyle())
                }
                
                Spacer()
                
                // Button row
                Button(action: {
                    self.alertIsVisible = true
                }) {
                    Text("HIT ME!").modifier(ButtonLargeTextStyle())
                }
                    //Отображение кнопки
                    .background(Image("Button"))
                    .modifier(Shadow())
                    // Alert
                    .alert(isPresented:$alertIsVisible) {
                        Alert(title: Text(alertTitle()),
                              message: Text(scoringMessage()),
                              dismissButton: .default(Text("Awesome")) {
                                self.startNewRound()
                            })
                }
                
                Spacer()
                
                // Score row
                HStack {
                    Button(action: {
                        self.startNewGame()
                    }) {
                        HStack {
                            Image("StartOverIcon")
                            Text("Start Over").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button"))
                    .modifier(Shadow())
                    
                    Spacer()
                    Text("Score:").modifier(LabelStyle())
                    Text("\(score)").modifier(ValueStyle())
                    Spacer()
                    Text("Round:").modifier(LabelStyle())
                    Text("\(round)").modifier(ValueStyle())
                    Spacer()
                    
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image("InfoIcon")
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button"))
                    .modifier(Shadow())
                }
                .padding(.bottom, 20)
                    //Цвет для всего вида??
                .accentColor(midnightBlue)
            }
            //Действия при первом запуске
            .onAppear() {
            self.startNewGame()
            }
            .background(Image("Background"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Methods
    // =======
    //Количество очков
    func pointsForCurrentRound() -> Int {
        let maximumScore = 100
        //Логика получения бонусов
        let points: Int
        if sliderTargetDifference == 0 {
            points = 200
        } else if sliderTargetDifference == 1 {
            points = 150
        } else {
            points = maximumScore - sliderTargetDifference
        }
        return points
    }
    
    //Score сообщение
    func scoringMessage() -> String {
        return  "The slider's value is \(Int(sliderValueRounded))\n" +
                "The target value is \(target)\n" +
                "You scored: \(pointsForCurrentRound())"
    }
    
    //Title сообщение
    func alertTitle() -> String {
        let title: String
        if sliderTargetDifference == 0 {
            title = "Perfect"
        } else if sliderTargetDifference < 5 {
            title = "You almost had it"
        } else if sliderTargetDifference <= 10 {
            title = "Not bad"
        } else {
            title = "Are you even trying?"
        }
        return title
    }
    
    //Перезапуск игры
    func startNewGame() {
        score = 0
        round = 1
        resetSliderAndTarget()
    }
    
    //Новый раунд
    func startNewRound() {
        score += self.pointsForCurrentRound()
        round += 1
        resetSliderAndTarget()
    }
    
    //Сброс слайдера и цели
    func resetSliderAndTarget() {
        sliderValue = Double.random(in: 1...100)
        target = Int.random(in: 1...100)
    }
}

// View modifiers
// ==============
struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.white)
            .modifier(Shadow())
    }
}

struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
    }
}

struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
}

struct ButtonLargeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.black)
    }
}

struct ButtonSmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 12))
            .foregroundColor(Color.black)
    }
}


// Preview
// =======
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




