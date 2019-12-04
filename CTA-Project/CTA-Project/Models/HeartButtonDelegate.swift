//
//  HeartButtonDelegate.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/3/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
protocol HeartButtonDelegate {
    func saveToPersistance(tag: Int)
    func deleteFromPersistance(tag: Int)
}
