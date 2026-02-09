---
rule_type: workflow
applies_to:
  - "~/.claude/plans/*.md"
  - "계획 파일 작성"
  - "계획 실행"
triggers:
  - event: "plan_execute"
    description: "계획 파일 실행 시작 시 - Pre-work 먼저 수행 후 구현"
  - event: "plan_created"
    description: "계획 파일 작성 완료 시"
---

# Plan Structure Rules

계획(Plan) 작성 시 따라야 할 구조화 규칙입니다.

---

## 🔴 필수 행동 (Action Required)

> **MUST DO**: 이 규칙이 적용되는 상황에서 아래 행동을 반드시 수행하세요.

### Plan 실행 시 첫 번째 작업 (Pre-work)

> ⛔ 사용자가 "시작"을 선택하면, **코드를 읽거나 구현하기 전에** 반드시 아래를 먼저 수행:

| 순서 | 확인 사항 | 조건 | 행동 |
|:----:|----------|------|------|
| 1 | Task 개수 확인 | Task ≥ 3개 | `/subdivide` 실행 여부를 **AskUserQuestion으로** 확인 |
| 2 | 복잡도 확인 | 다중 파일 수정 | `/review` 실행 여부를 **AskUserQuestion으로** 확인 |
| 3 | Pre-work 완료 | - | 그 다음에 실제 구현 시작 |

#### ✅ AskUserQuestion 사용 (필수)

> **CRITICAL**: 사용자에게 확인을 받아야 하는 **모든 상황**에서 일반 텍스트 대신 **반드시 AskUserQuestion 도구를 사용**해야 합니다.

##### 적용 범위

**AskUserQuestion 사용이 필수인 경우**:
1. **Pre-work 확인**: Plan 실행 전 `/subdivide`, `/review` 실행 여부
2. **스킬 내부 확인**: `/subdivide` 실행 중 세분화 계획 승인, 완료 후 다음 단계 선택
3. **작업 진행 확인**: 다중 선택지가 있는 모든 의사결정 시점
4. **위험한 작업**: 파일 삭제, 덮어쓰기 등 되돌릴 수 없는 작업 전

##### Pre-work 확인 예시

```json
{
  "questions": [{
    "question": "Plan 실행 전 Pre-work를 진행하시겠습니까?",
    "header": "Pre-work",
    "multiSelect": false,
    "options": [
      {"label": "스킵하고 바로 시작", "description": "Pre-work 없이 구현 시작"},
      {"label": "/subdivide 실행", "description": "계획을 세부 파일로 분리"},
      {"label": "/review 실행", "description": "Momus로 계획 검토"}
    ]
  }]
}
```

##### 스킬 내부 확인 예시

`/subdivide` 스킬에서 세분화 계획 승인:
```json
{
  "questions": [{
    "question": "이대로 세분화를 진행하시겠습니까?",
    "header": "세분화 확인",
    "multiSelect": false,
    "options": [
      {"label": "진행", "description": "세분화 계획대로 파일 생성"},
      {"label": "수정 필요", "description": "계획을 다시 검토하고 수정"},
      {"label": "취소", "description": "세분화 작업 중단"}
    ]
  }]
}
```

##### 금지 사항

- ❌ 텍스트로 물어보기: "subdivide 실행할까요?", "이대로 진행할까요?", "작업을 시작하시겠습니까?"
- ❌ 선택지 없이 지시만 하기: "다음 명령어로 작업을 시작하세요"
- ✅ **모든 확인**에 AskUserQuestion 도구 사용 필수

#### ⛔ Plan 재검색 금지

- 현재 대화 컨텍스트에 Plan 내용이 **이미 있으면** 다시 검색/읽기 금지
- ExitPlanMode 후 구현 시작 시, 컨텍스트의 Plan 정보 활용
- 새 세션에서 Plan 실행 요청 시에만 Plan 파일 읽기

### ⛔ 금지 사항

- Pre-work 없이 코드 읽기/구현 시작 금지
- 새 세션에서 계획 실행 요청 시에도 Pre-work를 먼저 수행
- Plan 파일을 읽자마자 바로 구현 들어가는 것 금지
- **Claude가 자체 판단으로 `/subdivide`, `/review` 스킵 결정 금지**
  - "이미 상세함", "명확히 구분됨", "구조화 되어있음" 등의 이유로 스킵 불가
  - 조건 충족 시 **반드시** 사용자에게 실행 여부를 **질문**해야 함
  - 사용자가 "아니오"라고 답해야만 스킵 가능

---

## 연동 스킬 (Linked Skills)

<!-- @linked-skills: 이 테이블의 스킬은 조건 충족 시 자동으로 제안되어야 합니다 -->

| 스킬 | 트리거 조건 | 실행 방식 | 설명 |
|------|------------|:--------:|------|
| `/subdivide` | Task ≥ 3개 AND Plan 실행 시작 시 (Pre-work) | confirm | 계획을 세부 파일로 분리 |
| `/review` | 다중 파일 수정 AND Plan 실행 시작 시 (Pre-work) | confirm | Momus로 계획 검토 |
| `/plan` | 새 계획 필요 시 | auto | Prometheus로 계획 작성 |

**실행 방식 설명**:
- `auto`: 조건 충족 시 자동 실행
- `confirm`: 조건 충족 시 **반드시** 사용자에게 실행 여부 질문 (Claude가 임의로 스킵 판단 금지)
- `ask`: 사용자에게 필요 여부 질문

