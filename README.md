# daumImageSearchAPI

## 카카오 'Daum 검색 - 이미지 검색' api를 사용한 이미지 검색 앱
- RxSwift, Alamofire, Kingfisher 사용 (cocoapods 이용)
- 소스 다운 후 "pod install" 실행 필요
- API 통신
  - timeoutInterval 5초, 타임아웃으로 실패시 3회 retry하도록 함
  - 3회 실패시 팝업으로 에러메시지 표시하도록 함
- Image 처리
  - 검색 결과 목록에서는 thumbnail 로드, 상세보기에서는 실제 이미지 로드
  - 검색 결과 목록에서 이미지 로드 실패시 실패이미지 표시함
  - 상세보기에서 이미지 로드 실패시 에러메시지 팝업 표시 후 확인버튼 눌리면 검색 결과 목록으로 이동
  - TEST
    - Unit Test : "브랜디" 검색어 입력 후 API 통신 완료 테스트
    - UI Test : UITest의 testExample() 실행시 기본적인 요구사항 확인 하시는데 편할듯합니다.
      - workflow : 검색어 입력 -> 상세보기 -> 상세보기닫기 -> 스크롤 -> 검색결과가 없는 검색어 입력  
