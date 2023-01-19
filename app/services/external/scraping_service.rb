class External::ScrapingService
  REJECTIONS = ["ADD", "New", "LIMIT", "MULTI", "SALE", "LOW STOCK"]
  OTHER_REJECTIONS = %w[Ends SAVE]

  Selenium::WebDriver::Chrome::Service.driver_path = "/usr/bin/chromedriver"

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')

  @@wait = Selenium::WebDriver::Wait.new(:timeout => 20)
  @@driver = Selenium::WebDriver.for :chrome, options: options

  def document_initialised
    @@driver.find_element(css: @target)
  end

  def initialize(pipeline, user)
    @department = pipeline.department
    @website = pipeline.website
    @store = pipeline.store
    @target = pipeline.target
    @user = user
  end

  def crawl!

    begin
      @@driver.get(@website)

      @@wait.until { document_initialised }

      Sale.transaction do
        @ary = @@driver.find_elements(css: @target).map do |element|

          details = element.text.split(/\n/)

          # name = details.first.tr(' ', '_').downcase.gsub(/[,|(|)|']/, '')
          # element.save_screenshot("public/images/#{name}.png")

          selected_items = details.reject do |word|
            REJECTIONS.include?(word) || OTHER_REJECTIONS.any? { |rejection| word.match?(rejection) }
          end

          GroceryCreationService.call(selected_items, store: @store, department: @department, user: @user)
        end
      end

    ensure
      @@driver.quit
    end

    @ary
  end
end