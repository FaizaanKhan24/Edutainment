//
//  ContentView.swift
//  Edutainment
//
//  Created by Faizaan Khan on 12/8/22.
//

import SwiftUI

struct ContentView: View {
    
    // Question menu variables
    @State private var selectedTable = 7
    @State private var questionCounts = [5, 10, 20]
    @State private var selectedQuestionsCount = 5
    @State private var isGameON = false
    
    // Game related variables
    @State private var questionCollection = [Question]()
    @State private var userScore = 0
    @State private var currentQuestionNumber = 0
    @State private var isAnswered = false
    @State private var answer = ""
    @State private var currentQuestion : Question = Question(questionText: "What is 1 x 7?", answer: "7")
    
    // Alert Variables
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isRestartGame = false
    
    struct Question{
        var questionText: String
        var answer: String
    }
    
    var body: some View {
        NavigationView(){
            ZStack{
                Color.white.ignoresSafeArea()
                
                VStack{
                    if isGameON{
                        VStack{
                            Text("Question: \(currentQuestionNumber + 1)/\(selectedQuestionsCount)")
                                .font(.title)
                               
                            Spacer()
                            
                            Text("Your Score: \(userScore)")
                                .font(.title3)
                                .fontWeight(.thin)
                            
                            Spacer()
                            
                            Text(currentQuestion.questionText)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            TextField("Question" ,text: $answer, prompt: Text("Enter your answer"))
                                .textFieldStyle(.roundedBorder)
                                .font(.title2)
                                .fontWeight(.bold)
                                .keyboardType(.numberPad)
                                .padding()
                                                            
                            Spacer()
                            
                            Button("Next"){
                                // Show next answer
                                isAnswered.toggle()
                                submitAnswer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                        }
                        .padding()
                    }
                    else{
                        VStack{
                            Form{
                                Section("Table"){
                                    Picker("Table", selection: $selectedTable){
                                        ForEach(2...12, id: \.self){
                                            Text("\($0)")
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                }
                                
                                Section("Number of questions"){
                                    Picker("Questions count", selection: $selectedQuestionsCount){
                                        ForEach(questionCounts, id: \.self){
                                            Text("\($0)")
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                    
                                }
                            }
                            
                            
                            Button("Start"){
                                isGameON.toggle()
                                StartGame()
                            }
                            .frame(width: 150, height: 50)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                        }
                    }
                }
            }
            .navigationTitle("Edutron")
        }
        .alert(alertTitle, isPresented: $isAnswered){
            Button("Next Question", action: NextQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert("Game over", isPresented: $isRestartGame){
            Button("Restart Game", action: RestartGame)
        } message: {
            Text("You have completed the game")
        }
    }
    
    func StartGame(){
        var count = 0
        while (count < selectedQuestionsCount){
            let table = Int.random(in: 2...selectedTable)
            let multiple = Int.random(in: 2...12)
            let newQuestion = Question(questionText: "What is \(table) x \(multiple) ?", answer: String(table*multiple))
            questionCollection.append(newQuestion)
            count += 1
        }
        
        currentQuestion = questionCollection[currentQuestionNumber]
    }
    
    func AnswerQuestion(){
        
    }
    
    func submitAnswer(){
        if answer == currentQuestion.answer{
            userScore += 1
            alertTitle = "Correct Answer!"
            alertMessage = "You're answer is correct"
        }
        else{
            alertTitle = "Sorry! Wrong answer"
            alertMessage = "You need to practice, that's a wrong answer"
        }
    }
    
    func NextQuestion(){
        currentQuestionNumber += 1
        answer = ""
        if currentQuestionNumber < selectedQuestionsCount{
            currentQuestion = questionCollection[currentQuestionNumber]
        }
        else{
            currentQuestionNumber = 0
            isRestartGame.toggle()
            currentQuestion = Question(questionText: "", answer: "")
        }
    }
    
    func RestartGame(){
        userScore = 0
        isGameON.toggle()
        selectedTable = 7
        selectedQuestionsCount = 5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