**⚠️ `confirm` 주의사항**:
- Claude는 "이미 충분히 상세함", "Task별로 구분됨" 등의 이유로 스킵을 **자체 결정할 수 없음**
- 조건(Task ≥ 3개)이 충족되면 **무조건 사용자에게 질문**해야 함
- 사용자가 명시적으로 "스킵", "아니오", "필요없음" 등 답변 시에만 스킵 가능

**⛔ 중요**: `/subdivide`와 `/review`는 Plan 실행의 **첫 번째 작업(Pre-work)**으로, 코드를 읽거나 구현하기 전에 확인해야 합니다.

<!-- @/linked-skills -->

---

## 적용 시점

- Plan 모드에서 계획 작성 시
- `/plan`, `/prometheus` 실행 시
- 복잡한 작업 계획 수립 시

---

## 메인 계획 파일 구조

메인 계획 파일은 다음 구조를 따릅니다:

```markdown
# {계획 제목}

> **작성일**: YYYY-MM-DD
> **목적**: {계획의 목적 한 줄 설명}

---

## 실행 계획 목차 (Implementation Tasks)

이 계획서는 N개의 세부 작업으로 분리되었습니다. 순서대로 실행하세요.

| 순서 | 작업명 | 파일 | 설명 |
|:----:|--------|------|------|
| 1 | **작업1** | [01-task-name.md](./plan-name/01-task-name.md) | 작업 설명 |
| 2 | **작업2** | [02-task-name.md](./plan-name/02-task-name.md) | 작업 설명 |
| ... | ... | ... | ... |

### 작업 규칙

1. **순차 실행**: Task 01부터 순서대로 진행
2. **체크리스트**: 각 작업의 모든 항목을 체크 후 다음으로 이동
3. **Lint 검사**: 각 작업 완료 시 코드 검증 실행
4. **링크 확인**: 작업 파일 하단의 "다음 작업" 링크로 이동

---

## 핵심 내용

{계획의 핵심 내용...}
```

---

## 세부 계획 파일 구조

각 세부 작업 파일은 다음 구조를 따릅니다:

```markdown
# Task {순서}: {작업명}

> **순서**: {현재}/{전체}
> **이전 작업**: [{이전 작업명}](./{이전 파일}) 또는 (없음 - 시작 작업)
> **다음 작업**: [{다음 작업명}](./{다음 파일}) 또는 (없음 - 마지막 작업)
> **참조**: 원본 계획서 {섹션 참조}

---

## 목표

{이 작업의 목표 설명}

---

## Checklist

### 1. {첫 번째 단계}

- [ ] {세부 작업 1}
- [ ] {세부 작업 2}
  - 코드 예시나 상세 설명 포함 가능

### 2. {두 번째 단계}

- [ ] {세부 작업 3}
- [ ] {세부 작업 4}

---

## 완료 조건

1. 모든 Checklist 항목 체크 완료
2. 빌드 성공 (해당 시)
3. 테스트 통과 (해당 시)

---

## 검증 명령어

작업 완료 후 아래 명령어 실행:

\`\`\`bash
{프로젝트에 맞는 검증 명령어}
\`\`\`

---

## 다음 작업 안내

검증 통과 후, 다음 작업으로 이동:

**[Task {다음 순서}: {다음 작업명}](./{다음 파일})**

다음 작업에서는:
- {다음 작업 요약 1}
- {다음 작업 요약 2}

---

*생성일: YYYY-MM-DD*
```

---

## 세분화 기준

계획을 세부 작업으로 분리하는 기준:

### 분리해야 할 경우

1. **독립적인 결과물**: 각 작업이 독립적으로 완료 가능
2. **논리적 단계**: 순차적으로 진행해야 하는 단계
3. **다른 영역**: 서로 다른 코드/파일 영역
4. **검증 가능**: 각 작업 완료 후 검증 가능

### 분리 예시

| 작업 유형 | 분리 단위 |
|----------|----------|
| 엔티티 추가 | Domain → Repository → Service → Controller |
| API 개발 | 엔드포인트별 또는 기능별 |
| 리팩토링 | 모듈별 또는 계층별 |
| 마이그레이션 | 단계별 (준비 → 실행 → 검증 → 정리) |

---

## 파일 네이밍 규칙

### 메인 계획

- 위치: `~/.claude/plans/{plan-name}.md`
- 네이밍: Claude가 자동 생성하는 이름 사용

### 세부 계획 폴더

- 위치: `~/.claude/plans/{plan-name}/`
- 파일: `{순서2자리}-{작업명-kebab-case}.md`

### 예시

```
~/.claude/plans/
├── jaunty-greeting-puffin.md           # 메인 계획
└── jaunty-greeting-puffin/             # 세부 계획 폴더
    ├── 01-campaign-response-entity.md
    ├── 02-evaluation-result-entity.md
    ├── 03-audit-log-enhancement.md
    ├── 04-service-expansion.md
    ├── 05-api-migration.md
    └── 06-submission-removal.md
```

---

## 체크리스트 작성 규칙

### 좋은 체크리스트

- [ ] **구체적**: 무엇을 해야 하는지 명확
- [ ] **검증 가능**: 완료 여부 판단 가능
- [ ] **독립적**: 다른 항목과 중복되지 않음
- [ ] **순서 고려**: 의존성 있으면 순서대로 배치

### 코드 예시 포함

체크리스트 항목에 코드 예시가 필요하면 들여쓰기로 포함:

```markdown
- [ ] `UserService.kt` 생성
  ```kotlin
  interface UserService {
      fun getUser(id: Long): User
  }
  ```
```

---

*이 규칙은 Plan 모드, Prometheus, 기타 계획 작성 에이전트에서 자동으로 참조됩니다.*
*마지막 수정: 2026-02-05*
