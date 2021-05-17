/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 Helper functions and convenience extensions for system types.
 */

import ARKit
import MetalKit
import ModelIO
import RealityKit

extension simd_float4x4 {
    var position: SIMD3<Float> {
        return SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    }
}

extension Transform {
    static func * (left: Transform, right: Transform) -> Transform {
        return Transform(matrix: simd_mul(left.matrix, right.matrix))
    }
}

extension ARMeshGeometry {
    func vertex(at index: UInt32) -> SIMD3<Float> {
//        assert(vertices.format == MTLVertexFormat.float3, "Expected three floats (twelve bytes) per vertex.")
//        let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
//        let vertex = vertexPointer.assumingMemoryBound(to: (Float, Float, Float).self).pointee
//        return vertex
        assert(vertices.format == MTLVertexFormat.float3, "Expected three floats (twelve bytes) per vertex.")
        let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
        let vertex = vertexPointer.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        return vertex
    }
}

extension ARMeshGeometry {
    func toMDLMesh(device: MTLDevice, transform: simd_float4x4) -> MDLMesh {
        let allocator = MTKMeshBufferAllocator(device: device)

        let data = Data(bytes: transformedVertexBuffer(transform), count: vertices.stride * vertices.count)
        let vertexBuffer = allocator.newBuffer(with: data, type: .vertex)
//        let material = MDLMaterial()

        let indexData = Data(bytes: faces.buffer.contents(), count: faces.bytesPerIndex * faces.count * faces.indexCountPerPrimitive)
        let indexBuffer = allocator.newBuffer(with: indexData, type: .index)

        let submesh = MDLSubmesh(indexBuffer: indexBuffer,
                                 indexCount: faces.count * faces.indexCountPerPrimitive,
                                 indexType: .uInt32,
                                 geometryType: .triangles,
                                 material: nil)

        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition,
                                                            format: .float3,
                                                            offset: 0,
                                                            bufferIndex: 0)
        vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: vertices.stride)

        return MDLMesh(vertexBuffer: vertexBuffer,
                       vertexCount: vertices.count,
                       descriptor: vertexDescriptor,
                       submeshes: [submesh])
    }

    func transformedVertexBuffer(_ transform: simd_float4x4) -> [Float] {
        var result = [Float]()
        for index in 0 ..< vertices.count {
            let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + vertices.stride * index)
            let vertex = vertexPointer.assumingMemoryBound(to: (Float, Float, Float).self).pointee
            var vertextTransform = matrix_identity_float4x4
            vertextTransform.columns.3 = SIMD4<Float>(vertex.0, vertex.1, vertex.2, 1)
            let position = (transform * vertextTransform).position
            result.append(position.x)
            result.append(position.y)
            result.append(position.z)
        }
        return result
    }
}

extension Array where Element == ARMeshAnchor {
    func save(to fileURL: URL, device: MTLDevice) throws {
//        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset()
        forEach {
            let mesh = $0.geometry.toMDLMesh(device: device, transform: $0.transform)
            asset.add(mesh)
        }
        try asset.export(to: fileURL)
    }

//    func create(to file: URL, device: MTLDevice){}
}

class Colorizer {
    struct storedColors {
        var id: UUID
        var color: UIColor
    }

    var savedColors = [storedColors]()

    init() {
    }

    func assignColor(to: UUID, classification: ARMeshClassification) -> UIColor {
        return savedColors.first(where: { $0.id == to })?.color ?? saveColor(uuid: to, classification: classification)
    }

    func saveColor(uuid: UUID, classification: ARMeshClassification) -> UIColor {
        let newColor = UIColor.red
        let stored = storedColors(id: uuid, color: newColor)
        savedColors.append(stored)
        return newColor
    }
}

extension SCNGeometry {
    convenience init(arGeometry: ARMeshGeometry) {
        let verticesSource = SCNGeometrySource(arGeometry.vertices, semantic: .vertex)
        let normalsSource = SCNGeometrySource(arGeometry.normals, semantic: .normal)
        let faces = SCNGeometryElement(arGeometry.faces)
        self.init(sources: [verticesSource, normalsSource], elements: [faces])
    }
}

extension SCNGeometrySource {
    convenience init(_ source: ARGeometrySource, semantic: Semantic) {
        self.init(buffer: source.buffer, vertexFormat: source.format, semantic: semantic, vertexCount: source.count, dataOffset: source.offset, dataStride: source.stride)
    }
}

extension SCNGeometryElement {
    convenience init(_ source: ARGeometryElement) {
        let pointer = source.buffer.contents()
        let byteCount = source.count * source.indexCountPerPrimitive * source.bytesPerIndex
        let data = Data(bytesNoCopy: pointer, count: byteCount, deallocator: .none)
        self.init(data: data, primitiveType: .of(source.primitiveType), primitiveCount: source.count, bytesPerIndex: source.bytesPerIndex)
    }
}

extension SCNGeometryPrimitiveType {
    static func of(_ type: ARGeometryPrimitiveType) -> SCNGeometryPrimitiveType {
        switch type {
        case .line:
            return .line
        case .triangle:
            return .triangles
        @unknown default:
            return .line
        }
    }
}
