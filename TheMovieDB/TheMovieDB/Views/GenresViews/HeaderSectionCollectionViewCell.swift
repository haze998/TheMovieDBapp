//
//  HeaderSectionCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 08.02.2023.
//

import UIKit

final class HeaderSectionCollectionViewCell: UICollectionViewCell {
    // MARK: - Init UI
    static let reuseId = "headerIdentifier"
    private let contrainer = UIView()
    private let leftElemnt = UIView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented - not using storyboards")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    // MARK: - Configure UI
    private func configureView() {
        contrainer.backgroundColor = .clear
        contrainer.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.minimumContentSizeCategory = .accessibilityMedium
        label.font = UIFont(name: "CodecPro-Bold", size: 30.0)
        label.textColor = .white
        
        let gradientView = CAGradientLayer()
        gradientView.colors = [
            UIColor(red: 0.247, green: 0.216, blue: 0.498, alpha: 1).cgColor,
            UIColor(red: 0.263, green: 0.659, blue: 0.831, alpha: 1).cgColor
          ]
        gradientView.locations = [0, 1]
        gradientView.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientView.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientView.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1.14, b: 1.43, c: -1.43, d: -87.17, tx: 1.85, ty: 43.16))
        gradientView.bounds = leftElemnt.bounds.insetBy(dx: -0.5 * leftElemnt.bounds.size.width, dy: -0.5 * leftElemnt.bounds.size.height)
        gradientView.position = leftElemnt.center
        leftElemnt.layer.insertSublayer(gradientView, at: 0)
        leftElemnt.backgroundColor = UIColor(red: 0.26, green: 0.66, blue: 0.83, alpha: 1.00)
        leftElemnt.translatesAutoresizingMaskIntoConstraints = false
        leftElemnt.layer.cornerRadius = 4
    }
    // MARK: - Constraints
    private func setupConstraint() {
        contentView.addSubview(contrainer)
        contrainer.addSubview(leftElemnt)
        contrainer.addSubview(label)
        NSLayoutConstraint.activate([
            contrainer.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            contrainer.heightAnchor.constraint(equalToConstant: contentView.bounds.height),
            contrainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contrainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            leftElemnt.topAnchor.constraint(equalTo: contrainer.topAnchor, constant: 0),
            leftElemnt.leadingAnchor.constraint(equalTo: contrainer.leadingAnchor, constant: 8),
            leftElemnt.bottomAnchor.constraint(equalTo: contrainer.bottomAnchor, constant: -4),
            leftElemnt.widthAnchor.constraint(equalToConstant: 8)
        ])
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leftElemnt.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: leftElemnt.centerYAnchor)
        ])
    }
}

