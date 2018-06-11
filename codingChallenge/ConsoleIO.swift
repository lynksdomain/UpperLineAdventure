import Foundation


enum messageType {
    case postPlayerInput, prePlayerInput
}


//Console Input and Output Class
class ConsoleIO {
    func printToConsole(message: String, msgType: messageType) {
        switch msgType {
        case .prePlayerInput:
            print(message)
        case .postPlayerInput:
            print("\n" + message + "\n")
        }
    }
    func printChoices(choices: [String]) {
        var numberOfChoice = 1
        for choice in choices {
            print("\(numberOfChoice)." + " \(choice)")
            numberOfChoice += 1
        }
    }
    
    
    func printBattleScene(user: Player, enemy: Enemy) {
        let scene = """
*************************************************
Monster: \(enemy.name)
MonsterHP: \(enemy.hp)
*************************************************
                  VS
*************************************************
\(user.name) The \(user.classType.rawValue)
HP: \(user.hp)
Mana: \(user.mana)
*************************************************

"""
        printToConsole(message: scene, msgType: .prePlayerInput)
    }
    
   
    
    
    func printPlayersMove(moveSet: [(move: String, amount: Int)]){
        printToConsole(message: "What would you like to do?", msgType: .prePlayerInput)
        var moveArr = [String]()
        moveSet.forEach(){moveArr.append($0.move)}
        printChoices(choices: moveArr)
    }
    
}
