//
//  ViewModelProtocol.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 16.02.2023.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    func showLoading()
    func hideLoading()
//    func updateView()
    func reload()
}

extension ViewModelProtocol {
    func showLoading() { }
    func hideLoading() { }
    func updateView() { }
    func reload() { }
}
