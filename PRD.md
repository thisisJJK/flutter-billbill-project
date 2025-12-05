# 1. 요구사항 분석 & 문제 정의

## 문제 정의 (Problem)

- 개인이 친구/가족/동료에게 **빌려주거나 빌린 돈**을 간단히 기록·관리하기 어렵다.
- 메모나 스프레드시트로는 **정산 미스**와 **연속 추적**(상환/연체/부분 상환)이 어렵다.
- 여러 거래(P2P)에서 누적 잔액, 상환 일정, 알림, 분쟁 증빙(메모/영수증)이 필요하다.

## 타깃 사용자 (Target)

- 20~45세: 친구, 동료 간 소액 대여를 자주 하는 일반 사용자
- 프리랜서/개인사업자: 소액 거래 및 청구 관리가 필요한 사용자
- 팀 리더/프로젝트 매니저: 소규모 내에서 비용 정산용

## 핵심 가치 (Core Value)

- **빠르고 적게 누르는 입력**으로 거래 기록을 남길 수 있음
- **명확한 잔액·상환 상태**(빌려준돈 / 빌린돈 구분)
- **정산 알림 및 부분 상환 관리**로 분쟁 감소
- **로컬 우선 + 안전한 백업(내보내기/암호화)**

## 핵심 가설 (Key Hypotheses)

1. 사용자들은 단순하고 빠른 입력 UI가 있으면 수동 입력을 지속한다.
2. 알림(상환 예정)과 간단한 통계(잔액 요약)가 있으면 재방문률(DAU/MAU)이 증가한다.
3. 무료 기능으로 확보하고, 고급 기능(영수증 첨부·CSV 자동 동기화·다중 장부)은 유료구독으로 전환된다.

## 경쟁 서비스/차별점 (Competitors & Differentiation)

- 경쟁: 단순 가계부 앱, 빌린 돈 전용 앱(국내 앱들), 메모/스프레드시트
- 차별점:
    - Solo 개발자가 빠르게 유지보수 가능한 **경량 로컬 우선 아키텍처(Hive)**.
    - **간단 정산 흐름** + **부분 상환 기능**에 초점.
    - **프라이버시(로컬 암호/백업)** 우선, 서버 없이 동작 가능(옵션으로 클라우드 백업).

---

# 2. 전체 기능 정의 (Feature List)

> 표: 기능 / 유형 / 난이도 / 예상 공수(인간일, 1인) / 우선순위
> 

| 기능 | 유형 | 난이도 | 예상 공수 (인간일) | 우선순위 |
| --- | --- | --- | --- | --- |
| 거래 추가/수정/삭제(빌린/빌려준 구분) | MVP | 낮음 | 2일 | 필수 |
| 목록(정렬/필터/검색) & 잔액 요약 | MVP | 낮음 | 2일 | 필수 |
| 부분 상환 처리(부분 지불 기록) | MVP | 중간 | 3일 | 필수 |
| 결제/상환 예정 알림(로컬 알림) | MVP | 중간 | 2일 | 필수 |
| 카테고리/태그, 상대방(연락처) 관리 | 확장 | 낮음 | 2일 | 중간 |
| CSV 내보내기/가져오기(백업) | MVP | 낮음 | 2일 | 필수 |
| 영수증(사진) 첨부, 메모 확장 | 확장 | 중간 | 3일 | 중간 |
| 데이터 암호화(로컬 암호/생체 잠금) | 확장 | 중간 | 3일 | 중간 |
| 다중 장부/계정(개인/사업 등) | 확장 | 중간 | 4일 | 낮음 |
| 클라우드 백업/동기화(선택적) | 확장 | 높음 | 7일 | 낮음 |
| 광고 삽입(광고 네트워크) | 확장 | 낮음 | 1일 | 낮음(모네타이즈) |
| 프리미엄 구독(영수증 OCR, 다중장부, 자동동기화) | 확장 | 중간 | 2일 | 중간 |

> 주: 인간일(human-days) 은 1인 기준, 설계·테스트 포함 대략적 추정치(버그 픽스/QA 제외). Solo 개발자 현실에 맞춰 보수적으로 산정.
> 

---

# 3. 상세 기능 명세 (Detailed Feature Specs)

> 핵심 MVP 기능들을 중심으로 상세화. 각 기능별로 동일한 항목을 포함.
> 

## 3.1 거래 추가/수정/삭제 (Add/Edit/Delete Transaction)

- **기능 목적**
    - 사용자가 빌렸거나 빌려준 금액을 빠르게 기록.
- **성공 조건 (Success Metrics)**
    - 거래 추가 성공률 99% (버그 없음)
    - 평균 입력 시간 ≤ 10초(빠른 입력 UX)
- **사용자 플로우**
    1. 홈 → "+ 추가" 버튼 → 거래 입력 팝업
    2. 유형 선택(빌려준 / 빌린) → 상대방 입력(자동완성) → 금액 → 날짜 → 메모(선택) → 저장
- **화면 리스트**
    - 거래 입력 모달/화면
    - 상대방 선택 화면(연락처 연동 옵션)
