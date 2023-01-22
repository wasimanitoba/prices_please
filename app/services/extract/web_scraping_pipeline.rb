class Extract::WebScrapingPipeline
  Selenium::WebDriver::Chrome::Service.driver_path = "/usr/bin/chromedriver"

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')

  @@wait = Selenium::WebDriver::Wait.new(:timeout => 20)
  @@driver = Selenium::WebDriver.for :chrome, options: options

  def document_initialised
    @@driver.find_element(css: @pipeline.target)
  end

  def initialize(pipeline)
    @pipeline = pipeline
  end

  def self.crawl!(*args, **kwargs, &block)
    new(*args, **kwargs, &block).crawl!
  end

  def crawl!
    begin
      load_website

      crawl_target
    ensure
      @@driver.quit
    end
  end

  def crawl_target
    @@driver.find_elements(css: @pipeline.target).map do |element|
      Load::SalesBuilder.call pipeline: @pipeline, **Transform::SalesDetailsExtractor.call(element.text)
    end
  end

  def load_website
    @@driver.get(@pipeline.website)

    @@wait.until { document_initialised }
  end

  def _screenshot(details)
    # name = details.first.tr(' ', '_').downcase.gsub(/[,|(|)|']/, '')
    # element.save_screenshot("public/images/#{name}.png")
    # TODO: Upload to S3; Add 'thumbnail' column to Packages; Add URL to image
  end
end