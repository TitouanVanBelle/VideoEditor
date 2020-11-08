# VideoEditor

A lightweight video editor without UI. See [VideoEditorKit](https://github.com/TitouanVanBelle/VideoEditorKit) for the version with UI

## Requirements

- iOS 13
- Combine

## Features

- Adjust speed rate
- Crop using presets
- Trim begining and end

## How to use

### Generate an AVPlayerItem

Create and configure a video edit object.

```swift
var edit = VideoEdit()
edit.isMuted = true
edit.speedRate = 0.5
edit.croppingPreset = .landscape
edit.trimPositions = (
    CMTime(value: 2, timescale: 1),
    CMTime(value: 6, timescale: 1)
)
```
Ask the video editor to apply these videos edits to a specific asset and 

```swift
editor.apply(edit: videoEdit, to: asset)
    .map { result -> AVPlayerItem? in
        let item = AVPlayerItem(asset: result.asset)
        item.videoComposition = result.videoComposition
        return item
    }
    .replaceError(with: nil)
    .sink { [weak self] item in
        self?.player.replaceCurrentItem(with: item)
    }
```

### Export to URL

```swift
editor.apply(edit: videoEdit, to: asset)
    .flatMap { result in
        result.export(to: outputUrl)
    }.sink { result in
        print("Failed to save edited video at \(outputUrl.path). Error: \(result)")
    } receiveValue: { _ in
        print("Successfully saved edited video at \(outputUrl.path)")
    }
```

## Video Editing Capabilities

| Property       | Type              | Default | Description                                                                                                 |
|----------------|-------------------|---------|-------------------------------------------------------------------------------------------------------------|
| isMuted        | Bool              | false   | Mutes the edited video if set to true                                                                       |
| speedRate      | Double            | 1.0     | Defines the speed ratio of the edited video. (e.g. 2.0 will result in an edited video played twice as fast) |
| trimPositions  | (CMTime, CMTime)? | nil     | Defines the times where the video should start and end                                                      |
| croppingPreset | CroppingPreset?   | nil     | Defines the cropping preset to apply to the edit video. See CroppingPreset                                  |

## Cropping Presets

| Preset    | Width / Height |
|-----------|----------------|
| vertical  | 3/4            |
| standard  | 4/3            |
| portrait  | 9/16           |
| square    | 1/1            |
| landscape | 16/9           |
| instagram | 4/5            |


## To do

- Tests
- Cropping (custom width/height ratio)
