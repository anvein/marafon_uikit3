
import UIKit
import Foundation

class ViewController: UIViewController {
    let heightBox = 80
    let margin = 16
        
    lazy var boxView: UIView = {
        let gradientView = UIView()
        gradientView.backgroundColor = .blue
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView.layer.cornerRadius = 16
   
        return gradientView
    }()
    
    lazy var slider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumValue = 0
        view.maximumValue = 100
        view.isContinuous = true
        view.tintColor = UIColor.green
        view.minimumTrackTintColor = .red
        view.setValue(0, animated: true)
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        view.addTarget(self, action: #selector(sliderValueEndChange), for: .touchUpInside)
        view.addTarget(self, action: #selector(sliderValueEndChange), for: .touchUpOutside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Создание и настройка интерфейса
    
    func addSubview() {
        view.addSubview(boxView)
        view.addSubview(slider)
    }
    
    func setupViews() {
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
        boxView.heightAnchor.constraint(equalToConstant: CGFloat(heightBox)).isActive = true
        boxView.widthAnchor.constraint(equalTo: boxView.heightAnchor).isActive = true
        
        boxView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(margin)).isActive = true
        boxView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(margin)).isActive = true
        
        slider.topAnchor.constraint(equalTo: boxView.bottomAnchor, constant: 30).isActive = true
        slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(margin)).isActive = true
        slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -CGFloat(margin)).isActive = true
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        transformBox(to: sender.value)
    }
    
    @objc func sliderValueEndChange(_ sender: UISlider) {
        UIView.animate(withDuration: 0.4) {
            self.slider.setValue(100, animated: true)
            self.transformBox(to: 100)
        }
    }
    
    func transformBox(to: Float) {
        let toValue = CGFloat(to)
        let heightBox = CGFloat(self.heightBox)
        
        let maxAngle = CGFloat.pi / 2 // 90 градусов
        
        let scalePerTick = (0.5)/100
        let anglePerTick = maxAngle/100
        let pointPerTick = (UIScreen.main.bounds.width - heightBox * 1.5 - CGFloat(margin)) / 100
        
        let scaleFactor = (scalePerTick * toValue)
        
        var transform: CGAffineTransform = boxView.transform

        let scaleTransform = CGAffineTransformIdentity.scaledBy(x: 1 + scaleFactor, y: 1 + scaleFactor)
        let rotateTransform = CGAffineTransformIdentity.rotated(by: anglePerTick * toValue)
        
        
        self.boxView.center.x = pointPerTick * toValue + (CGFloat(self.heightBox) / CGFloat(2)) + CGFloat(margin)
//        let translateTransform = CGAffineTransformIdentity.translatedBy(x: pointPerTick * toValue, y: 0)
        
        transform = scaleTransform.concatenating(rotateTransform)//.concatenating(translateTransform)
        
        boxView.transform = transform
    }
    
}
