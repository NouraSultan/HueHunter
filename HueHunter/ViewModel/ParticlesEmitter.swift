//
//  ParticlesEmitter.swift
//  HueHunter
//
//  Created by Noura Sultan Ibn Qurmulah on 19/06/1444 AH.
//

import SwiftUI

import UIKit
/// Class that wraps the CAEmitterCell in a class compatible with SwiftUI
public struct ParticlesEmitter: UIViewRepresentable {
    var center: CGPoint = .init(x: 100, y: 800)
    var emitterSize: CGSize = .zero
    var shape: CAEmitterLayerEmitterShape = .line
    var cells: [CAEmitterCell] = []
    
    public func updateUIView(_ uiView: InternalParticlesView, context: UIViewRepresentableContext<ParticlesEmitter>) {
        uiView.emit(from: center,
                    size: emitterSize,
                    shape: shape,
                    cells: cells)
    }
    
    public func makeUIView(context: Context) -> InternalParticlesView {
        let view = InternalParticlesView()
        view.emit(from: center,
                  size: emitterSize,
                  shape: shape,
                  cells: cells)
        return view
    }
}

extension ParticlesEmitter {
    func emitterSize(_ size: CGSize) -> Self {
        return ParticlesEmitter(center: self.center, emitterSize: size, shape: shape, cells: self.cells)
    }
    
    func emitterPosition(_ position: CGPoint) -> Self {
        return ParticlesEmitter(center: position, emitterSize: self.emitterSize, shape: shape, cells: self.cells)
    }
    
    func emitterShape(_ shape: CAEmitterLayerEmitterShape) -> Self {
        return ParticlesEmitter(center: self.center, emitterSize: self.emitterSize, shape: shape, cells: self.cells)
    }
}


/// The container view class for the particles, as the project is using a CAEmitterLayer
public final class InternalParticlesView: UIView {
    private var particleEmitter: CAEmitterLayer?
    
    /// Function that adds the emitter cells to the layer
    /// - Parameter center: center of the emitter
    /// - Parameter size: size of the emitter
    /// - Parameter cells: all the CAEmitterCell
    func emit(from center: CGPoint, size: CGSize, shape: CAEmitterLayerEmitterShape, cells: [CAEmitterCell]) {
        if particleEmitter == nil {
            particleEmitter = CAEmitterLayer()
            layer.addSublayer(particleEmitter!)
        }
        
        particleEmitter?.emitterPosition = center
        particleEmitter?.emitterShape = shape
        particleEmitter?.emitterSize = size
        particleEmitter?.emitterCells = cells
    }
}

@resultBuilder
struct EmitterCellBuilder {
    static func buildBlock(_ cells: CAEmitterCell...) -> [CAEmitterCell] {
      Array(cells)
    }
}

extension ParticlesEmitter {
    init(@EmitterCellBuilder _ content: () -> [CAEmitterCell]) {
      self.init(cells: content())
    }
    
    init(@EmitterCellBuilder _ content: () -> CAEmitterCell) {
      self.init(cells: [content()])
    }
}

class EmitterCell: CAEmitterCell {
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func copyEmitter() -> EmitterCell {
        return super.copy() as! EmitterCell
    }
}


extension EmitterCell {
    /// Content for the emitter cell, it is either an image, or a circle.
    /// NB: It could easily be extended for other shapes.
    public enum Content {
        case image(UIImage)
        case circle(CGFloat)
    }
    
    @inlinable func content(_ content: Content) -> Self {
        self.contents = content.image.cgImage
        return self
    }
    
    @inlinable func birthRate(_ birthRate: Float) -> Self {
        self.birthRate = birthRate
        return self
    }
    
    @inlinable func lifetime(_ lifetime: Float) -> Self {
        self.lifetime = lifetime
        return self
    }
    
    @inlinable func scale(_ scale: CGFloat) -> Self {
        self.scale = scale
        return self
    }
    
    @inlinable func scaleRange(_ scaleRange: CGFloat) -> Self {
        self.scaleRange = scaleRange
        return self
    }
    
    @inlinable func scaleSpeed(_ scaleSpeed: CGFloat) -> Self {
        self.scaleSpeed = scaleSpeed
        return self
    }
    
    @inlinable func velocity(_ velocity: CGFloat) -> Self {
        self.velocity = velocity
        return self
    }
    
    @inlinable func velocityRange(_ velocityRange: CGFloat) -> Self {
        self.velocityRange = velocityRange
        return self
    }
    
    @inlinable func emissionLongitude(_ emissionLongitude: CGFloat) -> Self {
        self.emissionLongitude = emissionLongitude
        return self
    }
    
    @inlinable func emissionLatitude(_ emissionLatitude: CGFloat) -> Self {
        self.emissionLatitude = emissionLatitude
        return self
    }
    
