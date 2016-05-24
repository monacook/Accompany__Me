//
//  cancelButtonDelegate.swift
//  fakeCall
//
//  Created by Amy Giver on 5/23/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//
import UIKit
protocol CancelButtonDelegate: class {
    func cancelButtonPressedFrom(controller: UIViewController)
}