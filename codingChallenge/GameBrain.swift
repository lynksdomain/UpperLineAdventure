import Foundation

class GameBrain {
    private let console = ConsoleIO()
    private var currentUser: Player?
    private let classOptions = ["Knight","Mage","Hunter"]
    private let choiceRef = ["1","2","3"]
    
    
    
    // PLAYER SET UP
    func userSetUp() {
        let namePicked =  nameSelection()
        let classPicked = classSelection()
        currentUser = Player.init(name: namePicked, classType: classPicked)
    }
    
    private func nameSelection() -> String {
        var nameIsSet = false
        var name: String?
        while !nameIsSet {
            console.printToConsole(message: "Please Enter Your Name", msgType: .prePlayerInput)
            let namePicked = readLine()
            if namePicked != " " {
                name = namePicked
                nameIsSet = true
            }
        }
        return name!
    }
    
    private func classSelection() -> playerClasses {
        var classIsSet = false
        var playerClass: playerClasses?
        while !classIsSet {
            console.printToConsole(message: "Select a class by entering the corresponding number ", msgType: .postPlayerInput)
            console.printChoices(choices: classOptions)
            let classPicked = readLine()
            switch classPicked {
            case "1" :
                playerClass = .knight
                classIsSet = true
            case "2" :
                playerClass = .mage
                classIsSet = true
            case "3" :
                playerClass = .hunter
                classIsSet = true
            default:
                classIsSet = false
            }
        }
        return playerClass!
    }
    
    
    
    
    // TOWER PORTION OF GAME
    
    
    func enterTower() {
        console.printToConsole(message: "Welcome \(currentUser!.name) The \(currentUser!.classType.rawValue) to the Tower Of Doom", msgType: .prePlayerInput)
        console.printToConsole(message: "You enter the tower and a goblin wearing bifocals attacks!", msgType: .prePlayerInput)
        battle(enemyType: .goblin)
        // Balancing is hard. Added a bonus hp / mana boost after fights
        restoreCharacter()
        console.printToConsole(message: "After slaying the goblin you climb up the tower", msgType: .postPlayerInput)
        console.printToConsole(message: "In the next floor, you see the master chamber guarded by an Orc", msgType: .prePlayerInput)
        console.printToConsole(message: "It gives out a war cry and attacks!", msgType: .prePlayerInput)
        battle(enemyType: .orc)
        restoreCharacter()
        console.printToConsole(message: "The orc falls down and you make your way into the chamber", msgType: .postPlayerInput)
        console.printToConsole(message: "This is a fantasy game right? Okay dragon time", msgType: .prePlayerInput)
        console.printToConsole(message: "You interrupt the dragon's movie time and it is mad. It attacks!", msgType: .prePlayerInput)
        battle(enemyType: .dragon)
    }
    
    
    
    
    // Main Battle Functions.
    private func battle(enemyType: Enemies) {
        //Initialize the enemy using enum reference
        let enemy = setUpEnemy(enemy: enemyType)
        //Coin flip to see if player strikes first
        if userIsFirst() {
            playersTurn(enemy: enemy)
        }
        // Main loop for battle. Player dying or enemy dying are the way out of loop.
        while currentUser!.hp > 0 {
            if enemy.hp <= 0 {
                return
            }
            enemysTurn(enemy: enemy)
            if (currentUser?.hp)! <= 0 {
                print("you lose")
                exit(0)
            }
            playersTurn(enemy: enemy)
        }
        print("you lose")
        exit(0)
    }
    
    
    private func playersTurn(enemy: Enemy) {
        console.printBattleScene(user: currentUser!, enemy: enemy)
        console.printPlayersMove(moveSet: currentUser!.moveSet)
        var choiceMade = false
        var ranAwayFromMonster = false
        // Choice loop to ensure player picks an action
        while !choiceMade {
            let choice = readLine()
            if !choiceRef.contains(choice!) {
                continue
            } else {
                //All classes can run
                if choice == "3" {
                    ranAwayFromMonster = runAttempt()
                    if ranAwayFromMonster { break }
                    choiceMade = true
                } else {
                    if currentUser!.classType != .knight {
                        //Mana Check for Mage and Hunter
                        if (currentUser?.mana)! <= 0 {
                            console.printToConsole(message: "No Mana", msgType: .postPlayerInput)
                            continue
                        }
                    }
                    calculateMove(moveChoice: choice!, enemy: enemy)
                    choiceMade = true
                }
                continue
            }
        }
    }
    
    
   private func enemysTurn(enemy: Enemy) {
        let randNum = arc4random_uniform(UInt32(enemy.attacks.count))
        let move = enemy.attacks[Int(randNum)]
        // Calculate status effects such as Hunter's hide and Knight's defend. Otherwise just attack
        switch currentUser!.classType {
        case .knight:
            if currentUser?.knightDefense != nil {
                if (currentUser?.knightDefense)! >= move.damage {
                    console.printToConsole(message: "Your defense was too strong for the enemy", msgType: .postPlayerInput)
                    currentUser?.knightDefense = nil
                    return
                }
                let attackDMG = move.damage - (currentUser?.knightDefense)!
                currentUser?.knightDefense = nil
                currentUser?.hp = (currentUser?.hp)! - attackDMG
                console.printToConsole(message: move.description, msgType: .postPlayerInput)
            } else {
                currentUser?.hp = (currentUser?.hp)! - move.damage
                console.printToConsole(message: move.description, msgType: .postPlayerInput)
            }
        case .hunter:
            if currentUser?.hunterHidden != nil {
                print("You attack the \(enemy.name) while it was looking for you")
                enemy.hp = enemy.hp - (currentUser?.moveSet[1].amount)!
                currentUser?.hunterHidden = nil
                
            } else {
                currentUser?.hp = (currentUser?.hp)! - move.damage
                console.printToConsole(message: move.description, msgType: .postPlayerInput)
            }
        default:
            currentUser?.hp = (currentUser?.hp)! - move.damage
            console.printToConsole(message: move.description, msgType: .postPlayerInput)
        }
    }
    
    
    // Helper Battle Functions
    
    
    private func youLose() {
        console.printToConsole(message: "Womp Womp. You lose!", msgType: .postPlayerInput)
        exit(0)
    }
    
    
   private func runAttempt() -> Bool {
        let randNum = arc4random_uniform(100)
        if randNum == 26 {
            console.printToConsole(message: "You got away!", msgType: .postPlayerInput)
            return true
        }
        console.printToConsole(message: "Couldn't run", msgType: .postPlayerInput)
        return false
    }
    
    
    private func calculateMove(moveChoice: String, enemy: Enemy) {
        switch moveChoice {
        case "1" :
            enemy.hp = enemy.hp - (currentUser?.moveSet[0].amount)!
            if currentUser!.classType == .mage {
                currentUser?.mana = (currentUser?.mana)! - ((currentUser?.moveSet[0].amount)! / 2)
            }
            print("you used \((currentUser?.moveSet[0].move)!) for \((currentUser?.moveSet[0].amount)!) points")
        case "2" :
            switch currentUser!.classType {
            case .knight:
                currentUser?.knightDefend()
            case .mage:
                currentUser?.mageheal()
            case .hunter:
                currentUser?.hunterHide()
            }
        default:
            return
        }
    }
    
