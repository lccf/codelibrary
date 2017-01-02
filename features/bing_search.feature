Feature: 必应搜索
  Scenario: 搜索cucumber
    Given 我访问 "https://www.bing.com"
    When 我输入 "cucumber"
    And 我点击搜索
    Then 页面标题中应包含 "cucumber"