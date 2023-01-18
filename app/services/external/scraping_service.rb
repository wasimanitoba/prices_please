class External::ScrapingService
  Selenium::WebDriver::Chrome::Service.driver_path = "/usr/bin/chromedriver"

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')

  @@wait = Selenium::WebDriver::Wait.new(:timeout => 20)
  @@driver = Selenium::WebDriver.for :chrome, options: options

  def self.document_initialised
    @@driver.find_element(css: 'ul.product-tile-group__list')
  end

  def self.crawl!

    begin
      @@driver.get("https://www.realcanadiansuperstore.ca/food/fruits-vegetables/c/28000")

      @@wait.until { document_initialised }

      @@driver.save_screenshot('public/images/summary.png')
      @@driver.find_element(class: 'product-grid').save_screenshot('public/images/grid.png')
    ensure
      @@driver.quit
    end

  end
end