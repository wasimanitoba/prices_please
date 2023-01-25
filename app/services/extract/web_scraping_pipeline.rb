class Extract::WebScrapingPipeline
  Selenium::WebDriver::Chrome::Service.driver_path = "/usr/bin/chromedriver"

  create_options = lambda {
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')

    options
  }

  @@wait = Selenium::WebDriver::Wait.new(:timeout => 20)
  @@driver = Selenium::WebDriver.for(:chrome, options: create_options.call)

  def initialize(pipeline)
    @pipeline = pipeline
  end

  def self.crawl!(*args, **kwargs, &block)
    new(*args, **kwargs, &block).crawl!
  end

  def crawl!
    begin
      load_website()

      advertisements = @@driver.find_elements(css: @pipeline.target)

      Sale.transaction { extract_and_save_to_database(advertisements) }
    ensure
      @@driver.quit
    end
  end

  private

    def load_website
      @@driver.get(@pipeline.website)

      @@wait.until { document_initialised }
    end

    def document_initialised
      @@driver.find_element(css: @pipeline.target)
    end

    def extract_and_save_to_database(advertisements)
      advertisements.each do |ad|
        Load::SalesBuilder.call(pipeline: @pipeline, **Transform::SalesDetailsExtractor.call(ad.text))

        screenshot(ad, extract_name_for_path(ad.text))
      end
    end

    # TODO: Upload to S3; Add 'thumbnail' column to Packages; Add URL to image
    def screenshot(element, file)
      element.save_screenshot("public/images/#{file}.png")
    end

    def extract_name_for_path(element)
      element.
       text.
       first.                  # first string is the name
       tr(' ', '_').           # remove spaces
       downcase.               # lowercase
       gsub(/[,|(|)|']/, '')   # remove punctuation
    end
end