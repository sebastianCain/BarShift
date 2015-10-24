//
//  GameScene.swift
//  BarShift
//
//  Created by Sebastian Cain on 10/24/15.
//  Copyright (c) 2015 Isometric LLC. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.scene?.view?.backgroundColor = SKColor.darkGrayColor()
        
        let myLabel = SKLabelNode(fontNamed:"Avenir-Book")
        myLabel.text = "start";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel.name = "start"
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }*/
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        let bss = BarShiftScene()
        bss.scaleMode = .ResizeFill
        if touchedNode.name == "start" {
            self.scene?.view?.presentScene(bss, transition: SKTransition.doorsOpenHorizontalWithDuration(0.2))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