- **UI/UX 요구사항**
    - 최소 입력 필드(타입, 상대, 금액, 날짜). 금액 필드 숫자패드.
    - "빠른 저장" CTA(완료 버튼) 항상 화면 하단에 고정.
    - 최근 상대 자동완성/제안.
- **예외 케이스**
    - 금액 0 또는 음수 입력 방지.
    - 동일 거래 중복 확인 (사용자 경고 후 저장).
- **관련 API / 데이터 필요**
    - Hive 모델: Transaction(id, type, counterpartyId, amount, date, status, notes, attachments[], createdAt, updatedAt)

## 3.2 목록(정렬/필터/검색) & 잔액 요약

- **기능 목적**
    - 전체 거래를 쉽게 탐색하고 현재 잔액(빌려준 총액 / 빌린 총액)을 즉시 확인.
- **성공 조건**
    - 잔액 카드 가독성 테스트에서 90% 사용자 이해.
- **사용자 플로우**
    - 홈(요약 카드 + 목록) → 필터(미상환/전체/상대별)
- **화면 리스트**
    - 홈: 요약 카드(빌려준/빌린/순잔액), 최근 거래 리스트
    - 필터/검색 바
- **UI/UX 요구사항**
    - 요약 카드 색상으로 빌려준(녹색)/빌린(빨간) 구분(색맹 보조 표시 포함).
    - 각 항목에서 슬라이드로 빠른 상환/편집/삭제 액션.
- **예외 케이스**
    - 데이터가 없을 때 빈 상태 안내 및 가이드 문구 제공.
- **관련 API / 데이터 필요**
    - Transaction 쿼리 인덱스: 날짜, 상대방, 상태

## 3.3 부분 상환 처리

- **기능 목적**
    - 전체 금액 중 일부만 상환되었을 때 정확히 기록(잔액 갱신).
- **성공 조건**
    - 부분 상환 후 잔액 계산 오류 0건.
- **사용자 플로우**
    - 거래 선택 → "부분 상환" → 금액 입력 → 결제 방식 선택(현금/이체/카드/메모) → 저장
- **화면 리스트**
    - 거래 상세 → 상환 히스토리(+ 추가)
- **UI/UX 요구사항**
    - 상환 히스토리 표시(타임스탬프, 금액, 메모)
    - 남은 금액(잔액) 시각 강조
- **예외 케이스**
    - 상환 금액이 남은 금액 초과 시 오류 표시
- **관련 API / 데이터 필요**
    - Payment 모델: id, transactionId, amount, date, method, notes

## 3.4 로컬 알림 (상환 예정 알림)

- **기능 목적**
    - 예정일에 대한 로컬 알림으로 상환을 상기시킨다.
- **성공 조건**
    - 알림 수신율(디바이스에서 권한 허용 시) 95%
- **사용자 플로우**
    - 거래 입력 시 "알림 날짜/주기" 설정 → 로컬 알림 스케줄링
- **화면 리스트**
    - 거래 입력(알림 섹션), 설정(알림 기본값)
- **UI/UX 요구사항**
    - 알림 허용 가이드 및 권한 요청 흐름
- **예외 케이스**
    - 알림 권한 거부 시 대체 UI(배너로 권장)
- **관련 API / 데이터 필요**
    - Alarm model: id, transactionId, schedule, repeat, enabled

## 3.5 CSV 내보내기/가져오기 (백업)

- **기능 목적**
    - 데이터 안전성 보장(내보내기) 및 다른 장치로 이전 가능.
- **성공 조건**
    - 내보내기/가져오기 성공률 99%
- **사용자 플로우**
    - 설정 → 데이터 내보내기(파일 생성) / 가져오기(파일 선택)
- **UI/UX 요구사항**
    - CSV 표준 헤더 제공, 가져오기 시 매핑 안내
- **예외 케이스**
    - 잘못된 포맷 업로드 시 상세 오류 메시지
- **관련 API / 데이터 필요**
    - Export/Import util

---

# 4. 기술 설계 (Tech Spec — Flutter + Riverpod + GoRouter + Hive)

## 4.1 전체 아키텍처 (개요)

- **원칙**: Clean Architecture + Feature-first 모듈화, Local-first (Hive) with optional cloud sync later.
- 레이어:
    - UI (Widgets, Screens)
    - Presentation (Riverpod providers / state)
    - Domain (Entities, UseCases)
    - Data (Repositories, Hive data sources, optional Remote sources)

## 4.2 권장 폴더 구조 (clean architecture 기반)

```
lib/
├─ main.dart
├─ app.dart
├─ core/
│  ├─ constants/
│  ├─ utils/
│  ├─ widgets/
│  └─ services/          # 로컬 알림, 백업, 암호화 서비스
├─ features/
│  ├─ transactions/
│  │  ├─ data/
│  │  │  ├─ models/
│  │  │  ├─ datasources/ # hive adapters
│  │  │  └─ repositories/
│  │  ├─ domain/
│  │  │  ├─ entities/
│  │  │  └─ usecases/
│  │  └─ presentation/
│  │     ├─ providers/
│  │     └─ pages/
│  └─ settings/
├─ routes/
└─ hive_adapters/

```

