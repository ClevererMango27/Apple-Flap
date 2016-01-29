//
//  GameScene.swift
//  Apple Flap
//
//  Created by Brendon Ho on 1/5/16.
//  Copyright (c) 2016 VGames. All rights reserved.
//

import SpriteKit

struct physicsIsHard{
    static var dude:UInt32 = 0x1 << 1
    static var pipe:UInt32 = 0x1 << 1
    static var scoreDuh: UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var pipe = SKSpriteNode()
    var dude = SKSpriteNode()
    var background = SKSpriteNode()
    var pipePair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarts = Bool()
    var pipeTouched = Bool()
    var score = Int()
    var scoreLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        //Score Label
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLabel.text = "\(score)"
        
        //Background LOL
        background = SKSpriteNode(imageNamed: "jonyive")
        background.setScale(1.0)
        background.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        background.zPosition = 0
       
        
        //Dude
        dude = SKSpriteNode(imageNamed: "alogo")
        dude.size = CGSize(width:60, height: 70)
        dude.position = CGPoint(x: self.frame.width / 2 - dude.frame.width, y: self.frame.height / 2)
        dude.physicsBody = SKPhysicsBody(circleOfRadius: dude.frame.height / 2)
        dude.physicsBody?.categoryBitMask = physicsIsHard.dude
        dude.physicsBody?.collisionBitMask = physicsIsHard.pipe
        dude.physicsBody?.contactTestBitMask = physicsIsHard.dude | physicsIsHard.pipe | physicsIsHard.scoreDuh
        dude.physicsBody?.affectedByGravity = false
        dude.physicsBody?.dynamic = true
        dude.zPosition = 2
        self.addChild(dude)
        
        
    }
    //Contact Starts Function
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == physicsIsHard.scoreDuh && secondBody.categoryBitMask == physicsIsHard.dude || firstBody.categoryBitMask == physicsIsHard.dude && secondBody.categoryBitMask == physicsIsHard.scoreDuh{
            
            score++
            print(score)
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       dude.physicsBody?.velocity = CGVectorMake(0,0)
        dude.physicsBody?.applyImpulse(CGVectorMake(0, 110))
        
        //Touched
        if gameStarts == false{
            
            gameStarts = true
            
            dude.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.runBlock({
                () in
                
                self.createPipe()
                
            })
            
            //Spawn Nodes
            let space = SKAction.waitForDuration(2)
            let spawnSpace = SKAction.sequence([spawn, space])
            let spawnSpaceInfiniteTimeLikeForever = SKAction.repeatActionForever(spawnSpace)
            self.runAction(spawnSpaceInfiniteTimeLikeForever)
            let distance = CGFloat(self.frame.width + pipePair.frame.width)
            let movePipes = SKAction.moveByX(-distance, y: 0.0, duration: NSTimeInterval(0.01 * distance))
            let removePipes = SKAction.removeFromParent()
            dude.physicsBody?.velocity = CGVectorMake(0,0)
            dude.physicsBody?.applyImpulse(CGVectorMake(0, 110))
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
        }else{
            dude.physicsBody?.velocity = CGVectorMake(0,0)
            dude.physicsBody?.applyImpulse(CGVectorMake(0, 110))

        }
        
        
    }
    //All Pipe Functions
    
    func createPipe(){
        
        //Score Nodes
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.height)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = physicsIsHard.scoreDuh
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = physicsIsHard.dude

        pipePair = SKNode()
        let topPipe = SKSpriteNode(imageNamed: "pipe")
        let bottomPipe = SKSpriteNode(imageNamed: "pipeup.png")
        topPipe.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 350)
        bottomPipe.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 - 350)
        topPipe.setScale(0.5)
        topPipe.physicsBody = SKPhysicsBody(rectangleOfSize: topPipe.size)
        topPipe.physicsBody?.categoryBitMask = physicsIsHard.pipe
        topPipe.physicsBody?.collisionBitMask = physicsIsHard.dude
        topPipe.physicsBody?.dynamic = false
        topPipe.physicsBody?.affectedByGravity = false
        bottomPipe.setScale(0.5)
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOfSize: topPipe.size)
        bottomPipe.physicsBody?.categoryBitMask = physicsIsHard.pipe
        bottomPipe.physicsBody?.collisionBitMask = physicsIsHard.dude
        bottomPipe.physicsBody?.dynamic = false
        bottomPipe.physicsBody?.affectedByGravity = false
        pipePair.zPosition = 1
        pipePair.addChild(topPipe)
        pipePair.addChild(bottomPipe)
        pipePair.runAction(moveAndRemove)
        pipePair.addChild(scoreNode)
        self.addChild(pipePair)
        let randomPos = CGFloat.random(min: -200, max: 200)
        pipePair.position.y = pipePair.position.y + randomPos
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
