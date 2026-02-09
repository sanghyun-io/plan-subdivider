---
rule_type: meta
applies_to:
  - "~/.claude/rules/*.md"
  - "프로젝트/.claude/rules/*.md"
triggers:
  - event: "rule_create"
    description: "새 규칙 파일 생성 시"
  - event: "rule_update"
    description: "기존 규칙 파일 수정 시"
---

# Rule 파일 형식 표준

규칙(Rule) 파일 작성 시 따라야 할 형식 표준입니다.

---

## 🔴 필수 행동 (Action Required)

> **MUST DO**: 규칙 파일 생성/수정 시 아래 형식을 따르세요.

### 규칙 파일 생성 시 (on-create)

| 확인 사항 | 행동 |
|----------|------|
| 파일 유형 분류 | workflow / reference / meta 중 선택 |
| Frontmatter 작성 | rule_type, applies_to, triggers 정의 |
| 연동 스킬 확인 | 관련 스킬/Agent 있으면 연동 스킬 테이블 작성 |

### 규칙 파일 수정 시 (on-update)

| 확인 사항 | 행동 |
|----------|------|
| 형식 검증 | `/rule-validator` 실행하여 형식 준수 확인 |

---

## 연동 스킬 (Linked Skills)

<!-- @linked-skills -->

| 스킬 | 트리거 조건 | 실행 방식 | 설명 |
|------|------------|:--------:|------|
| `/rule-validator` | 규칙 파일 생성/수정 시 | confirm | 형식 검증 및 변환 |

<!-- @/linked-skills -->

---

## 1. 규칙 파일 유형 (rule_type)

| 유형 | 설명 | Frontmatter 필수 | 연동 스킬 테이블 |
|------|------|:----------------:|:---------------:|
| **workflow** | 행동/절차 정의 (실행 순서 있음) | ✅ 필수 | ✅ 필수 |
| **reference** | 참조 정보 (컨벤션, 가이드) | ⚠️ 권장 | ⚠️ 선택 |
| **meta** | 규칙에 대한 규칙 | ✅ 필수 | ✅ 필수 |

### 유형별 특성

```
workflow:  "이렇게 하라" → 행동 트리거 필요
reference: "이것을 참고하라" → 정보 제공
meta:      "규칙을 이렇게 작성하라" → 메타 규칙
```

---

## 2. Frontmatter 구조

### 필수 필드

```yaml
---
rule_type: workflow | reference | meta
applies_to:
  - "적용 대상 패턴 또는 상황"
triggers:
  - event: "이벤트명"
    description: "설명"
---
```

### 필드 설명

| 필드 | 필수 | 설명 |
|------|:----:|------|
| `rule_type` | ✅ | 규칙 유형 (workflow/reference/meta) |
| `applies_to` | ✅ | 적용 대상 (파일 패턴, 상황 설명) |
| `triggers` | ⚠️ | 트리거 이벤트 (workflow/meta만 필수) |

### triggers 이벤트 예시

| 이벤트 | 설명 |
|--------|------|
| `plan_execute` | 계획 파일 실행 시 |
| `plan_created` | 계획 파일 작성 완료 시 |
| `code_commit` | 코드 커밋 전 |
| `file_create` | 파일 생성 시 |
| `file_modify` | 파일 수정 시 |
| `server_start` | 서버 시작 요청 시 |
| `test_write` | 테스트 작성 시 |
| `doc_write` | 문서 작성 시 |
| `code_review` | 코드 리뷰 시 |

---

## 3. 필수 행동 섹션

workflow/meta 유형은 반드시 포함:

```markdown
## 🔴 필수 행동 (Action Required)

> **MUST DO**: 이 규칙이 적용되는 상황에서 아래 행동을 반드시 수행하세요.

### {상황명} ({이벤트명})

| 확인 사항 | 조건 | 행동 |
|----------|------|------|
| {확인할 것} | {조건} | {수행할 행동} |
```

### 작성 규칙

- `🔴` 이모지로 시각적 강조
- `> **MUST DO**` 인용 블록으로 강제성 표시
- 테이블로 구조화하여 명확한 행동 지시

---

## 4. 연동 스킬 테이블

스킬/Agent와 연동이 필요한 경우:

```markdown
## 연동 스킬 (Linked Skills)

<!-- @linked-skills -->

| 스킬 | 트리거 조건 | 실행 방식 | 설명 |
|------|------------|:--------:|------|
| `/skill-name` | 조건 | auto/confirm/ask | 설명 |
| `agent-name` | 조건 | auto/confirm/ask | 설명 |

<!-- @/linked-skills -->
```

### 실행 방식

| 방식 | 설명 |
|------|------|
| `auto` | 조건 충족 시 자동 실행 |
| `confirm` | 조건 충족 시 사용자에게 실행 여부 확인 (권장 메시지 포함) |
| `ask` | 사용자에게 필요 여부 질문 |

### 마커 태그

```markdown
<!-- @linked-skills -->
...테이블...
<!-- @/linked-skills -->
```

- `/rule-validator`가 이 마커를 인식하여 검증
- 파싱 가능한 구조로 스킬 연동 정보 추출

---

## 5. 본문 구조

### workflow 유형

```markdown
---
(Frontmatter)
---

# 규칙 제목

설명...

---

## 🔴 필수 행동 (Action Required)
(필수)

---

## 연동 스킬 (Linked Skills)
(필수)

---

## 상세 내용
...

---

*관련 파일/문서*: ...
*마지막 수정*: YYYY-MM-DD
```

### reference 유형

```markdown
---
(Frontmatter - 선택)
---

# 규칙 제목

설명...

---

## 내용 섹션들
...

---

## 연동 스킬 (Linked Skills)
(선택 - 검증 Agent 있으면 추가)

---

*관련 파일/문서*: ...
```

---

## 6. 예시

### workflow 예시 (environment-setup.md)

```yaml
---
rule_type: workflow
applies_to:
  - "서버 시작/종료"
  - "개발 환경 설정"
triggers:
  - event: "server_start"
    description: "서버 시작 요청 시"
---
```

### reference 예시 (naming-conventions.md)

```yaml
---
rule_type: reference
applies_to:
  - "*.kt 파일 생성"
  - "클래스/메서드 네이밍"
---
```

---

## 7. 검증 체크리스트

규칙 파일 작성/수정 시 확인:

- [ ] Frontmatter 포함 (workflow/meta는 필수)
- [ ] rule_type 명시
- [ ] applies_to 명시
- [ ] triggers 명시 (workflow/meta)
- [ ] 필수 행동 섹션 포함 (workflow/meta)
- [ ] 연동 스킬 테이블 포함 (스킬 연동 시)
- [ ] `<!-- @linked-skills -->` 마커 사용

---

*이 규칙은 모든 규칙 파일 작성 시 참조됩니다.*
*마지막 수정: 2026-02-05*
