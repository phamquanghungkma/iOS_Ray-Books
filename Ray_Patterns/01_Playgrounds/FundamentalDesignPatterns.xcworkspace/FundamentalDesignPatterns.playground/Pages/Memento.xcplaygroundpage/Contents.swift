/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Memento
 - - - - - - - - - -
 ![Memento Diagram](Memento_Diagram.png)
 
 The memento pattern allows an object to be saved and restored. It involves three parts:
 
 (1) The **originator** is the object to be saved or restored.
 
 (2) The **memento** is a stored state.
 
 (3) The **caretaker** requests a save from the originator, and it receives a memento in response. The care taker is responsible for persisting the memento, so later on, the care taker can provide the memento back to the originator to request the originator restore its state.
 
 ## Code Example
 */
import Foundation
// MARK: - Originator
public class Game: Codable {
    public class State: Codable {
        public var attemptsRemaining: Int = 3
        public var level: Int = 1
        public var score: Int = 0
    }
    public var state = State()
    public func rackUpMassivePoints() {
        state.score += 9002 }
    public func monstersEatPlayer() {
        state.attemptsRemaining -= 1 }
}

// MARK: - Memento
typealias GameMemento = Data


// MARK: - CareTaker
public class GameSystem {
    // 1 You first declare properties for decoder, encoder and userDefaults. You’ll use decoder to decode Games from Data, encoder to encode Games to Data, and userDefaults to persist Data to disk. Even if the app is re-launched, saved Game data will still be available.
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard
    
    // 2 save(_:title:) encapsulates the save logic. You first use encoder to encode the passed-in game. This operation may throw an error, so you must prefix it with try. You then save the resulting data under the given title within userDefaults.
    public func save(_ game: Game, title: String) throws {
        let data = try encoder.encode(game)
        userDefaults.set(data, forKey: title)
    }
    // 3 load(title:) likewise encapsulates the load logic. You first get data from userDefaults for the given title. You then use decoder to decode the Game from the data. If either operation fails, you throw a custom error for Error.gameNotFound. If both operations succeed, you return the resulting game.
    public func load(title: String) throws -> Game {
        guard let data = userDefaults.data(forKey: title),
        let game = try? decoder.decode(Game.self, from: data) else {
            throw Error.gameNotFound
        }
        return game
    }
    public enum Error: String, Swift.Error {
        case gameNotFound
    }
}

// MARK: - Example

var game = Game()
game.monstersEatPlayer()
game.rackUpMassivePoints()

// Save Game
let gameSystem = GameSystem()
try gameSystem.save(game, title: "Best Game Ever")

// New Game
game = Game()
print("New Game Score: \(game.state.score)")


// Load Game
game = try! gameSystem.load(title: "Best Game Ever")
print("Loaded Game Score: \(game.state.score)")
