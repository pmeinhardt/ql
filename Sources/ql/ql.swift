@main
public struct ql {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(ql().text)
    }
}
