//
//  BarShiftScene.swift
//  BarShift
//
//  Created by Sebastian Cain on 10/24/15.
//  Copyright © 2015 Isometric LLC. All rights reserved.
//

import SpriteKit

class BarShiftScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundNode = SKNode()
    
    let emerald = SKColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
    
    let barCategory : UInt32 = 0x1 << 0
    let ballCategory : UInt32 = 0x1 << 1
    
    var ball : SKShapeNode!
    
    var bar1 = SKShapeNode()
    var bar11 = SKShapeNode()
    var bar12 = SKShapeNode()
    var bar2 = SKShapeNode()
    var bar21 = SKShapeNode()
    var bar22 = SKShapeNode()
    var bar3 = SKShapeNode()
    var bar31 = SKShapeNode()
    var bar32 = SKShapeNode()
    
    
    var currentBar = SKShapeNode()
    var bars = Array<SKShapeNode>!()
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        backgroundNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        backgroundNode.position = CGPointMake(0, 0)
        
        bar1 = createBar(0)
        bar2 = createBar(2)
        bar3 = createBar(4)
        backgroundNode.addChild(self.bar1)
        backgroundNode.addChild(self.bar2)
        backgroundNode.addChild(self.bar3)
        
        self.bars = [self.bar11, self.bar12, self.bar21, self.bar22, self.bar31, self.bar32]
        
        self.ball = createBall()
        backgroundNode.addChild(self.ball)
        
        currentBar = bar1
        
        self.addChild(backgroundNode)
        
        startGame()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
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
        
        ball.position = CGPointMake(CGRectGetMidX(self.frame), 160)
        
        return ball
    }
    
    func createBar(index : Int) -> SKShapeNode {
        let bar = SKShapeNode(rectOfSize: CGSizeMake(50, 1))
        
        bars[index] = SKShapeNode(rectOfSize: CGSizeMake(25, 1))
        bars[index+1] = SKShapeNode(rectOfSize: CGSizeMake(25, 1))
        
        if index == 0 {
            bar.position = CGPointMake(CGRectGetMidX(self.frame), 150)
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(25, 5), center: CGPointMake(CGRectGetMidX(bar1.frame), CGRectGetMidY(bar1.frame)-10))
        } else if index == 1 {
            bar.position = CGPointMake(187.5-100, 350)
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(25, 5), center: CGPointMake(CGRectGetMidX(bar2.frame), CGRectGetMidY(bar2.frame)))
        } else if index == 2 {
            bar.position = CGPointMake(187.5+100, 550)
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(25, 5), center: CGPointMake(CGRectGetMidX(bar3.frame), CGRectGetMidY(bar3.frame)))
        }
        
        bars[index].physicsBody?.dynamic = false
        bars[index].physicsBody?.affectedByGravity = false
        bars[index].physicsBody?.allowsRotation = false
        bars[index].physicsBody?.categoryBitMask = barCategory
        bars[index].physicsBody?.collisionBitMask = ballCategory
        bars[index].physicsBody?.contactTestBitMask = ballCategory
        bars[index].position = CGPointMake(-12.5, 0)
        bars[index].name = "bar\(index)"
        
        bars[index+1].physicsBody?.dynamic = false
        bars[index+1].physicsBody?.affectedByGravity = false
        bars[index+1].physicsBody?.allowsRotation = false
        bars[index+1].physicsBody?.categoryBitMask = barCategory
        bars[index+1].physicsBody?.collisionBitMask = ballCategory
        bars[index+1].physicsBody?.contactTestBitMask = ballCategory
        bars[index].position = CGPointMake(12.5, 0)
        bars[index+1].name = "bar\(index+1)"
        
        bar.addChild(bars[index])
        bar.addChild(bars[index+1])
        return bar
    }
    
    func startGame() {
        ball.physicsBody?.velocity = CGVectorMake(0, 1000)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let loc = touch!.locationInNode(self)
        if loc.x <= CGRectGetMidX(self.frame) /*&& currentBar.position.x >= CGRectGetMidX(self.frame)*/ {
            currentBar.runAction(SKAction.moveByX(-100, y: 0, duration: 0.2))
        } else if loc.x > CGRectGetMidX(self.frame) /*&& currentBar.position.x < CGRectGetMidX(self.frame)*/ {
            currentBar.runAction(SKAction.moveByX(100, y: 0, duration: 0.2))
        } else {
            //self.paused = true
            //self.scene?.view?.presentScene(GameScene(), transition: SKTransition.doorsCloseHorizontalWithDuration(0.2))
            print("GAME OVER")
        }
    }
    
    func onebounce(bar : SKPhysicsBody) {
        
        if ball.physicsBody?.velocity.dy <= 150 &&  ball.physicsBody?.velocity.dy > 0 || ball.physicsBody?.velocity.dy > 800 {
            ball.physicsBody?.velocity = CGVectorMake(0, 900)
            score += 1
        } else {
            return
        }
        
        bar.node?.alpha = 0.0
        
        let r = arc4random_uniform(2)
        if r == 0 {
            bar.node?.runAction(SKAction.runBlock({bar.node?.position.x -= 100}))
        } else {
            bar.node?.runAction(SKAction.runBlock({bar.node?.position.x += 100}))
        }
        
        //bar.node?.runAction(SKAction.moveBy(CGVectorMake(0, -200), duration: 0.2))
        bar.node?.runAction(SKAction.runBlock({bar.node?.position.y += 600}))
        
        if bar.node?.name == "bar0" {
            currentBar = bar2
        } else if bar.node?.name == "bar1" {
            currentBar = bar3
        } else if bar.node?.name == "bar2" {
            currentBar = bar1
        }

        bar.node?.alpha = 1.0
    }
    
    override func update(currentTime: NSTimeInterval) {
        if ball.position.y >= -backgroundNode.position.y + self.frame.size.height/2 {
            backgroundNode.position.y -= ball.position.y - (-backgroundNode.position.y + self.frame.size.height/2)
        } else if ball.position.y < -backgroundNode.position.y {
            self.paused = true
            self.scene?.view?.presentScene(EndScene(), transition: SKTransition.fadeWithDuration(1))
            print("GAME OVER")
        }
    }
}
