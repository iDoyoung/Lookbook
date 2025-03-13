# Look Weather: 사진 앨범 옷차림 이미지 분류

## 개요

Look Weather는 Apple의 Core ML과 Vision 프레임워크를 사용하여 사용자의 사진 라이브러리에서 옷차림 이미지를 분류하는 기능이 있습니다.

### 주요 구성 요소

1. `PhotosWorking Protocol`: Photos 라이브러리에 접근하고 이미지를 처리하기 위한 인터페이스를 정의합니다.
2. `PhotosWorker Actor`: 동시성 처리 기능을 갖춘 PhotosWorking 프로토콜을 구현합니다.
3. `PhotosService` Photos 프레임워크(PHAsset)와의 상호작용을 처리합니다.
4. `OutfitImagePredictor`: Core ML 모델(OutfitV1)을 사용하여 이미지가 옷차림 관련인지 아닌지 분류합니다.

## 기술적 구현

### PhotosWorking 프로토콜

이 프로토콜은 두 가지 필수 메서드를 정의합니다:
- `requestAuthorizationStatus()`: 사용자의 Photos 라이브러리에 접근할 권한을 요청합니다.
- `fetchPhotosAssets(startDate:endDate:)`: 지정된 날짜 범위 내의 사진을 검색하고 처리합니다.

```swift
protocol PhotosWorking {
    func requestAuthorizationStatus() async -> PHAuthorizationStatus
    func fetchPhotosAssets(startDate: Date, endDate: Date) async -> [PHAsset]
}
```

### PhotosWorker Actor

이 액터는 PhotosWorking 프로토콜을 동시성 처리 기능과 함께 구현합니다. 
1. 데이터 경쟁 상태를 방지하기 위해 Swift의 현대적인 동시성 모델을 `actor` 키워드와 함께 사용합니다.
2. 병렬 이미지 분류를 위해 `TaskGroup`을 활용합니다.
3. 성능 최적화를 위해 `stride`를 사용해 batch 처리를 사용합니다.

```swift
actor PhotosWorker: @preconcurrency PhotosWorking {
    private let logger = Logger(...)
    private var service: PhotosServiceProtocol
    private var predictor: OutfitImagePredictor
    
    // 구현 세부 사항...
}
```

#### 성능 최적화

`fetchPhotosAssets` 메서드는 특정 최적화를 포함합니다:
- 오버헤드를 줄이기 위해 30개 이미지 단위로 배치 처리합니다.
- 병렬 처리를 위해 Swift의, 구조화된 동시성(`withTaskGroup`)을 사용합니다.
- 테스트 기반 성능 참고 사항(iPhone 14 Pro):
  - 배치 처리 사용 시 610개 사진 처리는 약 5-6초가 소요됩니다.
  - 배치 처리 없이는 동일한 작업에 15-16초가 소요됩니다.

```swift
let batchSize = 30
for batchStartIndex in stride(from: 0, to: totalCount, by: batchSize) {
    await withTaskGroup(of: PHAsset?.self) { group in
        // 배치를 병렬로 처리...
    }
}
```

### 개발 vs. 프로덕션 모드

코드는 동작을 변경하는 조건부 컴파일 플래그 `DEVELOP`을 포함합니다:
- 개발 모드: 테스트 목적으로 날짜 필터링 없이 모든 사진을 처리합니다.
- 프로덕션 모드: 처리할 사진 수를 제한하기 위해 날짜 범위 필터를 적용합니다.

```swift
#if DEVELOP
// 개발 모드 로직
#else
// 프로덕션 모드 로직
#endif
```

## Core ML 통합

애플리케이션은 `OutfitImagePredictor` 클래스를 통해 `OutfitV1`이라는 사용자 정의 모델을 사용합니다. 이 클래스는:

1. PHAsset에서 이미지 데이터를 가져옵니다.
2. Core ML 모델을 통해 처리합니다.
3. 이미지에 옷차림 관련 콘텐츠가 포함되어 있는지 여부를 나타내는 부울 값을 반환합니다.


## 성능 고려 사항

- 현재 구현은 iPhone 14 Pro에서 610개 사진을 5-6초 내에 처리합니다.
- 배치 크기 30은 테스트를 기반으로 최적으로 결정되었습니다.
- 추가 성능 개선 가능성:
  - 기기 성능에 따라 배치 크기를 동적으로 조정합니다.
  - 이전에 분류된 이미지에 대한 캐싱을 구현합니다.
  - Core ML 분류 전 이미지 전처리에 Metal을 활용합니다.

## 향후 개선 사항

TODO 주석에 언급된 바와 같이, 추가 성능 개선을 위한 여지가 있습니다:
- 다양한 기기 유형에 대한 대체 배치 크기 조사.
- 대규모 사진 라이브러리를 위한 백그라운드 처리 고려.
- 이전에 분류된 이미지의 재처리를 피하기 위한 결과 캐싱 구현.
