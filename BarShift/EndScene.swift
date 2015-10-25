//
//  EndScene.swift
//  BarShift
//
//  Created by Sebastian Cain on 10/24/15.
//  Copyright © 2015 Isometric LLC. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        let emerald = SKColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
        self.backgroundColor = emerald
        
        let myLabel = SKLabelNode(fontNamed:"Avenir-Book")
        myLabel.text = "you lost. gg";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+100);
        myLabel.name = "yl"
        myLabel.color = SKColor.whiteColor()
        self.addChild(myLabel)
        
        let myLabel2 = SKLabelNode(fontNamed:"Avenir-Book")
        myLabel2.text = "retry";
        myLabel2.fontSize = 45;
        myLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        myLabel2.name = "retry"
        myLabel.color = SKColor.whiteColor()
        self.addChild(myLabel2)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        let bss = BarShiftScene()
        bss.scaleMode = .ResizeFill
        if touchedNode.name == "retry" {
            self.scene?.view?.presentScene(bss, transition: SKTransition.doorsOpenHorizontalWithDuration(0.2))
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
