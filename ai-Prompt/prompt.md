# AI 프롬프트 기록 - 컬리 사전과제

## 과제명
검색 화면 구현

## AI 프롬프트

1. 
당신은 iOS 개발자이고, 현재 이직을 위한 사전과제를 하려고 해
사전과제는 Reactorkit을 사용해서 설계를 할거고
다음과 같은 폴더 구조를 가지고 과제를 진행하려고 하는데 수정할 내용이나 개선할 부분 있으면 알려줘

App
- AppDelegate
- Resources
    -  Assets
- Extensions
- Constants
     -  API

Pages
- Search
    - View
        - SearchViewController
        - SearchListTableView
        - SearchListCell
     - Reactor
        - SearchReactor
    - Model
        -  SearchResultModel
    - Section
        - SearchSection
- Splash
    - SplashViewController

Modules
- CoreData
    - CoreDataManager
    - SearchLocalRepository
- Network
    - NetworkManager
    - Services
        - SearchService
    - Response
        - SearchResultResponse

1.1
Presentation, Data 폴더네임 부분이 어색해. 그러한 이름을 적용한 이유를 알려줘. 
Data를 Helpers로 변경하는건 어떻게 생각해? 

2. 
그동안 Clean 아키텍처를 사용하지 않았고 꼭 고수할 필요는 없다고 생각해. 그리고 Clean 아키텍처를 딱 맞게 적용할 수는 없으니 관련된 내용은 제거해도 될 거 같아. 내가 사용하던 구조 방식으로 적용하려고 하는데 어떻게 생각해?

3. 
위 구조를 바탕으로 github에 작성할 README 초안을 잡아봤어. 수정할 부분이나 추가할 부분, 개선할 사항이 있을까?

## KurlyGithubSearch

## 프로젝트 목표

- GitHub 저장소 검색 기능 구현

## 주요 기능

### 검색 화면

- 검색어 입력 후, 검색 결과를 보여줍니다.
- 검색어가 비어있을 시, 최근 검색어를 최대 10개까지 보여줍니다.
- 최근 검색어는 날짜 기준으로 내림차순 정렬합니다.
- 최근 검색어 ‘삭제’ 또는 ‘전체 삭제’가 가능합니다.
- 최근 검색 내역은 앱 재시작 시에도 유지됩니다.
- 최근 검색어 선택 시, 검색 결과를 보여줍니다.

**추가 구현**  
- 검색어 입력 시, 자동완성을 보여줍니다.
- 자동완성 노출 시, 검색 날짜를 같이 보여줍니다.
- 자동완성은 최근 검색어에서 추출하여 사용합니다.

### 검색 결과 화면

- 검색 결과를 List 형태로 보여줍니다.
- 총 검색 결과 수를 보여줍니다.
- 저장소 정보를 보여줍니다.
  - Thumbnail: owner.avatar_url
  - Title: name
  - Description: owner.login
- 검색 결과 선택 시, WebView 를 통해 해당 저장소로 이동합니다.

**추가 구현**  
- Scroll 중간에 Next Page 를 미리 호출합니다.
- Next Page 를 로딩할 때, 로딩 상태를 보여줍니다.

## 프로젝트 구조

App
 ├─ AppDelegate
 ├─ Resources
 │   ├─ Assets
 ├─ Extensions
 ├─ Constants
 │   └─ API

Feature
 ├─ Search
 │   ├─ View
 │   │   ├─ SearchViewController
 │   │   ├─ SearchListTableView
 │   │   └─ SearchListCell
 │   ├─ Reactor
 │   │   └─ SearchReactor.swift
 │   ├─ Model
 │   │   └─ SearchResultModel
 │   └─ Section
 │       └─ SearchSection
 ├─ Splash
 │   └─ SplashViewController

Models
 ├─ Entity
 │   └─ SearchRecentEntity

Data
 ├─ CoreData
 │   ├─ CoreDataManager
 │   └─ SearchLocalRepository
 ├─ Network
 │   ├─ NetworkManager
 │   ├─ Services
 │   │   └─ SearchService
 │   └─ Response
 │       └─ SearchResultResponse

4.
예시 이미지와 같이 SearchViewController 에 LargeTitle 을 적용하려고 하는데
iOS 26에서는 LargeTitle이 한번 스크롤되서 사라진 이후 안보이는 이슈가 있어. 혹시 변경된 내용이 있는지 웹페이지들 검색해줘

4.1
공유해준 코드로는 여전히 동일한 증상이 나오고 있어. 내 생각엔 네비바 부분의 컬러값이 문제인거 같은데. 
https://stackoverflow.com/questions/79778204/navigation-item-title-hidden-when-using-large-title-in-ios26
여기서도 동일한 현상이 있다는 내용이 있는데 관련된 코드 수정하고 싶어
iOS 26이상과 그 이하버전에서 분기처리로 대응하려고 해

5.
Alamofire 를 기반으로 NetworkManager 를 작성하려고 해
다음의 예시 코드를 이 사전과제에 사용하려고 하는데 어떻게 생각해? 개선할 부분이나 수정할 부분있으면 알려줘

5.1
공유해준 코드에서는 Single 을 사용하고 있는데 Observable 을 사용하면 안될까? Observable 을 사용하는게 더 익숙하고 그렇게 사용해왔었어. 왜 Single을 써야하는지, 차이점이 있다면 알려줘

6.
다음 이미지를 바탕으로 컬러 동일하게 둥근 X버튼을 만들고 싶어. 사이즈 20으로 만들어줘

7.
Github 검색 API를 사용하고 있는데 pageination을 몇 번 진행하고 나면 더 이상 안되는데 이유를 알 수 있을까?

7.1
그러한 이유라면 현재 이러한 상황에서 수정할 수 있는 방법이나 개선할 수 있는 방법이 있을까?

8.
다음에 대하여 같이 고민하고 싶어
1.최근검색리스트에서 저장된 검색어가 있을 시 검색어를 탭하여 결과화면으로 진입
2.결과화면에는 서치바에 검색어 노출되고 클리어버튼 노출된 상태
3.클리어버튼 클릭시 라지타이틀 사라지고 우측에 취소이 나타나고 결과화면은 그대로 존재하는 상황

UX 친화적으로 생각해보면 클리어버튼 이벤트시 최근검색리스트가 보이는게 맞는거 같은데 어떻게 생각해? 맞다면 어느부분을 개선하면 될까?

9. 
if let window = UIApplication.shared.windows.first {
이 부분 warning 뜨는거 내장 AI 사용

10. 
결과 리스트 중에 Placeholder 이미지를 시스템 이미지로 적용하려고 하는데 검색리스트랑 어울리는 이미지로 추천해줘

11
SearchViewReactor 에 관련된 코드인데
가독성과 유지보수 생각해서 코드를 개선할 부분이 있을까?

