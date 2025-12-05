# UI UX 디자인 시스템 가이드

**📱 빌빌(BillBill) UI/UX Design System Guideline
1. 핵심 기능 구조 분석 (Core Structure)**
PRD의 핵심은 **'빌린 돈'과 '빌려준 돈'의 명확한 구분**과 **'빠른 입력'**입니다. 이를 시각적 언어로 변환하기 위해 두 가지 핵심 축을 설정합니다.
1. **Dual Color Coding (이원화된 색상 코드):**
    ◦ **빌려준 돈 (Asset/Positive):** 받을 권리 → **Green/Teal** 계열 (안정감, 긍정)
    ◦ **빌린 돈 (Liability/Negative):** 갚을 의무 → **Red/Orange** 계열 (경고, 긴급)
    ◦ *이 색상 구분은 앱 전체(요약 카드, 리스트, 입력 폼, 그래프)에서 일관되게 사용됩니다.*
2. **Context-First Navigation:**
    ◦ 복잡한 뎁스(Depth)를 지양하고, 홈 화면에서 **현재 상태(잔액)**를 즉시 파악한 후 **액션(추가/정산)**으로 바로 이어지는 구조를 가집니다.
**2. 사용자 플로우 & 화면 구조 설계 (User Flow)**
GoRouter 설계를 고려하여 화면 위계를 정의합니다.
**2.1 Navigation Structure (Site Map)**
• **Level 0 (Root):** `Dashboard (Home)`
• **Level 1 (Modal/Push):** `Add Transaction (Writer)`
• **Level 2 (Detail):** `Transaction Detail (Viewer & Editor)`
• **Level 3 (Settings):** `Preferences & Backup`
**2.2 Key User Flows**
1. **빠른 거래 추가 (Fast Entry)**
    ◦ 홈 → (+) 버튼 탭 → [Bottom Sheet] 열림 → 유형 선택(Tab) → 금액 입력(Keypad) → 대상 선택 → 완료
    ◦ *UX 포인트: 키패드 자동 활성화로 탭 횟수 최소화.*
2. **부분 상환 (Partial Repayment)**
    ◦ 리스트 아이템 탭 → 상세 화면 → '상환하기' 버튼 → 금액 입력 → 저장
    ◦ *UX 포인트: 남은 잔액이 자동으로 계산되어 피드백 제공.*
**3. UI 컴포넌트 시스템 (Atomic Design for Flutter)**
Flutter 위젯 개발 단위를 고려하여 정의했습니다.
**3.1 Atoms (기본 요소)**
• **Status Chip:** 거래 상태를 나타내는 작은 태그.
    ◦ `Ongoing`: 배경색(Light Tint) + 텍스트(Main Color)
    ◦ `Completed`: 회색조(Grey) + 취소선 텍스트
• **Money Text:** 금액 표기 전용 위젯.
    ◦ Font: `Monospace` 또는 숫자 가독성이 좋은 폰트(Inter/Roboto).
    ◦ Format: 3자리 콤마 필수, 원 단위(₩) 앞/뒤 배치 통일.
• **Avatar:** 상대방 프로필.
    ◦ 이미지 없을 시: 이름 첫 글자 + 랜덤 파스텔 배경.
**3.2 Molecules (조합 요소)**
• **Transaction List Item (핵심 반복 요소)**
    ◦ **Leading:** Avatar (상대방)
    ◦ **Title:** 상대방 이름
    ◦ **Subtitle:** 날짜 · 메모 요약
    ◦ **Trailing:** 금액 (빌려줌: Green / 빌림: Red) + 상태 칩
    ◦ **Interaction:** `Dismissible` 위젯 적용 (좌: 수정, 우: 상환/삭제)
• **Input Field Group**
    ◦ Label + TextField + Validation Message가 결합된 형태.
**3.3 Organisms (복합 요소)**
• **Summary Card (Dashboard Hero)**
    ◦ 총 받을 돈 / 총 갚을 돈 / 순자산 3가지 데이터를 보여주는 카드.
    ◦ Gradient 배경을 사용하여 시각적 강조.
• **History Timeline**
    ◦ 상세 화면에서 '최초 거래'부터 '부분 상환', '완료'까지의 이력을 수직선으로 연결하여 보여주는 위젯.
