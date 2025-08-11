import SwiftUI
import MetalKit

struct MetalView: NSViewRepresentable {
    func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.drawableSize = mtkView.frame.size
        
        let renderer = MetalRenderer(metalKitView: mtkView)
        mtkView.delegate = renderer
        
        // Store the renderer in the coordinator to keep it alive
        context.coordinator.renderer = renderer
        
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        // Update view if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var renderer: MetalRenderer?
    }
}
