//
//  DeflectorScene.swift
//  Deflector
//
//  Created by Sebastian Cain on 11/4/14.
//  Copyright (c) 2014 Sebastian Cain. All rights reserved.
//

import SpriteKit
import UIKit
import AVKit
import AVFoundation
import AudioToolbox

class DeflectorScene: SKScene, SKPhysicsContactDelegate {
	
    var sound = NSUserDefaults.standardUserDefaults().objectForKey("sound") as! NSString?
    
	var gameContainer = SKShapeNode()
	
	var pipe1 = SKSpriteNode()
	var pipe2 = SKSpriteNode()
	var pipe3 = SKSpriteNode()
	var pipe4 = SKSpriteNode()
	var pipe5 = SKSpriteNode()
	
	var barNode = SKSpriteNode()
	
	var ball1 = SKShapeNode()
	var ball2 = SKShapeNode()
	var ball1or2 = 0
	
	let betterBlue = SKColor(red: 25/255.0 , green: 181/255.0, blue: 254/255.0, alpha: 1.0)

	let clockrotate = SKAction.rotateByAngle(10*3.14159265, duration: 5.0)
	let counterrotate = SKAction.rotateByAngle( -(10*3.14159265), duration: 5.0)
	
	var drop = SKAction()
	
	var dropInterval : Double = 1.0
	
	let barCategory : UInt32 = 1 << 0
	let ballCategory : UInt32 = 1 << 1
	let receiverCategory : UInt32 = 1 << 2
	let backgroundBallCategory : UInt32 = 1 << 3
	
	var halfScreenWidth : CGFloat = 212
	
	var score = 0
	
	var random = UInt32()
	
	let sceneCameFrom = "Hold"
	
	var scoreLabel = SKLabelNode()
	
	lazy var pingSound = SKAction()
	
    override  func didMoveToView(view: SKView) {
        /* Setup your scene here */
		
		self.backgroundColor = SKColor.darkGrayColor()
		
		self.physicsWorld.contactDelegate = self
		
		gameContainer = SKShapeNode(rect: CGRectMake(0,0, self.frame.width, self.frame.height))
		gameContainer.name = "LOL"

		//MARK: BAR SETUP
		
		barNode = createBar(position: CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 150))
		barNode.name = "bar"
		gameContainer.addChild(barNode)
		
		//MARK: LABEL SETUP

