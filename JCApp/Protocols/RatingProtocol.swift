//
//  RatinProtocol.swift
//  JCApp
//
//  Created by Jose Lino Neto on 29/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import Foundation
protocol RatingProtocol {
    func rateEvent(numberStars: Int, comment: String?, author: String?)
}
