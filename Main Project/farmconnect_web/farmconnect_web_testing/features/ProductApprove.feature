Feature: Product Approval Test
  As an admin
  I want to approve products
  So that they can be made available for users

  Scenario: Approve Product
    Given I am logged in to the admin dashboard
    When I navigate to the product approval page
    And I select a product to approve
    And I click on the approve button
    Then the product should be approved and made available for users
