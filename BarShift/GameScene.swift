//
//  GameScene.swift
//  BarShift
//
//  Created by Sebastian Cain on 10/24/15.
//  Copyright (c) 2015 Isometric LLC. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let emerald = SKColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
        self.backgroundColor = emerald
        
        let titleLabel = SKLabelNode(fontNamed:"Avenir-Book")
        titleLabel.text = "bar//shift";
        titleLabel.fontSize = 72;
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+100);
        titleLabel.name = "start"
        self.addChild(titleLabel)
        
        let myLabel = SKLabelNode(fontNamed:"Avenir-Book")
        myLabel.text = "start";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-50);
        myLabel.name = "start"
        self.addChild(myLabel)
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