    @inlinable func emissionRange(_ emissionRange: CGFloat) -> Self {
        self.emissionRange = emissionRange
        return self
    }
    
    @inlinable func spin(_ spin: CGFloat) -> Self {
        self.spin = spin
        return self
    }
    
    @inlinable func spinRange(_ spinRange: CGFloat) -> Self {
        self.spinRange = spinRange
        return self
    }
    
    @inlinable func color(_ color: UIColor) -> Self {
        self.color = color.cgColor
        return self
    }
    
    @inlinable func xAcceleration(_ xAcceleration: CGFloat) -> Self {
        self.xAcceleration = xAcceleration
        return self
    }
    
    @inlinable func yAcceleration(_ yAcceleration: CGFloat) -> Self {
        self.yAcceleration = yAcceleration
        return self
    }
    
    @inlinable func zAcceleration(_ zAcceleration: CGFloat) -> Self {
        self.zAcceleration = zAcceleration
        return self
    }
    
    @inlinable func alphaSpeed(_ alphaSpeed: Float) -> Self {
        self.alphaSpeed = alphaSpeed
        return self
    }
    
    @inlinable func alphaRange(_ alphaRange: Float) -> Self {
        self.alphaRange = alphaRange
        return self
    }
}


fileprivate extension EmitterCell.Content {
    var image: UIImage {
        switch self {
        case let .image(image):
            return image
        case let .circle(radius):
            let size = CGSize(width: radius * 2, height: radius * 2)
            return UIGraphicsImageRenderer(size: size).image { context in
                context.cgContext.setFillColor(UIColor.white.cgColor)
                context.cgContext.addPath(CGPath(ellipseIn: CGRect(origin: .zero, size: size), transform: nil))
                context.cgContext.fillPath()
            }
        }
    }
}

let items: [EmitterConfig] = [
    EmitterConfig(emitter: Emitters.red,
                  size: CGSize(width: Constants.width, height: 1),
                  shape: .line,
                  position: CGPoint(x: Constants.width / 2, y: 0)),
    EmitterConfig(emitter: Emitters.green,
                  size: CGSize(width: Constants.width, height: 1),
                  shape: .line,
                  position: CGPoint(x: Constants.width / 4, y: 10)),
    EmitterConfig(emitter: Emitters.blue,
                  size: CGSize(width: Constants.width, height: 1),
                  shape: .line,
                  position: CGPoint(x: Constants.width / 6, y: 20)),
    EmitterConfig(emitter: Emitters.yellow,
                  size: CGSize(width: Constants.width, height: 1),
                  shape: .line,
                  position: CGPoint(x: Constants.width / 8, y: 30)),
    EmitterConfig(emitter: Emitters.orange,
                  size: CGSize(width: Constants.width, height: 1),
                  shape: .line,
                  position: CGPoint(x: Constants.width / 10, y: 40)),
]

struct Emitters {
    static let red = ParticlesEmitter {
        EmitterCell()
            .content(.circle(8.0))
            .color(.red)
            .lifetime(10)
            .birthRate(30)
            .scale(0.1)
            .scaleRange(0.08)
            .velocity(100)
            .velocityRange(50)
            .yAcceleration(200.0)
            .emissionLongitude(.pi)
    }
    
    static let blue = ParticlesEmitter {
        EmitterCell()
            .content(.circle(8.0))
            .color(.blue)
            .lifetime(10)
            .birthRate(30)
            .scale(0.1)
            .scaleRange(0.08)
            .velocity(100)
            .velocityRange(50)
            .yAcceleration(200.0)
            .emissionLongitude(.pi)
    }
    
    static let green = ParticlesEmitter {
        EmitterCell()
            .content(.circle(8.0))
            .color(.green)
            .lifetime(10)
            .birthRate(30)
            .scale(0.1)
            .scaleRange(0.08)
            .velocity(100)
            .velocityRange(50)
            .yAcceleration(200.0)
            .emissionLongitude(.pi)
    }
    static let yellow = ParticlesEmitter {
        EmitterCell()
            .content(.circle(8.0))
            .color(.yellow)
            .lifetime(10)
            .birthRate(30)
            .scale(0.1)
            .scaleRange(0.08)
            .velocity(100)
            .velocityRange(50)
            .yAcceleration(200.0)
            .emissionLongitude(.pi)
    }
    static let orange = ParticlesEmitter {
        EmitterCell()
            .content(.circle(8.0))
            .color(.orange)
            .lifetime(10)
            .birthRate(30)
            .scale(0.1)
            .scaleRange(0.08)
            .velocity(100)
            .velocityRange(20)
            .yAcceleration(200.0)
            .emissionLongitude(.pi)
    }
}
