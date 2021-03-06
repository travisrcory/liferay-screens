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
import Foundation

extension SyncManager {

	func userPortraitSynchronizer(
			key: String,
			attributes: [String:AnyObject])
			-> Signal -> () {

		return { signal in
			let userId = attributes["userId"] as! NSNumber

			self.cacheManager.getImage(
					collection: ScreenletName(UserPortraitScreenlet),
					key: key) {

				if let image = $0 {
					let interactor = UploadUserPortraitInteractor(
						screenlet: nil,
						userId: userId.longLongValue,
						image: image)

					// this strategy saves the send date after the operation
					interactor.cacheStrategy = .CacheFirst

					interactor.onSuccess = {
						self.delegate?.syncManager?(self,
							onItemSyncScreenlet: ScreenletName(UserPortraitScreenlet),
							completedKey: key,
							attributes: attributes)

						signal()
					}

					interactor.onFailure = { err in
						self.delegate?.syncManager?(self,
							onItemSyncScreenlet: ScreenletName(UserPortraitScreenlet),
							failedKey: key,
							attributes: attributes,
							error: err)

						// TODO retry?
						signal()
					}

					if !interactor.start() {
						signal()
					}
				}
				else {
					self.delegate?.syncManager?(self,
						onItemSyncScreenlet: ScreenletName(UserPortraitScreenlet),
						failedKey: key,
						attributes: attributes,
						error: NSError.errorWithCause(.NotAvailable))

					signal()
				}
			}
		}
	}

}
