# Clean-Architecture-iOS(Movie App)

<img width="793" alt="img" src="https://github.com/user-attachments/assets/d03fe6a4-9d27-4a11-b3fe-7104d718a9c5" />

- `Presentation Layer`: Coordinator, ViewModel, View
- `Domain Layer`: Entity, Usecase, Repository Protocol(For DI)
- `Data Layer`: Repository Implementation, API + DB(ex: Network, Service, DTO...)

<br/>

## Clean-Architecture-flow
![1_W8a8Ucovca5ve1Y8COhBkQ](https://github.com/user-attachments/assets/3a85309c-55b5-4fd7-9c63-b73213d993d1)

### 메인 화면 (MovieListViewController) 흐름
1. 사용자가 MovieListViewController에 진입하면 viewDidLoad가 호출됨
2. MovieListViewController는 viewDidLoadEvent를 통해 ViewModel에게 데이터 요청을 전달
  -viewModel.transform(input:)을 통해 데이터 로드 시작
3. MovieListViewModel은 MovieListUseCase에게 영화 데이터 요청
  -Popular, NowPlaying, TopRated, Upcoming 카테고리 별 데이터 요청
4. MovieListUseCase는 MovieRepository를 통해 각 카테고리별 영화 데이터를 가져오는 비즈니스 로직 수행
5. MovieRepository는 MovieService에게 외부 API 요청을 전달
6. MovieService는 TMDb API를 호출하여 MovieDTO 형태로 데이터 수신
7. MovieRepository는 MovieDTO를 Domain Entity인 Movie로 변환
8. MovieListViewModel은 받아온 데이터를 각 카테고리별 BehaviorRelay에 할당
  -RxSwift를 통해 데이터 스트림 관리
9. MovieListViewController는 바인딩된 데이터를 감지하고 CollectionView를 업데이트

### 영화 상세 화면(MovieDetailViewController) 흐름
1. 사용자가 영화 셀을 선택
2. MovieListViewController는 선택된 Movie 객체를 Coordinator에게 전달
3. MovieListCoordinator는 MovieDetailViewController 생성 및 화면 전환 수행
   -MovieDetailViewModel 생성 및 선택된 Movie 데이터 전달
4. MovieDetailViewController는 전달받은 데이터를 화면에 표시(Binding)

<div style="display: flex; justify-content: space-between;">
    <img src="https://github.com/user-attachments/assets/2a48ae49-14b8-4e3c-9383-4eb6dc34d74c" width="45%">
    <img src="https://github.com/user-attachments/assets/9ddcb45b-2e8c-46a2-9e13-ce1ba06b8cd9" width="45%">
</div>
