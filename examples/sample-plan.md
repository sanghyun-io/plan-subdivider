# User Authentication System Implementation

> **작성일**: 2026-02-09
> **목적**: JWT 기반 사용자 인증 시스템 구현

---

## 실행 계획 목차 (Implementation Tasks)

이 계획서는 5개의 세부 작업으로 분리되었습니다. 순서대로 실행하세요.

| 순서 | 작업명 | 파일 | 설명 |
|:----:|--------|------|------|
| 1 | **User 엔티티 생성** | [01-user-entity.md](./user-authentication/01-user-entity.md) | User 도메인 모델 및 데이터베이스 스키마 정의 |
| 2 | **UserRepository 구현** | [02-user-repository.md](./user-authentication/02-user-repository.md) | 사용자 데이터 접근 계층 구현 |
| 3 | **AuthService 구현** | [03-auth-service.md](./user-authentication/03-auth-service.md) | JWT 토큰 생성/검증 및 인증 로직 |
| 4 | **AuthController API** | [04-auth-controller.md](./user-authentication/04-auth-controller.md) | 로그인/회원가입 REST API 엔드포인트 |
| 5 | **통합 테스트** | [05-integration-tests.md](./user-authentication/05-integration-tests.md) | 전체 인증 플로우 통합 테스트 |

### 작업 규칙

1. **순차 실행**: Task 01부터 순서대로 진행
2. **체크리스트**: 각 작업의 모든 항목을 체크 후 다음으로 이동
3. **Lint 검사**: 각 작업 완료 시 코드 검증 실행
4. **링크 확인**: 작업 파일 하단의 "다음 작업" 링크로 이동

---

## 핵심 내용

### 목표

Spring Boot 기반 웹 애플리케이션에 JWT(JSON Web Token)를 사용한 사용자 인증 시스템을 구현합니다.

### 주요 기능

1. **사용자 등록 (회원가입)**
   - 이메일, 비밀번호 기반 계정 생성
   - 비밀번호 암호화 (BCrypt)
   - 중복 이메일 검증

2. **로그인**
   - 이메일/비밀번호 인증
   - JWT 액세스 토큰 발급
   - 리프레시 토큰 발급 (선택)

3. **인증된 요청 처리**
   - JWT 토큰 검증 미들웨어
   - 사용자 정보 추출
   - 권한 기반 접근 제어 (RBAC) 준비

### 기술 스택

- **프레임워크**: Spring Boot 3.x
- **보안**: Spring Security
- **JWT**: jjwt (JSON Web Token library)
- **데이터베이스**: JPA/Hibernate with PostgreSQL
- **비밀번호 암호화**: BCrypt
- **테스트**: JUnit 5, MockMvc

### 아키텍처

```
┌─────────────────┐
│   Controller    │  ← REST API 엔드포인트
└────────┬────────┘
         │
┌────────▼────────┐
│    Service      │  ← 비즈니스 로직 (JWT 생성/검증)
└────────┬────────┘
         │
┌────────▼────────┐
│   Repository    │  ← 데이터 접근 계층
└────────┬────────┘
         │
┌────────▼────────┐
│     Entity      │  ← 도메인 모델
└─────────────────┘
```

### 보안 고려사항

1. **비밀번호 저장**: BCrypt 해싱 사용
2. **토큰 만료**: 액세스 토큰 15분, 리프레시 토큰 7일
3. **HTTPS**: 프로덕션 환경에서 필수
4. **비밀키 관리**: 환경 변수로 JWT 서명 키 관리
5. **입력 검증**: 이메일 형식, 비밀번호 강도 검증

---

## 상세 구현 단계

### 1. User 엔티티 생성 (Task 01)

- User 클래스 정의
- 필드: id, email, password, roles, createdAt
- JPA 어노테이션 적용
- 데이터베이스 마이그레이션 스크립트

### 2. UserRepository 구현 (Task 02)

- JpaRepository 상속
- findByEmail 메서드 정의
- 중복 이메일 검증 메서드

### 3. AuthService 구현 (Task 03)

- 회원가입 로직
- 로그인 검증
- JWT 토큰 생성
- JWT 토큰 파싱/검증
- BCrypt 비밀번호 암호화

### 4. AuthController API (Task 04)

- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/refresh (선택)
- 요청/응답 DTO 정의
- 예외 처리

### 5. 통합 테스트 (Task 05)

- 회원가입 플로우 테스트
- 로그인 플로우 테스트
- 인증 필요 엔드포인트 테스트
- 토큰 만료 시나리오 테스트

---

## 완료 조건

- [ ] 모든 세부 작업(01-05) 체크리스트 완료
- [ ] 빌드 성공: `./gradlew build`
- [ ] 전체 테스트 통과: `./gradlew test`
- [ ] Lint 검사 통과: `./gradlew ktlintCheck`
- [ ] API 문서 작성 (Swagger/OpenAPI)
- [ ] 코드 리뷰 완료

---

## 참고 자료

- [Spring Security Documentation](https://docs.spring.io/spring-security/reference/index.html)
- [JWT.io](https://jwt.io/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

---

*생성일: 2026-02-09*
*이 파일은 `/subdivide` 실행 시 자동으로 세부 작업으로 분리됩니다.*