		scoreLabel.text = "\(score)"
		scoreLabel.fontSize = 72
		scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+50)
		//scoreLabel.fontColor = SKColor.blackColor()
		gameContainer.addChild(scoreLabel)
		
		//MARK: RECEIVER SETUP
		
		if let view = self.view {
			if let window = view.window {
				if window.frame.height == 480 {
					halfScreenWidth = 250
				} else if window.frame.height == 1024 {
					halfScreenWidth = 283
				}
			}
		}
		
		
		let blueReceiverNode = createReciever(
			theposition: CGPointMake(CGRectGetMidX(self.frame)-halfScreenWidth, CGRectGetMidY(self.frame)),
			thesize:  CGSizeMake(10, self.frame.height),
			thecolor: betterBlue,
			thename: "blue")
		let yellowReceiverNode = createReciever(
			theposition: CGPointMake(CGRectGetMidX(self.frame)+halfScreenWidth, CGRectGetMidY(self.frame)),
			thesize:  CGSizeMake(10, self.frame.height),
			thecolor: SKColor.yellowColor(),
			thename: "yellow")
		let blueTopReceiverNode = createReciever(theposition: CGPointMake(CGRectGetMidX(self.frame)-halfScreenWidth/2, CGRectGetMaxY(self.frame)-5),
			thesize: CGSizeMake(halfScreenWidth , 10),
			thecolor: betterBlue,
			thename: "blue")
		let yellowTopReceiverNode = createReciever(theposition: CGPointMake(CGRectGetMidX(self.frame)+halfScreenWidth/2, CGRectGetMaxY(self.frame)-5),
			thesize: CGSizeMake(halfScreenWidth , 10),
			thecolor: SKColor.yellowColor(),
			thename: "yellow")
		let blueBottomReceiverNode = createReciever(theposition: CGPointMake(CGRectGetMidX(self.frame)-halfScreenWidth/2, CGRectGetMinY(self.frame)+5),
			thesize: CGSizeMake(halfScreenWidth , 10),
			thecolor: betterBlue,
			thename: "blue")
		let yellowBottomReceiverNode = createReciever(theposition: CGPointMake(CGRectGetMidX(self.frame)+halfScreenWidth/2, CGRectGetMinY(self.frame)+5),
			thesize: CGSizeMake(halfScreenWidth , 10),
			thecolor: SKColor.yellowColor(),
			thename: "yellow")
		gameContainer.addChild(blueReceiverNode)
		gameContainer.addChild(yellowReceiverNode)
		gameContainer.addChild(blueTopReceiverNode)
		gameContainer.addChild(yellowTopReceiverNode)
		gameContainer.addChild(blueBottomReceiverNode)
		gameContainer.addChild(yellowBottomReceiverNode)

		//MARK: PIPE SETUP
		
		pipe1 = createPipe(theposition: CGPointMake(CGRectGetMidX(self.frame)-125, CGRectGetMaxY(self.frame)-37.5))
		pipe2 = createPipe(theposition: CGPointMake(CGRectGetMidX(self.frame)-75, CGRectGetMaxY(self.frame)-37.5))
		pipe3 = createPipe(theposition: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-37.5))
		pipe4 = createPipe(theposition: CGPointMake(CGRectGetMidX(self.frame)+75, CGRectGetMaxY(self.frame)-37.5))
		pipe5 = createPipe(theposition: CGPointMake(CGRectGetMidX(self.frame)+125, CGRectGetMaxY(self.frame)-37.5))
		gameContainer.addChild(pipe1)
		gameContainer.addChild(pipe2)
		gameContainer.addChild(pipe3)
		gameContainer.addChild(pipe4)
		gameContainer.addChild(pipe5)
		pipe1.alpha = 0.0
		pipe2.alpha = 0.0
		pipe4.alpha = 0.0
		pipe5.alpha = 0.0
		
		self.ball1 = createBall(position: CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame) - 50))
		self.ball2 = createBall(position: CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame) - 50))
		self.addChild(self.ball1)
		self.addChild(self.ball2)
		
		self.addChild(gameContainer)
		
		//MARK: SOUND SETUP
		
		pingSound = SKAction.playSoundFileNamed("Ping.mp3", waitForCompletion: false)
		
		//MARK: GAME STARTS HERE
		
		superDrop()
		
	}
	
	//MARK: OBJECT CREATION
	
	func createPipe(theposition theposition: CGPoint) -> SKSpriteNode {
		let pipeNode = SKSpriteNode(imageNamed: "pipe")
		pipeNode.position = theposition
		pipeNode.size = CGSizeMake(90.0, 75.0)
		return pipeNode
	}
	
	func createBar(position position : CGPoint) -> SKSpriteNode {
        
		let bar : SKSpriteNode = SKSpriteNode(imageNamed: "bar")
		bar.position = position
		bar.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 5), center: CGPointMake(CGRectGetMidX(bar.frame), CGRectGetMidY(bar.frame)))
		bar.physicsBody?.dynamic = false
		bar.physicsBody?.affectedByGravity = false
		bar.physicsBody?.dynamic = false
		bar.physicsBody?.allowsRotation = false
		bar.physicsBody?.categoryBitMask = barCategory
		bar.physicsBody?.collisionBitMask = ballCategory
		bar.physicsBody?.contactTestBitMask = ballCategory
		return bar
	}
	
	func createBall(position position : CGPoint) -> SKShapeNode {
		let ball : SKShapeNode = SKShapeNode(circleOfRadius: 20.0)
		let random = arc4random_uniform(UInt32(2))
		if random == 0 {
			ball.strokeColor = SKColor.clearColor()
			ball.fillColor = SKColor.yellowColor()
			ball.name = "yellow"
		} else if random == 1 {
			ball.strokeColor = SKColor.clearColor()
			ball.fillColor = self.betterBlue
			ball.name = "blue"
		}
		
		ball.physicsBody = SKPhysicsBody(circleOfRadius: 20.0, center: CGPoint(x: CGRectGetMidX(ball.frame), y: CGRectGetMidY(ball.frame)))
		ball.physicsBody?.dynamic = true
		ball.physicsBody?.affectedByGravity = true
		ball.physicsBody?.categoryBitMask = ballCategory
		ball.physicsBody?.collisionBitMask = barCategory | ballCategory
		ball.physicsBody?.contactTestBitMask = barCategory | receiverCategory
		ball.physicsBody?.restitution = 3.0
		
		ball.position = position
		return ball
	}
	
	func createReciever(theposition theposition : CGPoint, thesize : CGSize, thecolor : SKColor, thename : NSString) -> SKSpriteNode {
        //set and configure receivers
        
		var receiverNode = SKSpriteNode()
		receiverNode = SKSpriteNode(color: thecolor, size: thesize)
		receiverNode.position = theposition
		receiverNode.physicsBody = SKPhysicsBody(rectangleOfSize: thesize)
		receiverNode.physicsBody?.affectedByGravity = false
		receiverNode.physicsBody?.dynamic = false
		receiverNode.physicsBody?.categoryBitMask = receiverCategory
		receiverNode.physicsBody?.contactTestBitMask = ballCategory
		receiverNode.name = thename as String
		return receiverNode
	}
	
	//MARK: CONTACT FUNCTION
	
	func didBeginContact(contact: SKPhysicsContact) {
		
		if contact.bodyA.node?.name == "bar" || contact.bodyB.node?.name == "bar" {
            //ball hits bar
			if sound == "true" {
				self.runAction(pingSound)
			}
		} else if contact.bodyA.node?.name == "back" || contact.bodyB.node?.name == "back" {
			//ball hits bar
			print("lol")
		}else if contact.bodyA.node?.name == contact.bodyB.node?.name {
            //ball hits correct side of screen
			self.score += 1
			self.scoreLabel.text = "\(score)"
		}else{
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));
			//transition to next skscene
