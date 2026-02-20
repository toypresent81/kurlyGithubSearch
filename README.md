# KurlyGithubSearch

iOS용 GitHub 저장소 검색 사전과제입니다.  

---

## 프로젝트 목표

- GitHub 저장소 검색 기능 구현
- 문제 정의, 아키텍처 설계, 데이터 구조, 알고리즘, 코드 품질, UX 종합 평가

---

## 주요 기능

### 검색 화면

- 검색어 입력 후, GitHub 저장소 검색 결과 표시
- 검색어가 비어있을 경우, 최근 검색어 최대 10개 표시
- 최근 검색어는 날짜 기준 내림차순 정렬
- 최근 검색어 개별 삭제 및 전체 삭제 가능
- 최근 검색어는 앱 재시작 후에도 유지
- 최근 검색어 선택 시 해당 키워드로 검색 결과 표시

**추가 구현**  
- 자동완성 기능: 입력 중인 검색어 기반으로 최근 검색어 자동완성
- 자동완성 시 검색 날짜 표시

### 검색 결과 화면

- 검색 결과를 List 형태로 표시
- 총 검색 결과 수 표시
- 저장소 정보 표시
  - Thumbnail: owner.avatar_url
  - Title: name
  - Description: owner.login
- 검색 결과 선택 시 WebView를 통해 GitHub 저장소 이동

**추가 구현**  
- 스크롤 중간에 다음 페이지 자동 호출
- 페이지 로딩 중 로딩 상태 표시

---

## 프로젝트 구조

```text
App
 ├─ AppDelegate
 ├─ DIContainer (optional)
 ├─ Resources
 │   ├─ Assets
 │   ├─ Extensions
 │   └─ Constants
 │       └─ API

Feature
 ├─ Splash
 │   └─ SplashViewController
 ├─ Search
 │   ├─ View
 │   │   ├─ SearchViewController
 │   │   ├─ SearchListTableView
 │   │   └─ SearchListCell
 │   ├─ Reactor
 │   │   ├─ SearchReactor.swift
 │   │   ├─ SearchReactor+Action.swift
 │   │   ├─ SearchReactor+Mutation.swift
 │   │   └─ SearchReactor+Pagination.swift
 │   ├─ Model
 │   │   └─ SearchResultModel
 │   └─ Section
 │       └─ SearchSection

Models
 ├─ Entity
 │   └─ SearchRecentEntity
 ├─ UseCase
 │   └─ SearchRecentUseCase

Data
 ├─ CoreData
 │   ├─ CoreDataManager
 │   └─ SearchLocalRepository  (Protocol + 구현체 상단 정의)
 ├─ Network
 │   ├─ NetworkManager
 │   ├─ Services
 │   │   └─ SearchService
 │   └─ Response
 │       └─ SearchResultResponse
```

---

## 사용 기술

- Swift, UIKit
- ReactorKit
- CoreData
- NetworkManager
- SnapKit (UI 레이아웃)
- WebKit (WebView)