    private func restoreCharacter() {
        self.currentUser?.hp += 20
        if currentUser!.classType != .knight {
            self.currentUser?.mana += 20
        }
    }
    
    
    private func setUpEnemy(enemy: Enemies) -> Enemy {
        switch enemy {
        case .goblin:
            return Enemy.init(name: enemy.rawValue, hp: 20, attacks: [(description: "The Goblin charges forward and slips... it still hits you!", damage: 2),
                                                                      (description: "The Goblin slashes with his claws but then he remember he cut them earlier today", damage: 3)
                ])
        case .orc:
            return Enemy.init(name: enemy.rawValue, hp: 100, attacks: [(description: "The Orc wants to impress his date with his club, so he punches you instead!", damage: 10),
                                                                       (description: "The Orc does a super hero landing and feels confident. He attacks!", damage: 15),
                                                                       (description: "The Orc burps. It's gross", damage: 10)
                ])
        case .dragon:
            return Enemy.init(name: enemy.rawValue, hp: 150, attacks: [(description: "It is a dragon. It breathes fire duh.", damage: 20),
                                                                       (description: "The dragon watches Shrek. It's cries. So it smacks you with its tail", damage: 10)
                ])
            
        }
    }
    
    private func userIsFirst() -> Bool {
        let randNum = arc4random_uniform(2)
        return randNum == 0
        
    }
    
    //Player Wins
    func playerBeatsTower() {
        console.printToConsole(message: "The dragon is no more", msgType: .postPlayerInput)
        console.printToConsole(message: "You dab in celebration but then quickly realize you would never do that", msgType: .prePlayerInput)
        console.printToConsole(message: "You wake up at your terminal and make a note to get more sleep... then you go back to coding.", msgType: .prePlayerInput)
    }
}














