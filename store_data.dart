// lib/data/store_data.dart

import 'package:flutter/material.dart';

// 가게 정보를 담을 클래스
class Store {
  final String name; // 가게 이름
  final String category; // 한식, 양식, 중식/일식, 분식, 패스트푸드, 술집, 카페
  final List<String> themes; // 매콤, 달달, 시원, 든든
  final List<String> situations; // 혼자, 커플, 친구들, 회식
  final String imagePath; // 가게 이미지 경로 (assets 폴더 사용)
  final double lat; // 위도 (명학역/성결대 주변)
  final double lng; // 경도 (명학역/성결대 주변)

  // MyPage의 '최근 본' 기능을 위해 추가된 필드 (앱 실행 중에만 기록 유지)
  final DateTime? lastViewed;

  Store({
    required this.name,
    required this.category,
    required this.themes,
    required this.situations,
    this.imagePath = 'assets/food_placeholder.png', // 기본 더미 이미지 경로
    // 성결대(37.388, 126.950) 및 명학역(37.387, 126.953) 근처의 위도/경도 예시
    this.lat = 37.388,
    this.lng = 126.950,
    this.lastViewed, // 기본값은 null
  });
}

// ----------------------------------------------------
// 1. 성결대/명학역 주변 가게 데이터 목록 (하드코딩)
// ----------------------------------------------------
final List<Store> allStores = [
  // --- 한식 ---
  Store(
    name: '뜨끈한 김치찌개 명학점',
    category: '한식',
    themes: ['매콤', '든든'],
    situations: ['혼자', '친구들', '회식'],
    lat: 37.3875,
    lng: 126.9520, // 명학역 근처
  ),
  Store(
    name: '성결대 앞 분식집',
    category: '분식',
    themes: ['매콤', '달달'],
    situations: ['혼자', '친구들'],
    lat: 37.3890,
    lng: 126.9505, // 성결대 근처
  ),
  Store(
    name: '전주식 비빔밥집',
    category: '한식',
    themes: ['든든', '시원'],
    situations: ['혼자', '커플'],
    lat: 37.3870,
    lng: 126.9515,
  ),

  // --- 양식/카페 ---
  Store(
    name: '로제 파스타와 스테이크',
    category: '양식',
    themes: ['달달'],
    situations: ['커플', '친구들'],
    lat: 37.3882,
    lng: 126.9490, // 성결대 후문 쪽
  ),
  Store(
    name: '명학역 브런치 카페',
    category: '카페',
    themes: ['달달', '시원'],
    situations: ['혼자', '커플', '친구들'],
    lat: 37.3865,
    lng: 126.9530,
  ),

  // --- 중식/일식 ---
  Store(
    name: '마라탕 & 꿔바로우',
    category: '중식/일식',
    themes: ['매콤', '든든'],
    situations: ['친구들', '회식'],
    lat: 37.3895,
    lng: 126.9485,
  ),
  Store(
    name: '혼밥 스시집',
    category: '중식/일식',
    themes: ['시원', '든든'],
    situations: ['혼자', '커플'],
    lat: 37.3878,
    lng: 126.9510,
  ),

  // --- 패스트푸드/술집 ---
  Store(
    name: '24시 수제 버거',
    category: '패스트푸드',
    themes: ['든든'],
    situations: ['혼자', '친구들'],
    lat: 37.3860,
    lng: 126.9540, // 명학역 앞
  ),
  Store(
    name: '분위기 좋은 맥주집',
    category: '술집',
    themes: ['시원', '든든'],
    situations: ['친구들', '회식'],
    lat: 37.3888,
    lng: 126.9525,
  ),
];

// ----------------------------------------------------
// 2. '최근 본' 관리 로직 (MyPage 기능 연동)
// ----------------------------------------------------

// 현재 앱에서 "최근 본" 목록을 관리할 리스트 (앱 실행 중 메모리에만 존재)
List<Store> recentlyViewedStores = [];

/// 특정 가게를 '최근 본' 목록에 추가하고 관리하는 함수
/// 이 함수는 홈 화면이나 상세 페이지에서 가게를 클릭할 때마다 호출됩니다.
void markStoreAsViewed(Store store) {
  // 1. 기존 리스트에서 동일한 이름의 가게가 있다면 제거 (중복 방지 및 최신 순서 유지)
  recentlyViewedStores.removeWhere((s) => s.name == store.name);

  // 2. 기존 가게 정보를 복사하되, 'lastViewed' 시각만 현재 시각으로 업데이트
  final newStore = Store(
    name: store.name,
    category: store.category,
    themes: store.themes,
    situations: store.situations,
    imagePath: store.imagePath,
    lat: store.lat,
    lng: store.lng,
    lastViewed: DateTime.now(), // 현재 시각을 기록
  );

  // 3. 리스트 맨 앞에 추가 (가장 최근에 본 것이므로)
  recentlyViewedStores.insert(0, newStore);

  // 4. 최대 10개까지만 유지 (목록이 너무 길어지는 것을 방지)
  if (recentlyViewedStores.length > 10) {
    recentlyViewedStores.removeLast();
  }

  // print('최근 본 가게 업데이트: ${newStore.name} - ${newStore.lastViewed}');
}
