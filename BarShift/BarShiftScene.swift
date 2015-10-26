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
    var bars : Array<SKShapeNode>!
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    var gameover = false
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        backgroundNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        backgroundNode.position = CGPointMake(0, 0)
        
        bar1 = createBar(0)
        bar2 = createBar(1)
        bar3 = createBar(2)
        backgroundNode.addChild(self.bar1)
        backgroundNode.addChild(self.bar2)
        backgroundNode.addChild(self.bar3)
        
        self.bars = [self.bar1, self.bar2, self.bar3]
        
        self.ball = createBall()
        backgroundNode.addChild(self.ball)
        
        currentBar = bar1
        
        self.addChild(backgroundNode)
        
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2+100)
        scoreLabel.fontName = "Avenir-Book"
        scoreLabel.fontSize = 200
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = UIColor(white: 1, alpha: 0.1)
        self.addChild(scoreLabel)
        
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
        
        let bar : SKShapeNode = SKShapeNode(rectOfSize: CGSizeMake(50, 1))
        bar.strokeColor = emerald
        if index == 0 {
            bar.position = CGPointMake(CGRectGetMidX(self.frame), 150)
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 5), center: CGPointMake(CGRectGetMidX(bar1.frame), CGRectGetMidY(bar1.frame)-10))
        } else if index == 1 {
            bar.position = CGPointMake(187.5-100, 350)
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 5), center: CGPointMake(CGRectGetMidX(bar2.frame), CGRectGetMidY(bar2.frame)))
        } else if index == 2 {
            bar.position = CGPointMake(187.5+100, 550)
            bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 5), center: CGPointMake(CGRectGetMidX(bar3.frame), CGRectGetMidY(bar3.frame)))
        }
        
        bar.physicsBody?.dynamic = false
        bar.physicsBody?.affectedByGravity = false
        bar.physicsBody?.allowsRotation = false
        bar.physicsBody?.categoryBitMask = barCategory
        bar.physicsBody?.collisionBitMask = ballCategory
        bar.physicsBody?.contactTestBitMask = ballCategory
        bar.name = "bar\(index)"
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
            print("GAME OVER", terminator: "")
        }
    }
    
    func onebounce(bar : SKPhysicsBody) {
        
        if ball.physicsBody?.velocity.dy <= 150 &&  ball.physicsBody?.velocity.dy > 0 || ball.physicsBody?.velocity.dy > 800 {
            ball.physicsBody?.velocity = CGVectorMake(0, 900)
            score += 1
            scoreLabel.text = "\(score)"
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
        bar.node?.runAction(SKAction.runBlock({bar.node?.position.y += 600 + CGFloat(score)*5}))
        
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
        } else if ball.position.y < -backgroundNode.position.y && gameover == false {
            self.paused = true
            self.removeAllChildren()
            self.scene?.view?.presentScene(EndScene(), transition: SKTransition.fadeWithDuration(0.5))
            print("GAME OVER", terminator: "")
            gameover = true
        }
    }
}
