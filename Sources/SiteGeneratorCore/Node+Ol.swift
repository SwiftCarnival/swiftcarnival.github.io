import Html

extension Node {
    static func ol(attributes: [Attribute<Tag.Ol>] = [], _ content: [ChildOf<Tag.Ol>]) -> Node {
        .element("ol", attributes: attributes, ChildOf<Tag.Ol>.fragment(content).rawValue)
    }
}
