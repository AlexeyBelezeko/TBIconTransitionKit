# TBIconTransitionKit

TBIconTransitionKit  is an easy to use icon transition kit that allows to smoothly change from one shape to another.
Build on UIButton with CAShapeLayers It includes a set of the most common navigation icons. Feel free to recolor the them as you like and customise shapes — adjust the line spacing, edit the line width and it's cap.

[Rewriting project with ChatGPT](https://medium.com/@alexeyybelzeko/exploring-chatgpts-potential-addressing-advanced-programming-challenges-beyond-basic-games-39521ef03299)

[Animation on dribbble.com](http://drbl.in/poGN)

![](https://user-images.githubusercontent.com/1054094/234088798-763af7fd-f4d6-4b7d-ae9f-8bcc147dfff2.gif)

Both ways animated transitions:

- Menu ↔ Arrow
- Menu ↔ Cross 
- Cross ↔ Plus
- Plus ↔ Minus

## Usage

To run the example project, clone the repo, and open the TBIconTransitionKitExample project.

Add AnimatedButton to your SwiftUI view.

```swift
import SwiftUI
import TBIconTransitionKit

struct ContentView: View {
    @State private var buttonState: AnimatedButtonState = .menu

    var body: some View {
        AnimatedButton(state: .menu, configure: { button in
            button.backgroundColor = UIColor(hex: .black)
            button.lineColor = .white
        }, action: { button in
            if button.currentState == .menu {
                button.animationTransform(to: .arrow)
            } else {
                button.animationTransform(to: .menu)
            }
        })
    }
}

```

### Customize the design

- `lineHeight`
- `lineWidth`
- `lineSpacing`
- `lineColor`
- `lineCap`

## Requirements

- iOS 13 or higher

## Installation

TBIconTransitionKit can be installed using Swift Package Manager.

1. In Xcode, open your project, and select File > Swift Packages > Add Package Dependency.
2. Enter the repository URL https://github.com/AlexeyBelezeko/TBIconTransitionKit and click Next.
3. Select the version you'd like to use and click Next.
4. Finally, click Finish to add the package to your project.

## Author

- [AlexeyBelezeko](https://github.com/AlexeyBelezeko) 
- [Oleg Turbaba](https://dribbble.com/turbaba)
- [ChatGPT]

## License

TBIconTransitionKit is available under the MIT license. See the LICENSE file for more info.
