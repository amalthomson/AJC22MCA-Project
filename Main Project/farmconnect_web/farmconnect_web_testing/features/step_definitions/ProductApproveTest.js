const { Given, When, Then } = require('cucumber');
const assert = require('assert');
const { Builder, By, Key, until } = require('selenium-webdriver');
const GREEN = '\x1b[32m';
const RESET = '\x1b[0m';
console.log("Scenario: Approve Product");
console.log("");
Given('I am logged in to the admin dashboard', async function () {
    this.driver = await new Builder().forBrowser('chrome').build();
    await this.driver.get('http://localhost:3000/admin_dashboard');
    console.log(`${GREEN}✔ Admin Logged in to the Admin Dashboard Successfully${RESET}`);
});
When('I navigate to the product approval page', async function () {
    await this.driver.findElement(By.id('product_approval_link')).click();
    console.log(`${GREEN}✔ Navigate to the Product Approval Page${RESET}`);
});
When('I select a product to approve', async function () {
    await this.driver.findElement(By.className('product_checkbox')).click();
    console.log(`${GREEN}✔ Successfully Select a Product to Approve${RESET}`);
});
When('I click on the approve button', async function () {
    await this.driver.findElement(By.id('approve_button')).click();
    console.log(`${GREEN}✔ Click on the Approve Button Success${RESET}`);
});
Then('the product should be approved and made available for users', async function () {
    const productStatus = await this.driver.findElement(By.id('product_status')).getText();
    assert.strictEqual(productStatus, 'Approved');
    console.log(`${GREEN}✔ Then the Product is Approved and made Available for Users${RESET}`);
    console.log(`${GREEN}Product Approval Test Passed!${RESET}`);
});
After(async function () {
    if (this.driver) {
        await this.driver.quit();
    }
});