## 4.3 상태관리 설계 (Riverpod)

- **Provider 종류 제안**
    - `transactionsRepositoryProvider` — Repository (CRUD)
    - `transactionsListStreamProvider` — StreamProvider<List> (목록, 실시간 변경 반영)
    - `transactionDetailProvider(transactionId)` — FutureProvider or StateNotifierProvider
    - `summaryProvider` — Computed provider(빌려준/빌린 합계)
    - `settingsProvider` — StateNotifierProvider (앱설정/알림 설정)
    - `authProvider` (향후 클라우드 동기화 시)
- **패턴**
    - Use Case 단위로 로직 캡슐화. Presentation은 provider에서 UseCase 호출.

## 4.4 라우팅 설계 (Go Router)

- **route map 예시**

```dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/', name: 'home', builder: ... , routes: [
      GoRoute(path: 'transaction/:id', name: 'transactionDetail', builder: ...),
      GoRoute(path: 'add', name: 'addTransaction', builder: ...),
    ]),
    GoRoute(path: '/settings', name: 'settings', builder: ...),
  ],
);

```

- **nested routes**: 홈 하위로 상세/추가를 두어 모달/스택 전환이 자연스럽게.

## 4.5 Hive 데이터 모델 설계

- **Entity / Adapter**
    - `Transaction` (type: enum {lent, borrowed}, counterpartyId, amount, currency, date, status {open/closed}, notes, attachments, payments[], createdAt, updatedAt)
    - `Counterparty` (id, name, phone, email, avatarPath)
    - `Payment` (id, transactionId, amount, date, method, notes)
    - `Alarm` (id, transactionId, schedule, repeat)
- **인덱싱**
    - Hive 박스: transactionsBox, counterpartiesBox, paymentsBox, settingsBox
    - Query 성능 향상을 위해 거래의 date와 status, counterpartyId를 필드로 유지.

## 4.6 필요한 외부 패키지 (권장)

- UI / 구조: `flutter_riverpod`, `go_router`, `hive`, `hive_flutter`
- Local DB/파일: `path_provider`
- 알림: `flutter_local_notifications`
- 이미지/파일: `image_picker`, `flutter_image_compress` (선택)
- 백업/CSV: `csv`, `share_plus`
- 보안: `flutter_secure_storage` (암호/토큰 저장)
- 기타: `intl` (날짜·통화 포맷)

> 선택적(추후): cloud_firestore / firebase_auth / dio (원격 동기화/백업 시)
> 

## 4.7 Local-first 전략 / 캐싱 전략

- 모든 기본 작동은 로컬(Hive)에서 실행.
- 원격 동기화(옵션)일 경우: 로컬 우선으로 충돌 해결(타임스탬프 기준, 사용자 확인 옵션).
- 캐싱: 이미지 첨부는 로컬 파일 경로를 참조, 필요시 미리보기 썸네일 캐시.

## 4.8 확장성 고려 사항

- Repository 인터페이스를 통해 로컬/원격 구현 분리.
- 모델 버전 관리: Hive 어댑터 버전 관리로 마이그레이션 지원.
- 다국어 지원을 위한 `intl`과 리소스 분리.

## 4.9 성능/최적화 포인트

- 리스트는 `ListView.builder` + 페이징(필요시)로 렌더링.
- Hive 객체는 LazyBox 사용 고려(큰 데이터일 때).
- 이미지 첨부는 압축 및 썸네일 생성.
- Riverpod provider에서 불필요한 rebuild 최소화(ProviderScope 세분화).

---

# 5. 릴리즈 전략 & 수익 모델

## 5.1 App Store & Play Store 출시 전략

1. *MVP(로컬 전용)**로 빠르게 출시(두 스토어 동시 목표).
2. 앱명/설명: "빌린돈·빌려준돈 — 간편한 정산" (키워드: 정산, 빌린돈, 빌려준돈, IOU)
3. 심사 체크리스트:
    - 권한 설명(알림, 사진 접근) 명확히 기재
    - 개인정보 처리방침(로컬 데이터만 저장 시에도 표시)
4. A/B 테스트용 두 번째 메타데이터(아이콘/스크린샷) 준비

## 5.2 초기 마케팅 전략

- 커뮤니티(카카오/네이버 카페, Reddit, Product Hunt) 소개 게시물
- 인플루언서 마이크로 마케팅(돈 관리를 주제로 한 블로거)
- 런칭 초기에 **추천 기능**(Share 앱 링크)로 바이럴 유도
- 앱 소개 페이지(간단 웹) + 스크린샷/영상 30~45초

## 5.3 수익 모델 제안

- **프리미엄 구독 (월/년)**: 클라우드 동기화, 영수증 OCR(자동 분류), 다중 장부, CSV 자동 스케줄 백업
- **인앱 결제(일회성)**: Pro 기능 영구 잠금 해제(예: 광고 제거 + OCR 5건)
- **광고**: 무료 사용자 대상 하단 광고(주의: UX 훼손 최소화). 광고는 실험적 수익원으로 시작.
- 권장: Freemium(기본 무료) + 구독 중심 전환 전략.