//			let transition = SKTransition.doorsCloseHorizontalWithDuration(0.3)
//			let scene = EndScene()
//            scene.score = self.score
//			scene.size = self.size
//			scene.scaleMode = SKSceneScaleMode.AspectFill
//			self.scene?.view?.presentScene(scene, transition: transition)
			
		}
		
	}
	
	//MARK: TOUCH FUNCTION
	
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self)
			if location.x <= CGRectGetMidX(self.frame){
				barNode.runAction(clockrotate)
			} else {
				barNode.runAction(counterrotate)
			}
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //suspend bar rotation
		barNode.removeAllActions()
	}
	
	//MARK: BALL DROP WITH ONE PIPE
	
    func ballDrop(dropSpeed dropSpeed : CGFloat, dropInt : Double, dropCount : Int) ->SKAction {
		let waitForDrop = SKAction.waitForDuration(dropInt)
		self.drop = SKAction.runBlock({
			if self.ball1or2 == 0 {
				self.ball1.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame) - 50)
				self.random = arc4random_uniform(UInt32(2))
				if self.random == 0 {
					self.ball1.fillColor = self.betterBlue
					self.ball1.name = "blue"
				} else {
					self.ball1.fillColor = SKColor.yellowColor()
					self.ball1.name = "yellow"
				}
				self.ball1.physicsBody?.velocity = CGVectorMake(0, -dropSpeed)
				self.ball1or2 = 1
			} else if self.ball1or2 == 1 {
				self.ball2.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame) - 50)
				self.random = arc4random_uniform(UInt32(2))
				if self.random == 0 {
					self.ball2.fillColor = self.betterBlue
					self.ball2.name = "blue"
				} else {
					self.ball2.fillColor = SKColor.yellowColor()
					self.ball2.name = "yellow"
				}
				self.ball2.physicsBody?.velocity = CGVectorMake(0, -dropSpeed)
				self.ball1or2 = 0
			}
			
		})
		return SKAction.repeatAction(SKAction.sequence([waitForDrop, drop]), count : dropCount)
	}
	
	//MARK: FADES OUT CENTER PIPE, FADES IN TWO
	
	func startStage2() -> SKAction {
		let waitToStartFade = SKAction.waitForDuration(2.0)
		let fadeOutCenterPipe = SKAction.runBlock({
			self.pipe3.runAction(SKAction.fadeAlphaTo(0.0, duration: 1.0))
		})
		let inBetweenFades = SKAction.waitForDuration(1.0)
		let fadeInTwoPipes = SKAction.runBlock({
			self.pipe2.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
			self.pipe4.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
		})
		let waitForStage2 = SKAction.waitForDuration(1.0)
		return SKAction.sequence([waitToStartFade, fadeOutCenterPipe, inBetweenFades, fadeInTwoPipes, waitForStage2])
	}
	
	//MARK: BALL DROP WITH TWO PIPES
	
	func ballDrop50(dropSpeed dropSpeed : CGFloat, dropAngle : CGFloat, dropInt : Double, dropCount : Int) ->SKAction {
		//used for creating skactions that spawn balls
		let waitForDrop = SKAction.waitForDuration(dropInt)
		self.drop = SKAction.runBlock({
			if self.ball1or2 == 0 {
				
				//SET RANDOM COLOR
				self.random = arc4random_uniform(UInt32(2))
				if self.random == 0 {
					self.ball1.fillColor = self.betterBlue
					self.ball1.name = "blue"
				} else {
					self.ball1.fillColor = SKColor.yellowColor()
					self.ball1.name = "yellow"
				}
				
				//SET RANDOM POSITION
				self.random = arc4random_uniform(UInt32(2))
				if self.random == 0 {
					self.ball1.position = CGPoint(x: CGRectGetMidX(self.frame) - 75, y:CGRectGetMaxY(self.frame) - 50)
					self.ball1.physicsBody?.velocity = CGVectorMake(dropAngle, -dropSpeed)
				} else {
					self.ball1.position = CGPoint(x: CGRectGetMidX(self.frame) + 75, y:CGRectGetMaxY(self.frame) - 50)
					self.ball1.physicsBody?.velocity = CGVectorMake(-dropAngle, -dropSpeed)
				}
				
				//SWITCH BALL
				self.ball1or2 = 1
				
			} else if self.ball1or2 == 1 {
				
				//SET RANDOM COLOR
				self.random = arc4random_uniform(UInt32(2))
				if self.random == 0 {
					self.ball2.fillColor = self.betterBlue
					self.ball2.name = "blue"
				} else {
					self.ball2.fillColor = SKColor.yellowColor()
					self.ball2.name = "yellow"
				}
				
				//SET RANDOM POSITION
				self.random = arc4random_uniform(UInt32(2))
				if self.random == 0 {
					self.ball2.position = CGPoint(x: CGRectGetMidX(self.frame) - 75, y:CGRectGetMaxY(self.frame) - 50)
					self.ball2.physicsBody?.velocity = CGVectorMake(dropAngle, -dropSpeed)
				} else {
					self.ball2.position = CGPoint(x: CGRectGetMidX(self.frame) + 75, y:CGRectGetMaxY(self.frame) - 50)
					self.ball2.physicsBody?.velocity = CGVectorMake(-dropAngle, -dropSpeed)
				}
				
				//SET VELOCITY
				
				//SWITCH BALL
				self.ball1or2 = 0
			}

		})
		return SKAction.repeatAction(SKAction.sequence([waitForDrop, drop]), count : dropCount)
	}
	
	//MARK: FADES OUT TWO PIPES, FADES IN THREE
	
	func startStage3() -> SKAction {
		let waitToStartFade = SKAction.waitForDuration(2.0)
		let fadeOutTwoPipes = SKAction.runBlock({
			self.pipe2.runAction(SKAction.fadeAlphaTo(0.0, duration: 1.0))
			self.pipe4.runAction(SKAction.fadeAlphaTo(0.0, duration: 1.0))
		})
		let inBetweenFades = SKAction.waitForDuration(1.0)
		let fadeInThreePipes = SKAction.runBlock({
			self.pipe1.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
			self.pipe3.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
			self.pipe5.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.0))
		})
		let waitForStage2 = SKAction.waitForDuration(1.0)
		return SKAction.sequence([waitToStartFade, fadeOutTwoPipes, inBetweenFades, fadeInThreePipes, waitForStage2])
	}
	
	//MARK: BALL DROP WITH THREE PIPES
	
	func ballDrop100(dropSpeed dropSpeed : CGFloat, dropAngle : CGFloat, dropInt : Double, dropCount : Int) ->SKAction {
		
		let waitForDrop = SKAction.waitForDuration(dropInt)
		self.drop = SKAction.runBlock({
			if self.ball1or2 == 0 {
				
				//SET RANDOM COLOR
				self.random = arc4random_uniform(UInt32(2))
				if self.random == 0 {
					self.ball1.fillColor = self.betterBlue
					self.ball1.name = "blue"
				} else {
					self.ball1.fillColor = SKColor.yellowColor()
					self.ball1.name = "yellow"
				}
				
				//SET RANDOM POSITION
				self.random = arc4random_uniform(UInt32(3))
				if self.random == 0 {
					self.ball1.position = CGPoint(x: CGRectGetMidX(self.frame) - 125, y:CGRectGetMaxY(self.frame) - 50)
					self.ball1.physicsBody?.velocity = CGVectorMake(dropAngle, -dropSpeed)
				} else if self.random == 1 {
					self.ball1.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame)-50)
					self.ball1.physicsBody?.velocity = CGVectorMake(0, -dropSpeed)
				} else {
					self.ball1.position = CGPoint(x: CGRectGetMidX(self.frame) + 125, y:CGRectGetMaxY(self.frame) - 50)
					self.ball1.physicsBody?.velocity = CGVectorMake(-dropAngle, -dropSpeed)
				}
				
				
				//SWITCH BALL
				self.ball1or2 = 1
				
			} else if self.ball1or2 == 1 {
				
				//SET RANDOM POSITION
				self.random = arc4random_uniform(UInt32(3))
				if self.random == 0 {
					self.ball2.position = CGPoint(x: CGRectGetMidX(self.frame) - 125, y:CGRectGetMaxY(self.frame) - 50)
					self.ball2.physicsBody?.velocity = CGVectorMake(dropAngle, -dropSpeed)
				} else if self.random == 1 {
					self.ball2.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame)-50)
					self.ball2.physicsBody?.velocity = CGVectorMake(0, -dropSpeed)
				} else {
					self.ball2.position = CGPoint(x: CGRectGetMidX(self.frame) + 125, y:CGRectGetMaxY(self.frame) - 50)
					self.ball2.physicsBody?.velocity = CGVectorMake(-dropAngle, -dropSpeed)
				}
				
				//SET RANDOM COLOR
				self.random = arc4random_uniform(UInt32(2))
				if self.random == 0 {
					self.ball2.fillColor = self.betterBlue
					self.ball2.name = "blue"
				} else {
					self.ball2.fillColor = SKColor.yellowColor()
					self.ball2.name = "yellow"
				}
				
				//SWITCH BALL
				self.ball1or2 = 0
			}
			
		})
		return SKAction.repeatAction(SKAction.sequence([waitForDrop, drop]), count : dropCount)
		
	}
	
	//MARK: THE ACTUAL GAME
	
	func superDrop(){
		//called to actually run the game
		let drop1 : SKAction = ballDrop(dropSpeed : 600, dropInt: 1, dropCount: 10)
		let drop2 : SKAction = ballDrop(dropSpeed : 625, dropInt: 0.9, dropCount: 10)
		let drop3 : SKAction = ballDrop(dropSpeed : 650, dropInt: 0.8, dropCount: 10)
		let drop4 : SKAction = ballDrop(dropSpeed : 675, dropInt: 0.7, dropCount: 10)
		let drop5 : SKAction = ballDrop(dropSpeed : 700, dropInt: 0.7, dropCount: 10)
		let stage2 : SKAction = startStage2()
		let drop6 : SKAction = ballDrop50(dropSpeed: 700, dropAngle : 100, dropInt: 1, dropCount: 10)
		let drop7 : SKAction = ballDrop50(dropSpeed: 725, dropAngle : 110, dropInt: 0.9, dropCount: 10)
		let drop8 : SKAction = ballDrop50(dropSpeed: 750, dropAngle : 120, dropInt: 0.8, dropCount: 10)
		let drop9 : SKAction = ballDrop50(dropSpeed: 775, dropAngle : 130, dropInt: 0.7, dropCount: 10)
		let drop10 : SKAction = ballDrop50(dropSpeed: 800, dropAngle : 140, dropInt: 0.7, dropCount: 10)
		let stage3 : SKAction = startStage3()
		let drop11 : SKAction = ballDrop100(dropSpeed: 500, dropAngle : 125, dropInt: 1, dropCount: 10)
		let drop12 : SKAction = ballDrop100(dropSpeed: 550, dropAngle : 137.5, dropInt: 0.9, dropCount: 10)
		let drop13 : SKAction = ballDrop100(dropSpeed: 600, dropAngle : 150, dropInt: 0.8, dropCount: 10)
		let drop14 : SKAction = ballDrop100(dropSpeed: 650, dropAngle : 162.5, dropInt: 0.7, dropCount: 10)
		let drop15 : SKAction = ballDrop100(dropSpeed: 700, dropAngle : 175, dropInt: 0.7, dropCount: 10)
        let drop16 : SKAction = ballDrop100(dropSpeed: 800, dropAngle : 175, dropInt: 0.7, dropCount: 10)
        let drop17 : SKAction = ballDrop100(dropSpeed: 900, dropAngle : 175, dropInt: 0.65, dropCount: 10)
		
		//sets speedlimit, runs sequence
		
		self.runAction(SKAction.sequence([drop1, drop2, drop3, drop4, drop5, stage2, drop6, drop7, drop8, drop9, drop10, stage3, drop11, drop12, drop13, drop14, drop15, drop16, SKAction.repeatActionForever(drop17)]))
	}
	
	//MARK: UPDATE FUNCTION - RUNS 60 TIMES A SECOND - DELETES BALLS
	
}