**4. Design Tokens (Flutter Implementation Ready)**
`ThemeData`에 바로 적용할 수 있는 토큰 값입니다.
**4.1 Color Palette**
빌빌의 정체성을 결정하는 색상입니다. 접근성(Contrast)을 고려했습니다.**Token NameHex CodeSemantic Role`primaryGreen**#00C853`**빌려준 돈 (받을 돈)**, 긍정 버튼, 완료 체크`bgGreen#E8F5E9`빌려준 돈 배경, 칩 배경**`primaryRed**#FF5252`**빌린 돈 (갚을 돈)**, 중요 알림, 연체`bgRed#FFEBEE`빌린 돈 배경, 칩 배경`surfaceWhite#FFFFFF`카드 배경, 바텀시트 배경`bgGrey#F5F6F8`앱 전체 배경색 (Scaffold Background)`textBlack#212121`기본 본문, 타이틀`textGrey#9E9E9E`보조 설명, 날짜, 비활성 텍스트
**4.2 Typography (TextTheme)**
Flutter `TextTheme` 매핑 제안입니다.
• **Display Large (32px, Bold):** 홈 화면 순잔액, 입력 키패드 금액 표시
• **Title Medium (16px, SemiBold):** 리스트 아이템의 상대방 이름, 앱바 타이틀
• **Body Medium (14px, Regular):** 메모, 일반 텍스트
• **Label Small (12px, Medium):** 칩 텍스트, 하단 캡션
**4.3 Shapes & Spacing**
• **Radius:**
    ◦ Card: `16.0` (부드러운 느낌)
    ◦ Bottom Sheet: `Top-20.0`
    ◦ Button: `8.0` or `12.0`
• **Elevation (Shadow):**
    ◦ 최소화 전략. Flat 디자인을 기본으로 하되, `Summary Card`와 `Floating Action Button (FAB)`에만 약한 그림자 적용.
**5. UX Interaction Guideline**
Flutter의 애니메이션 기능을 활용하여 앱의 완성도를 높입니다.
**5.1 제스처 및 동작 (Gestures)**
• **Swipe to Action:** 리스트 아이템을 밀어서 빠른 처리.
    ◦ 왼쪽으로 밀기 (Left Swipe): **상환 처리 (Complete)** (배경: 해당 거래 색상)
    ◦ 오른쪽으로 밀기 (Right Swipe): **편집 (Edit)** (배경: Grey)
• **Keyboard Handling:**
    ◦ 금액 입력 화면 진입 시 키보드(또는 커스텀 키패드)가 **즉시(0ms 딜레이)** 올라와야 함.
    ◦ 배경 터치 시 `FocusScope.of(context).unfocus()` 호출로 키보드 내리기.
**5.2 피드백 (Feedback)**
• **Haptic Feedback:**
    ◦ 금액 입력 시 키패드 터치마다 `HapticFeedback.lightImpact()` 발생.
    ◦ 거래 저장/삭제 완료 시 `HapticFeedback.mediumImpact()` 발생.
• **Toast Message (SnackBar):**
    ◦ 저장/삭제 후 하단에 "저장되었습니다" 스낵바 노출 + "실행 취소(Undo)" 버튼 제공.
**5.3 빈 화면 (Empty States)**
데이터가 없을 때(Null) 사용자 이탈을 막는 가이드입니다.
• **홈 화면:** "아직 거래 내역이 없네요. \n가까운 친구와의 점심값부터 기록해볼까요?" 문구와 함께 화살표가 (+) 버튼을 가리키는 일러스트 배치.
• **검색 결과 없음:** "검색 결과가 없습니다." (단순 텍스트).
**6. 브랜드 보이스 & UI 원칙 (Design Principles)
6.1 브랜드 보이스 (Tone & Manner)**
• **신뢰하되 딱딱하지 않게:** 금융 앱이지만 개인 간 거래이므로 '송금'보다는 '전달', '채무'보다는 '빌린 돈' 같은 구어체 용어 사용.
• **객관적 전달:** 돈과 관련된 숫자는 감정 없이 명확하게 전달. (예: "큰일났어요! 갚아야 해요!" (X) -> "상환 예정일이 지났습니다." (O))
**6.2 UI 원칙**
1. **Reduce Clicks:** 입력 과정에서 불필요한 클릭을 제거한다. (예: 날짜는 '오늘'이 기본값)
2. **Color Means Data:** 색상을 장식으로 쓰지 않고 정보(받을 돈 vs 줄 돈)로만 사용한다.
3. **Local First:** 로딩 스피너(Loading Indicator)를 최소화한다. 로컬 DB(Hive)를 사용하므로 화면 전환은 즉각적이어야 한다.