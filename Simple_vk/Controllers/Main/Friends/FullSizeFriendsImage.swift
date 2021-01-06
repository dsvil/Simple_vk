//
// Created by Sergei Dorozhkin on 03.01.2021.
//

import UIKit
import SDWebImage

class FullScreenImageController: UIViewController {
    //MARK: Properties
    private var fullScreen = UIImageView()
    var startFromImage = Int()
    var friendImages = [PhotoStaff]()
    private var gestureAnimator = UIViewPropertyAnimator()

//MARK: Lifestyle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        applyCount(4)
    }

    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .black
        view.addSubview(fullScreen)
        fullScreen.center(inView: view)
        fullScreen.isUserInteractionEnabled = true
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(gestureAction(recognizer:)))
        fullScreen.addGestureRecognizer(gesture)
    }
    func applyCount (_ size: Int) {
        let url = URL(string: self.friendImages[self.startFromImage].sizes[size].url)
        self.fullScreen.sd_setImage(with: url)
    }


//MARK: Selectors
    @IBAction func gestureAction(recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: view)
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let rotate = CGAffineTransform(rotationAngle: 0.5)
        let transformation = scale.concatenating(rotate)

        switch recognizer.state {
        case .began:
            gestureAnimator.startAnimation()
            gestureAnimator = UIViewPropertyAnimator(duration: 1.5,
                    dampingRatio: 0.8) {
                self.fullScreen.transform = transformation
                self.fullScreen.alpha = 0
            }
        case .changed:
            recognizer.view!.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            gestureAnimator.fractionComplete = abs(translation.x) / 100
            if translation.y > 100 {
                dismiss(animated: true, completion: nil)
            }
        case .ended:
            gestureAnimator.stopAnimation(true)
            gestureAnimator.addAnimations({
                if translation.x > 120 {
                    if self.startFromImage > 0 {
                        self.startFromImage -= 1
                    } else {
                        self.startFromImage = 0
                    }
                } else {
                    if self.startFromImage < self.friendImages.count - 1 {
                        self.startFromImage += 1
                    } else {
                        self.startFromImage = self.friendImages.count - 1
                    }
                }

                let count = self.friendImages[self.startFromImage].sizes.count
                switch count {
                case _ where count >= 5:
                    self.applyCount(4)
                case 4:
                    self.applyCount(3)
                case 3:
                    self.applyCount(2)
                default:
                    self.applyCount(0)
                }

                self.fullScreen.alpha = 1
                self.fullScreen.transform = .identity
                self.fullScreen.center(inView: self.view)
            })
            gestureAnimator.startAnimation()
        default: break
        }

    }
}
