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
      start_crawler

      Sale.transaction do
        @ary = @@driver.find_elements(css: @pipeline.target).map do |element|
          sales_info = Transform::SalesDetailsExtractor.parse(element.text)

          Load::SalesBuilder.call(pipeline: @pipeline, **sales_info)
        end
      end

    rescue StandardError => e
      debugger
      Rails.logger.fatal "Failed to scrape #{@pipeline.website} with error #{e} \n #{caller_locations}"
    ensure
      @@driver.quit
    end

    @ary
  end


  def start_crawler
    @@driver.get(@pipeline.website)

    @@wait.until { document_initialised }
  end

  def _screenshot(details)
    # name = details.first.tr(' ', '_').downcase.gsub(/[,|(|)|']/, '')
    # element.save_screenshot("public/images/#{name}.png")
    # TODO: Upload to S3; Add 'thumbnail' column to Packages; Add URL to image
  end
end