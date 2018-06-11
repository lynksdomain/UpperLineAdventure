import Foundation

//PLAYER PROPERTIES

enum playerClasses: String {
    case knight = "Knight"
    case mage = "Mage"
    case hunter = "Hunter"
}


class Player {
    var name: String
    var hp: Int
    var mana: Int
    var knightDefense: Int?
    var hunterHidden: Bool?
    var moveSet: [(move: String, amount: Int)]
    var classType: playerClasses
    
    //Initialize the Player with the appropriate stats depending on the chosen class
    init(name: String, classType: playerClasses) {
        self.name = name
        self.classType = classType
        switch classType {
        case .knight:
            self.moveSet = [(move: "Slash", amount: 25),(move: "Defend", amount: 10), (move: "Run", amount: 0)]
            self.hp = 100
            self.mana = 0
        case .mage:
            self.moveSet = [(move: "FireBall", amount: 30),(move: "Heal", amount: 20), (move: "Run", amount: 0)]
            self.hp = 60
            self.mana = 200
        case .hunter:
            self.moveSet = [(move: "Shoot", amount: 20),(move: "Hide Attack", amount: 19), (move: "Run", amount: 0)]
            self.hp = 75
            self.mana = 100
        }
    }
    
    
    // Secondary Attack
    
    func knightDefend() {
        let points = self.moveSet[1].amount
        self.knightDefense = points
    }
    
    func mageheal() {
         let points = self.moveSet[1].amount
         self.mana = self.mana - self.moveSet[1].amount
         self.hp = self.hp + points
    }
    
    func hunterHide() {
        self.mana = self.mana - self.moveSet[1].amount
        let randNum = arc4random_uniform(4)
        if randNum == 3{
            self.hunterHidden = false
        } else {
            self.hunterHidden = true
        }
    }
}

//ENEMY PROPERTIES

enum Enemies: String {
    case goblin = "Goblin"
    case orc = "Orc"
    case dragon = "Dragon"
}

class Enemy {
    var name: String
    var hp: Int
    var attacks: [(description: String, damage: Int)]
    init(name: String, hp: Int, attacks: [(description: String, damage: Int)]) {
        self.name = name
        self.hp = hp
        self.attacks = attacks
    }
}



