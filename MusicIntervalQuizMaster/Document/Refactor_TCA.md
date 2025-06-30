# Refactor to TCA (2025.06.26)

**TCA 기반으로 리팩터링할 때**, 아래와 같이 **State/Action 단위로 기능을 나누는 것**이 가장 자연스럽습니다.
기존 `QuizViewModel`과 `QuizView`는 여러 역할이 섞여 있으므로, TCA 구조에 맞게 분해가 필요합니다.

---

## ✅ 리팩터링 시 분리해야 할 기능 목록 (State / Action 단위)

### 1. `QuizSessionDomain`

* **역할**: 퀴즈 진행 로직을 담당하는 핵심 도메인
* **State 구성 요소**
  * `session: QuizSession`
  * `pairs: [IntervalPair]`
  * `currentPairIndex: Int`
  * `answerMode: QuizAnswerMode`
  * `sessionCreated: Int`
  * `answerCount`, `wrongCount`, `answerPercentText`, `answerText` (파생 상태)
  
* **Action**
  * `.startNewSession`
  * `.nextQuestion`
  * `.prevQuestion`
  * `.checkAnswer(modifier, number)`
  * `.resetSession`
  * `.resetAnswerMode`
  * `.resetForBackground`

---

### 2. `TimerDomain`

* **역할**: 타이머 카운트다운과 만료 처리
* **State**
  * `remainingTime: Double`
  * `isActive: Bool`
  
* **Action**
  * `.start(duration)`
  * `.tick`
  * `.stop`
  * `.expired`

---

### 3. `KeyboardDomain`

* **역할**: 터치 키보드 상태 및 입력 관리
* **State**
  * `intervalModifier: IntervalModifier`
  * `intervalNumber: Int`
  * `answerMode: QuizAnswerMode`
  
* **Action**
  * `.setModifier(_:)`
  * `.setNumber(_:)`
  * `.submitAnswer`
  * `.reset`

---

### 4. `SoundDomain` (선택)

* **역할**: 사운드 재생 제어
* **Action**
  * `.playPair(start: Note, end: Note, direction: Direction)`
  * `.stopAll`
  * `.playIncorrectSound`

---

### 5. `AlertDomain` (or QuizState 내부 `alert` 프로퍼티로도 가능)

* **역할**: 정답/오답/세션 생성 알림 상태 표시
* **State**
  * `showAnswerAlert: Bool`
  * `showNewSessionAlert: Bool`
  * `animateAlertDismiss: Bool`
  
* **Action**
  * `.showAnswerAlert`
  * `.hideAnswerAlert`
  * `.showNewSessionAlert`

---

### 6. `Sheet/ModalDomain` (또는 `QuizState` 내의 값)

* **State**
  * `showInfoModal: Bool`
* **Action**
  * `.toggleInfoModal`

---

### 7. `AppSettingsDomain` (or Dependency)

* **역할**: @AppStorage 값 관리
* `cfgQuizSoundAutoplay`
* `cfgTimerSeconds`
* `cfgQuizSheetPosition`
* `cfgAppAutoNextMove`
* `cfgHapticAnswer`, `cfgHapticWrong`, `cfgHapticPressedIntervalKeyboard`

※ 보통 `@Dependency(\.userDefaults)`를 통해 처리하거나, 별도 `SettingsState`로 추상화

---

### 📦 예시 계층 구조

```swift
RootDomain
├─ QuizSessionDomain
│  ├─ TimerDomain
│  └─ KeyboardDomain
├─ AlertDomain (또는 QuizSession 내부)
└─ Settings (Dependency 또는 하위 도메인)
```

---

## ✅ 요약: 기능 단위로 분류

| 도메인               | 주요 책임                   |
| ----------------- | ----------------------- |
| QuizSessionDomain | 세션 생성, 문제 전환, 정답 판별     |
| TimerDomain       | 카운트다운, 만료 처리            |
| KeyboardDomain    | 키보드 상태 추적, 정답 입력        |
| Alert/Modal       | 알림, 시트 표시 상태 관리         |
| SoundDomain       | 음 재생 (옵션)               |
| SettingsDomain    | 설정값 (UserDefaults 등) 관리 |

---
