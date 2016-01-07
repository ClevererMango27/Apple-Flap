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
}

class GameScene: SKScene {
    
    var pipe = SKSpriteNode()
    var dude = SKSpriteNode()
    var pipePair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarts = Bool()
    var pipeTouched = Bool()
    
    override func didMoveToView(view: SKView) {
        
        //Dude
        dude = SKSpriteNode(imageNamed: "alogo")
        dude.size = CGSize(width:60, height: 70)
        dude.position = CGPoint(x: self.frame.width / 2 - dude.frame.width, y: self.frame.height / 2)
        dude.physicsBody = SKPhysicsBody(circleOfRadius: dude.frame.height / 2)
        dude.physicsBody?.categoryBitMask = physicsIsHard.dude
        dude.physicsBody?.collisionBitMask = physicsIsHard.pipe
        dude.physicsBody?.contactTestBitMask = physicsIsHard.dude | physicsIsHard.pipe
        dude.physicsBody?.affectedByGravity = false
        dude.physicsBody?.dynamic = true
        dude.zPosition = 2
        self.addChild(dude)
        
        
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
            let space = SKAction.waitForDuration(2)
            let spawnSpace = SKAction.sequence([spawn, space])
            let spawnSpaceInfiniteTimeLikeForever = SKAction.repeatActionForever(spawnSpace)
            self.runAction(spawnSpaceInfiniteTimeLikeForever)
            let distance = CGFloat(self.frame.width + pipePair.frame.width)
            let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.01 * distance))
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
        self.addChild(pipePair)
        let randomPos = CGFloat.random(min: -200, max: 200)
        pipePair.position.y = pipePair.position.y + randomPos
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
