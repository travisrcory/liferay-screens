/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit
import LiferayScreens


class SignInViewController: CardViewController,
		LoginScreenletDelegate,
		ForgotPasswordScreenletDelegate,
		KeyboardListener {

	@IBOutlet weak var scroll: UIScrollView!
	@IBOutlet weak var forgotTitle: UIButton!
	@IBOutlet weak var backArrow: UIImageView!

	@IBOutlet weak var signInPage: UIView!
	@IBOutlet weak var forgotPage: UIView!

	@IBOutlet weak var loginScreenlet: LoginScreenlet!
	@IBOutlet weak var forgotPasswordScreenlet: ForgotPasswordScreenlet!


	override init(card: CardView, nibName: String) {
		let save = card.minimizedHeight
		card.minimizedHeight = 0
		super.init(card: card, nibName: nibName)
		card.minimizedHeight = save
	}

	convenience init(card: CardView) {
		self.init(card: card, nibName:"SignInViewController")
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		scroll.contentSize = CGSizeMake(scroll.frame.size.width * 2, scroll.frame.size.height)

		signInPage.frame = scroll.frame
		forgotPage.frame = CGRectMake(scroll.frame.size.width, scroll.frame.origin.y, scroll.frame.size)

		self.loginScreenlet.delegate = self
		self.forgotPasswordScreenlet.delegate = self

		self.forgotPasswordScreenlet.anonymousApiUserName =
				LiferayServerContext.valueForKey("anonymousUsername") as? String
		self.forgotPasswordScreenlet.anonymousApiPassword =
				LiferayServerContext.valueForKey("anonymousPassword") as? String
	}

	override func viewWillAppear(animated: Bool) {
		if cardView!.button!.superview !== scroll {
			cardView!.button!.removeFromSuperview()
			scroll.addSubview(cardView!.button!)
		}
	}

	@IBAction func backAction(sender: AnyObject) {
		UIView.animateWithDuration(0.3,
				animations: {
					self.forgotTitle.alpha = 0.0
					self.backArrow.alpha = 0.0
					self.cardView?.arrow?.alpha = 1.0
				},
				completion: nil)

		let newRect = CGRectMake(0, 0, scroll.frame.size)
		scroll.scrollRectToVisible(newRect, animated: true)
	}

	@IBAction func forgotPasswordAction(sender: AnyObject) {
		self.forgotTitle.alpha = 0.0
		self.backArrow.alpha = 0.0

		UIView.animateWithDuration(0.5,
				animations: {
					self.forgotTitle.alpha = 1.0
					self.backArrow.alpha = 1.0
					self.cardView?.arrow?.alpha = 0.0
				},
				completion: nil)

		let newRect = CGRectMake(scroll.frame.size.width, 0, scroll.frame.size)
		scroll.scrollRectToVisible(newRect, animated: true)
	}

	func screenlet(screenlet: BaseScreenlet,
			onLoginResponseUserAttributes attributes: [String:AnyObject]) {
		onDone?()
	}

	func screenlet(screenlet: ForgotPasswordScreenlet,
			onForgotPasswordSent passwordSent: Bool) {
		backAction(self)
	}

	override func cardWillAppear() {
		registerKeyboardListener(self)
	}

	override func cardWillDisappear() {
		unregisterKeyboardListener(self)
	}

	func showKeyboard(notif: NSNotification) {
		if cardView?.currentState == .Normal {
			cardView?.nextState = .Maximized
			cardView?.changeToNextState()
		}
	}

	func hideKeyboard(notif: NSNotification) {
		if cardView?.currentState == .Maximized {
			cardView?.nextState = .Normal
			cardView?.changeToNextState()
		}
	}

}
