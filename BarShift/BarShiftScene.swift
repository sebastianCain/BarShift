//
//  BarShiftScene.swift
//  BarShift
//
//  Created by Sebastian Cain on 10/24/15.
//  Copyright © 2015 Isometric LLC. All rights reserved.
//

import SpriteKit

class BarShiftScene: SKScene, SKPhysicsContactDelegate {
    
    var barNode = SKSpriteNode()
    let barCategory : UInt32 = 0x1 << 0
    let ballCategory : UInt32 = 0x1 << 1
    
    var ball : SKShapeNode!
    var bar1 = SKSpriteNode()
    var bar2 = SKSpriteNode()
    var bar3 = SKSpriteNode()
    var bars : Array<SKSpriteNode>!
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.bar1 = createBar(0)
        self.bar2 = createBar(1)
        self.bar3 = createBar(2)
        self.addChild(self.bar1)
        self.addChild(self.bar2)
        self.addChild(self.bar3)
        
        self.bars = [self.bar1, self.bar2, self.bar3]
        
        self.ball = createBall()
        self.addChild(self.ball)
        
        print(ball.physicsBody, bar1.physicsBody)
        
        startGame()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
            //ball hits bar
        
            onebounce(contact.bodyA)
    }
    
    func createBall() -> SKShapeNode {
        let ball : SKShapeNode = SKShapeNode(circleOfRadius: 10)
        ball.strokeColor = SKColor.whiteColor()
        ball.fillColor = SKColor.clearColor()
        ball.name = "ball"
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20.0, center: CGPoint(x: CGRectGetMidX(ball.frame), y: CGRectGetMidY(ball.frame)))
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.collisionBitMask = barCategory | ballCategory
        ball.physicsBody?.contactTestBitMask = barCategory
        ball.physicsBody?.linearDamping = 0;
        ball.physicsBody?.restitution = 1.0
        
        ball.position = CGPointMake(CGRectGetMidX(self.frame), 600)
        
        return ball
    }
    
    func createBar(index : Int) -> SKSpriteNode {
        
        let bar : SKSpriteNode = SKSpriteNode(imageNamed: "bar")
        bar.size = CGSizeMake(50, 5)
        if index == 0 {
            bar.position = CGPointMake(CGRectGetMidX(self.frame), 150)
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 5), center: CGPointMake(CGRectGetMidX(bar1.frame), CGRectGetMidY(bar1.frame)-10))
        } else if index == 1 {
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 5), center: CGPointMake(CGRectGetMidX(bar2.frame), CGRectGetMidY(bar2.frame)))
            bar.position = CGPointMake(CGFloat(arc4random_uniform(275)) + 50, 350)
        } else if index == 2 {
            bar.position = CGPointMake(CGFloat(arc4random_uniform(275)) + 50, 550)
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 5), center: CGPointMake(CGRectGetMidX(bar3.frame), CGRectGetMidY(bar3.frame)))
        }
        
        bar.physicsBody?.dynamic = false
        bar.physicsBody?.affectedByGravity = false
        bar.physicsBody?.dynamic = false
        bar.physicsBody?.allowsRotation = false
        bar.physicsBody?.categoryBitMask = barCategory
        bar.physicsBody?.collisionBitMask = ballCategory
        bar.physicsBody?.contactTestBitMask = ballCategory
        bar.name = "bar\(index)"
        return bar
    }
    
    func startGame() {
        //start game
    }
    
    func onebounce(bar : SKPhysicsBody) {
        print(bar.node?.name)
        
    }
}
