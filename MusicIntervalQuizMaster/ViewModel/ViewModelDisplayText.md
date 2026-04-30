이 상황에서는 보통 **ViewModel에서 직접 Entity를 조합하지 않습니다.**
대신 아래 3가지 방식 중 하나로 처리하는 게 일반적입니다.

---

## 1️⃣ 가장 많이 쓰는 방식: “ViewData / DTO” 변환

CoreData Entity → 화면용 모델로 변환

```swift
struct BookmarkDisplayModel: Identifiable {
  let id: NSManagedObjectID
  let text: String
}
```

ViewModel에서 변환:

```swift
var displayItems: [BookmarkDisplayModel] {
  bookmarks.map {
    BookmarkDisplayModel(
      id: $0.objectID,
      text: makeText(from: $0)
    )
  }
}
```

텍스트 조합 함수:

```swift
private func makeText(from entity: BookmarkIntervalEntity) -> String {
  let start = "\(entity.startNoteLetter ?? "")\(entity.startNoteAccidental ?? "")\(entity.startNoteOctave)"
  let end = "\(entity.endNoteLetter ?? "")\(entity.endNoteAccidental ?? "")\(entity.endNoteOctave)"
  
  return "\(start) → \(end) (\(entity.direction ?? ""), \(entity.clef ?? ""))"
}
```

👉 장점

* View는 단순해짐
* Entity 직접 접근 안 함
* 테스트 쉬움

---

## 2️⃣ 간단한 경우: ViewModel 내부 함수

질문에서 말한 “3번 원소 조합” 같은 경우:

```swift
func text(at index: Int) -> String? {
  guard bookmarks.indices.contains(index) else { return nil }
  
  let e = bookmarks[index]
  
  let start = "\(e.startNoteLetter ?? "")\(e.startNoteAccidental ?? "")\(e.startNoteOctave)"
  let end = "\(e.endNoteLetter ?? "")\(e.endNoteAccidental ?? "")\(e.endNoteOctave)"
  
  return "\(start) → \(end)"
}
```

👉 이건 간단하지만:

* 로직이 ViewModel에 퍼짐
* 재사용성 떨어짐

---

## 3️⃣ 확장(extension)으로 분리 (실무에서 꽤 많이 씀)

Entity를 직접 수정 못해도 extension은 가능:

```swift
extension BookmarkIntervalEntity {
  var displayText: String {
    let start = "\(startNoteLetter ?? "")\(startNoteAccidental ?? "")\(startNoteOctave)"
    let end = "\(endNoteLetter ?? "")\(endNoteAccidental ?? "")\(endNoteOctave)"
    
    return "\(start) → \(end)"
  }
}
```

👉 사용:

```swift
bookmarks[2].displayText
```

👉 장점

* 가장 깔끔
* 재사용 가능
* View에서도 바로 사용 가능

---

## 정리 (실무 기준)

우선순위:

1. **DTO / ViewData 변환** → 가장 권장
2. **Entity extension** → 간단하고 실용적
3. **ViewModel 함수 직접 처리** → 작은 경우만

---

## 결론

> “Entity를 건드릴 수 없을 때”

* **extension으로 계산 프로퍼티 추가하거나**
* **ViewModel에서 별도 DisplayModel로 변환**

이 두 가지가 표준적인 접근입니다.

