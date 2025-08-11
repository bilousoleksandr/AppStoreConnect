import Metal
import MetalKit

@MainActor
class MetalRenderer: NSObject, MTKViewDelegate {
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var renderPipelineState: MTLRenderPipelineState
    private var uniformBuffer: MTLBuffer
    private var startTime: CFTimeInterval
    
    // Uniforms structure matching the shader
    struct Uniforms {
        var time: Float
        var resolution: SIMD2<Float>
    }
    
    init?(metalKitView: MTKView) {
        guard let device = metalKitView.device else {
            return nil
        }
        
        self.device = device
        self.startTime = CACurrentMediaTime()
        
        guard let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        self.commandQueue = commandQueue
        
        // Create uniform buffer
        guard let uniformBuffer = device.makeBuffer(
            length: MemoryLayout<Uniforms>.size,
            options: [.storageModeShared]
        ) else {
            return nil
        }
        self.uniformBuffer = uniformBuffer
        
        // Load shaders and create render pipeline
        guard let library = device.makeDefaultLibrary() else {
            return nil
        }
        
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print("Failed to create render pipeline state: \(error)")
            return nil
        }
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle resize if needed
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // Update uniforms
        let currentTime = Float(CACurrentMediaTime() - startTime)
        let resolution = SIMD2<Float>(Float(view.drawableSize.width), Float(view.drawableSize.height))
        
        let uniforms = Uniforms(time: currentTime, resolution: resolution)
        let uniformPointer = uniformBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
        uniformPointer.pointee = uniforms
        
        // Set clear color to black
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        renderEncoder.setRenderPipelineState(renderPipelineState)
        renderEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
