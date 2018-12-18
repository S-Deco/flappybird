//
//  GameScene.swift
//  flappybird
//
//  Created by Sam DeCosta on 12/17/18.
//  Copyright © 2018 Sam DeCosta. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let Wall : UInt32 = 0x1 << 1
    static let Bird : UInt32 = 0x1 << 2
    
}

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var jump = 0
    var gameStarted = false
    var scoreLabel = SKLabelNode()
    var score = 0

    
    override func didMove(to view: SKView) {
        bird = self.childNode(withName: "bird") as! SKSpriteNode
        scoreLabel = self.childNode(withName:"score") as! SKLabelNode
        scoreLabel.position.y = self.size.height/4
        bird.position.y = 0
        bird.position.x = -self.size.width/3
        bird.physicsBody?.collisionBitMask = PhysicsCategory.Wall
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
        bird.physicsBody?.categoryBitMask = PhysicsCategory.Bird
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.mass = 0.1
    }
    func createWall(){
        let wall = SKNode()
        let randPoint = Int.random(in: Int(-self.size.height/2 + 10)...Int(self.size.height/2 - 10))
        let randWidth = Int.random(in: 80...Int(self.size.height/2))
        let top = SKSpriteNode(imageNamed: "wall")
        let bottom = SKSpriteNode(imageNamed:"wall")
        top.size = CGSize(width: 60, height: self.size.height)
        bottom.size = (CGSize(width: 60, height: self.size.height))
        
        top.physicsBody = SKPhysicsBody(rectangleOf: top.size)
        top.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        top.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        top.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        top.physicsBody?.isDynamic = false
        top.physicsBody?.affectedByGravity = false
        
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.size)
        bottom.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        bottom.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        bottom.physicsBody?.contactTestBitMask = PhysicsCategory.Bird
        bottom.physicsBody?.isDynamic = false
        bottom.physicsBody?.affectedByGravity = false
        
        
        
        top.position = CGPoint(x: self.size.width/2 + 10, y: CGFloat(randPoint + Int(self.size.height/2) + 80))
        bottom.position = CGPoint(x: self.size.width/2 + 10, y: CGFloat(randPoint - Int(self.size.height/2) - randWidth))
        
        wall.addChild(top)
        wall.addChild(bottom)
        
        self.addChild(wall)
        wall.run(SKAction.moveTo(x: -self.size.width - 80, duration: 2.5))
        

        
    }
    func startSpawn(){
        let wait = SKAction.wait(forDuration: 1.7)
        let spawn = SKAction.run {
            self.createWall()
        }
        let delay = SKAction.sequence([wait,spawn])
        let delayForever = SKAction.repeatForever(delay)
        
        self.run(delayForever)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.size.height/15))
        if gameStarted == false
        {
            gameStarted = true
            startSpawn()
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {

    }
}
