//
// Created by Sergei Dorozhkin on 30.12.2020.
//

import UIKit

class AnimView: UIView {
    func sizeSetUP(side: CGFloat) {
        clipsToBounds = false
        widthAnchor.constraint(equalToConstant: side).isActive = true
        let heightConstraint = heightAnchor.constraint(equalToConstant: side)
        heightConstraint.priority = UILayoutPriority(rawValue: 750)
        heightConstraint.isActive = true
        backgroundColor = .twitterBlue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 4
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 3, height: 2)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.8
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        layer.add(animation, forKey: nil)
    }
}
class AnimViewImage: UIImageView {
    func sizeSetUP(side: CGFloat) {
        widthAnchor.constraint(equalToConstant: side).isActive = true
        let heightConstraint = heightAnchor.constraint(equalToConstant: side)
        heightConstraint.priority = UILayoutPriority(rawValue: 750)
        heightConstraint.isActive = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
        backgroundColor = .white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
